function [ls_xyz_clk,ls_cov,ls_cov_enu,ls_res,ls_unitvar,dops]= ...
         spp_pos(prov_xyz_clk,sat_xyz_clk,pr_obs)

%the inputs for one epoch data from n satellites are:
%
%   prov_xyz_clk    provisional values of the receiver position 
%                   and clock error in metres (1x4).
%
%   sat_xyz_clk     ECEF xyz coordinates and clock error of the 
%                   GPS satellite in metres (nx4).
%
%   pr_obs          pseudorange observations (nx1).
%
%the outputs are:
%
%   ls_xyz_clk      least squares estimates of the receiver 
%                   position and clock error in metres (1x4).
%
%   ls_cov          the least squres covariance matrix of the 
%                   parameters (4x4)
%
%   ls_res          the least squares residuals (nx1)
%
%   ls_unitvar      the least squares unit variance
%
%   dops            including Pdop Hdop Vdop(1x3)
%
%The least squares solution include iteration that will cease 
%when xhat is less than 0.1 m
%Author: Binghao Li
%Date: March 2003

%the scale factor for elevation dependaent stochastic model
sf=1;

%test the input matrices
n1=size(sat_xyz_clk);
n2=size(pr_obs);
if n1(1)~=n2(1)
    disp('the dimensions of sat_xyz_clk and pr_obs must agree.');
    return;
end
n=n1(1);
x0=prov_xyz_clk';

j=0; %j is the counter of the iteration
xhat=[1 1 1 1]'; %initialize xhat

%do iteration if x>=0.1
m=0;
while (sqrt(xhat(1)^2 + xhat(2)^2 + xhat(3)^2) >= 0.1)

    %form A matrix
    for i=1:n
        rSR=((sat_xyz_clk(i,1)-x0(1))^2+(sat_xyz_clk(i,2)-x0(2))^2 ...
            +(sat_xyz_clk(i,3)-x0(3))^2)^0.5;
        
        A(i,1)=-(sat_xyz_clk(i,1)-x0(1))/rSR;
        
        A(i,2)=-(sat_xyz_clk(i,2)-x0(2))/rSR;
    
        A(i,3)=-(sat_xyz_clk(i,3)-x0(3))/rSR;
        
        A(i,4)=1.0;   
    end


    %form b matrix
    for i=1:n
        b(i,1)=pr_obs(i)-sat_xyz_clk(i,4)-(((sat_xyz_clk(i,1)-x0(1))^2 ...
            +(sat_xyz_clk(i,2)-x0(2))^2+(sat_xyz_clk(i,3) ...
            -x0(3))^2)^0.5+x0(4));  
    end
    
    %---------------------------------------------------------------------------
    %form W matrix.
    %step 1: compute base_ecef, sat_ecef and the difference between these 2 ecef
    %step 2: use ecef2lla to calculate base_lla
    %step 3: use ecef2ned to calculate sat_ned (Note:input parameter 1
    %        is the diffrence of sat_ecef and base_ecef)
    %step 4: use ned2azel to calculate satellite elevation(rad)
    %step 5: compute Cl,segma=sf*1/sin(elevation)
    %step 6: W=inv(Cl)
    %----------------------------------------------------------------------------
    base_ecef=x0(1:3,1)';
    sat_ecef=sat_xyz_clk(:,1:3);
    for i=1:n
        diff_sat_base_ecef(i,:)=sat_ecef(i,:)-base_ecef;
    end
    base_lla=ecef2lla(base_ecef, 1);
    sat_ned=ecef2ned(diff_sat_base_ecef,base_lla);
    [sat_az,sat_el]=ned2azel(sat_ned);
    sat_el_d=sat_el./pi.*180.0;
    segma2=sin(sat_el);
    segma2=(sf*1./sin(sat_el)).^2;
    Cl=zeros(n,n);
    for i=1:n
        Cl(i,i)=segma2(i);
    end
    W=inv(Cl);

    xhat=inv(A'*W*A)*A'*W*b;
    xls=x0+xhat;
    %use current xls as new x0, iterate
    x0=xls;

    %count the times of iteration
    
    gz=sqrt(xhat(1)^2 + xhat(2)^2 + xhat(3)^2)
    m=m+1
end

ls_xyz_clk=xls';
ls_cov=inv(A'*W*A);%this ls_cov does not relate to the dop value, W is not I matrix
ls_res=A*xhat-b;
%vhat e.g. ls_res,m=4
ls_unitvar=(ls_res'*W*ls_res)/(n-4);
Dxhat=inv(A'*A);
%get the final base ecef
base_ecef=xls(1:3,1)';
%change the final ecef to lla(fi-latitude lambta-longitude)
base_lla=ecef2lla(base_ecef, 1);
fi=base_lla(1);
lambta=base_lla(2);
R=[-sin(fi)*cos(lambta) -sin(fi)*sin(lambta) cos(fi); ...
        -sin(lambta) cos(lambta) 0; ...
        cos(fi)*cos(lambta) cos(fi)*sin(lambta) sin(fi)];
Dxhatlocal=R*Dxhat(1:3,1:3)*R';
ls_cov_enu = R*ls_cov(1:3,1:3)*R';
PDOP=sqrt(Dxhat(1,1)+Dxhat(2,2)+Dxhat(3,3));
HDOP=sqrt(Dxhatlocal(1,1)+Dxhatlocal(2,2));
VDOP=sqrt(Dxhatlocal(3,3));
dops=[PDOP HDOP VDOP];
j=j+1;
end