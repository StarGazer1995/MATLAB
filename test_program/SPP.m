
function  [sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);
%Script to read Rinex observation file and navigation file and
%to estimate the receiver's position epoch by epoch using CA PR.
%
%Input:
%   STA_name    -   Station name (if it is static data) or name of the test 
%                   (if it is dynamic), recommend 4 characters 
%   Rinex_o     -   The Rinex observation file name
%   NavFile     -   The Rinex navigation file name or YUMA file name
%   YUMA        -   If YUMA=0, NavFile is Rinex file; if YUMA=1, NavFile is YUMA file 
%   x0          -   Provisional ECEF xyz value for LS, x0 can be obtained from
%                   the header of Rinex observation file (1x3)
%   x_true      -   True ECEF xyz value. If x_true = [0 0 0] means the true value 
%                   unknown, using the mean value of the positioning results as 
%                   reference (1x3) 
%   cutoff      -   Marsk of elevation angle in units of degree, default is 10 
%                   degree (1x1)
%Output:
%   sta_xyz_clk -   Estimation of Receiver's ECEF xyz and receiver clock error (nx4)   
%   DOP         -   [PDOP HDOP VDOP] (nx3) 
%   num_sat     -   Number of satllites used of each epoch (nx1)
%
%Some functions in Constellation GNSS TOOLKIT are used

%Author: Binghao Li
%Date: April 2007
%Copyright (c) 2007 by Binghao Li, 
%School of Survey & Spatial Information Systems, UNSW, Australia
%Note: there is a new version of SPP.m which takes the group delay and relativity into account, refer to newSPP.m





C=299792458; %speed of light
EARTH_RATE = 7.2921151467e-5; % WGS-84 value in rad/s

cutoff=cutoff/180*pi;

%read Rinex observation file, if there is a .mat file with the same name
%existing, the .mat file will be read instead
[obs, obs_qual, type_str, clk_off] = rd_rnx_o(Rinex_o);
clear clk_off obs_qual;

CA = find(type_str(:,1) == 'C');

%remove other observations. nobs=[GPS_week GPS_second PRN PR]
nobs=[obs(:, 1:3) obs(:, CA+3)];

%Assume GPS_week doesn't change 
timeInx=find(diff(nobs(:,2))~=0)+1;
timeInx=[1; timeInx];
epochs=obs(timeInx,2);
count=size(timeInx,1);

if YUMA==0
%read Rinex navigation file
%-------------------------------------------------------------------------
%Note: The Rinex navigation file using GPS time as well. To convert year 
%month day hour minu second to GPS second, UTC2GPS is used, however, leap 
%second should not be considered. The readeph.m in Rinex60 has a small 
%error in line 90
% [GPS_week, GPS_sec] = utc2gps(data(2:7)');
%should be
% [GPS_week, GPS_sec] = utc2gps(data(2:7)',0);
%Refer to RINEX-2.10 Format (http://www.ngs.noaa.gov/CORS/Rinex2.html)
%-------------------------------------------------------------------------
    eph = readeph(Rinex_n);
    %Note: the moditied readeph.m is used, Tgd was added as eph(25) by
    %Binghao Li, the new readeph.m would bring some promblems to the old
    %SPP.m, the eph(:,25) must be removed :Binghao Li Nov 2008
    if size(eph,2)==25
       eph(:,25) = [];
    end
else
    %deal with YUMA
    %read in the almanac:
    alm_file = Rinex_n;
    alm = readyuma(alm_file);

    %sort out the unhealthy satellites:
    I_healthy = find(alm(:,2) == 0);
    alm = alm(I_healthy,:);
    % Convert from almanac to GPS ephemeris format:
    eph = alm2geph(alm);
end
t_start=[nobs(:,1) nobs(:,2)];
obs_satpos=[];

%compute each sat's ECEF xyz epoch by epoch
for i=1:size(nobs,1)
    I_eph=find(eph(:,1)==nobs(i,3));
    n=length(I_eph);
    if(n~=0) %can not find ephemeris, ignor this sat
        %find this sat's correct ephem (closest)        
        tmp = I_eph(1);
        dtmin = eph(tmp,20)-nobs(i,2);
        for j=1:length(I_eph) %find the closest ephem
            tmp_dt=eph(I_eph(j),20)-nobs(i,2);
            if abs(tmp_dt) < abs(dtmin)
                tmp=I_eph(j);
                dtmin=tmp_dt;
            end
        end
        gps_ephem=eph(tmp,:);
        
        %Sat time correction 
        toc = gps_ephem(20);
        %assuming it is in the same GPS week, hence only GPS_sec is considerd
        tx_RAW = nobs(i,2)-nobs(i,4)/C;
        tx_GPS = tx_RAW;
        for j=1:2
            dt = tx_GPS-toc;
            if dt >  302400 
                dt = dt-2*302400;
            end
            if dt < -302400
                dt = dt+2*302400; 
            end
            tcorr = (gps_ephem(23)*dt + gps_ephem(22))*dt + gps_ephem(21);
            tx_GPS = tx_RAW-tcorr;
        end
        nobs(i,5) = tx_GPS;
        %comput the sat's position at the transmission time
        t_start(i,2)=tx_GPS;
        [t_out, prn, x, v] = propgeph(gps_ephem, t_start(i,:));

        %conside the rotation of the earth
        %traval_time here is used to compute the rotation of the earth, do
        %not have to be very accurate
        traval_time=nobs(i,4)/C;
        R3=[cos(EARTH_RATE*traval_time) sin(EARTH_RATE*traval_time) 0; 
            -sin(EARTH_RATE*traval_time) cos(EARTH_RATE*traval_time) 0;
            0 0 1];
        nx=(R3*x')';
        %obs_satpos=[GPS_week, GPS_sec, PRN, PR, transmision_time, sat_clk_corr, satX, satY, satZ]
        obs_satpos=[obs_satpos; [nobs(i,:) tcorr nx]];
    end
end

%using the provisional value to compute the sat az and el
station = x0;
ref_lla = ecef2lla(station,1);
sat=obs_satpos(:,7:9);
station = ones(size(obs_satpos,1),1)*station;
los=sat-station;
sat_NED = ecef2ned(los,ref_lla);
[sat_az,sat_el] = ned2azel(sat_NED);

%using model to estimate the trop delay and iono delay
[trop_dry, trop_wet] = tropdlay(sat_el);
iono_delay = ionodlay(obs_satpos(:,1:2),ref_lla,sat_az,sat_el);
 trop_dry=0;
 trop_wet=0;
 iono_delay=0;
%correct the PR
obs_satpos(:,4)=obs_satpos(:,4)-trop_dry-trop_wet-iono_delay;

%using LS to estimate the receiver's position epoch by epoch 
x0_clk=[x0 0];
%only process 1-24 hours data, using GPS_sec to distinguish different epochs
sta_xyz_clk=[];
DOP=[];
num_sat=[];
unitvar=[];
lsdX=[];
lsdY=[];
lsdZ=[];
lsdE=[];
lsdN=[];
lsdU=[];
for t=1:1:count
    I=find(obs_satpos(:,2)==epochs(t));
    tmp_el=sat_el(I);
    %Note: the sat clock error = - sat clock correction
    sat_xyz_clk=[obs_satpos(I,7:9) obs_satpos(I,6)*C*(-1)];
    pr_obs=[obs_satpos(I,4)];
    
    %cut off the low elevation angle sats
    I_el=find(tmp_el>cutoff);
    sat_xyz_clk=sat_xyz_clk(I_el,:);
    pr_obs=pr_obs(I_el);
    
    %using LBH's spp_pos (or the sample spp_pos)
    [ls_xyz_clk,ls_cov,ls_cov_enu,ls_res,ls_unitvar,dops]=spp_pos(x0_clk,sat_xyz_clk,pr_obs);  %%%%%%%%changing
    sta_xyz_clk=[sta_xyz_clk; ls_xyz_clk];
    DOP=[DOP;dops];
    num_sat=[num_sat; length(I_el)];
    unitvar=[unitvar;ls_unitvar]; %%%%%%%%%%%adding
    lsdX=[lsdX;1.96*sqrt(ls_cov(1,1))];
    lsdY=[lsdY;1.96*sqrt(ls_cov(2,2))];
    lsdZ=[lsdZ;1.96*sqrt(ls_cov(3,3))];
    lsdE=[lsdE;1.96*sqrt(ls_cov_enu(1,1))];
    lsdN=[lsdN;1.96*sqrt(ls_cov_enu(2,2))];
    lsdU=[lsdU;1.96*sqrt(ls_cov_enu(3,3))];   
end

save sta_xyz_clk sta_xyz_clk;

%visualize the results
sta_lla = ecef2lla(sta_xyz_clk(:,1:3),1);

if x_true == [0 0 0];
    %if x_true unknown, use average of the results as reference
    sta_xyz_true = mean(sta_xyz_clk(:,1:3),1);
else
    sta_xyz_true = x_true;
end

sta_lla_true=ecef2lla(sta_xyz_true,1);
sta_los=sta_xyz_clk(:,1:3)-ones(size(sta_lla,1),1)*sta_xyz_true;
%difference of the calculated value and the true value in NED
staNED=ecef2ned(sta_los,sta_lla_true);
sta_ENU=[0 1 0;1 0 0;0 0 -1]*staNED';
sta_ENU=sta_ENU';
str_week = num2str(nobs(1,1));
str_sec = num2str(nobs(1,2));
xlabel_str = sprintf('seconds past GPS week %s, GPS sec %s',str_week, str_sec);

% figure;
% plot(epochs-epochs(1),staNED(:,1), '.');
% title_str=sprintf('%s North',STA_name);
% title(title_str);
% xlabel(xlabel_str);
% ylabel('Northing differences (m)');
% 
% figure;
% plot(epochs-epochs(1),staNED(:,2), '.');
% title_str=sprintf('%s East',STA_name);
% title(title_str);
% xlabel(xlabel_str);
% ylabel('Easting differences (m)');
% 
% figure;
% plot(epochs-epochs(1), staNED(:,3),'.');
% title_str=sprintf('%s Height',STA_name);
% title(title_str);
% xlabel(xlabel_str);
% ylabel('Height differences (m)');
% 
% figure;
% plot(staNED(:,2), staNED(:,1),'.');
% title_str=sprintf('%s North-East',STA_name);
% title(title_str);
% xlabel('East (m)');
% ylabel('North (m)');
% 
figure (1);
plot(epochs-epochs(1),DOP(:,1),epochs-epochs(1),DOP(:,2), ...
    epochs-epochs(1),DOP(:,3),epochs-epochs(1), num_sat);
legend('PDOP','HDOP','VDOP','num of sat');
title_str=sprintf('%s DOPs',STA_name);
title(title_str);
xlabel(xlabel_str);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean_X = mean(sta_xyz_clk(:,1));
mean_Y = mean(sta_xyz_clk(:,2));
mean_Z = mean(sta_xyz_clk(:,3));   
sd_X = std(sta_xyz_clk(:,1));
sd_Y = std(sta_xyz_clk(:,2));
sd_Z = std(sta_xyz_clk(:,3));
rms_X = sqrt(sum( (sta_xyz_clk(:,1) - sta_xyz_true(1)).^2)/(count));
rms_Y = sqrt(sum( (sta_xyz_clk(:,2) - sta_xyz_true(2)).^2)/(count));
rms_Z = sqrt(sum( (sta_xyz_clk(:,3) - sta_xyz_true(3)).^2)/(count));

mean_E = mean(sta_ENU(:,1));
mean_N = mean(sta_ENU(:,2));
mean_U = mean(sta_ENU(:,3));
sd_E = std(sta_ENU(:,1));
sd_N = std(sta_ENU(:,2));
sd_U = std(sta_ENU(:,3));
rms_E = sqrt(sum( (sta_ENU(:,1)).^2)/(count));
rms_N = sqrt(sum( (sta_ENU(:,2)).^2)/(count));
rms_U = sqrt(sum( (sta_ENU(:,3)).^2)/(count));

mean_unitvar=mean(unitvar); 

Q1=[epochs obs_satpos(1:count,1) sta_xyz_clk(:,1) sta_xyz_clk(:,2) sta_xyz_clk(:,3) lsdX lsdY lsdZ...
    sta_ENU(:,1) sta_ENU(:,2) sta_ENU(:,3) lsdE lsdN lsdU num_sat DOP(:,1) DOP(:,2) DOP(:,3) unitvar];

Q2=[mean_X mean_Y mean_Z sd_X sd_Y sd_Z rms_X rms_Y rms_Z ...
    mean_E mean_N mean_U sd_E sd_N sd_U rms_E rms_N rms_U mean_unitvar]
fid=fopen(file,'wt')
fprintf(fid,'gps_sec gps_week X Y Z lsdX lsdY lsdZ E N U lsdE lsdN lsdU num_sat pdop hdop vdop unit_variance\n');
fprintf(fid, '%g %g %f %f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.0f %.3f %.3f %.3f %.3f \n', Q1');   
fprintf(fid, '\n mean_X mean_Y mean_Z sd_X sd_Y sd_Z rms_X rms_Y rms_Z mean_E mean_N mean_U sd_E sd_N sd_U rms_E rms_N rms_U mean_unit_variance\n');
fprintf(fid,'%0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f %0.3f\n', Q2); 
fclose(fid);

figure (2);
subplot(3,1,1);
plot(epochs-epochs(1),sta_ENU(:,1),'.',epochs-epochs(1),lsdE,'.');
legend('E','sd_E');
title_str=sprintf('%s Easting coordinates and standard deviation ',STA_name);
title(title_str);
xlabel(xlabel_str);

subplot(3,1,2);
plot(epochs-epochs(1),sta_ENU(:,2),'.',epochs-epochs(1),lsdN,'.');
legend('N','sd_N');
title_str=sprintf('%s Northing coordinates and standard deviation ',STA_name);
title(title_str);
xlabel(xlabel_str);

subplot(3,1,3);
plot(epochs-epochs(1),sta_ENU(:,3),'.',epochs-epochs(1),lsdU,'.');
legend('U','sd_U');
title_str=sprintf('%s Up coordinates and standard deviation ',STA_name);
title(title_str);
xlabel(xlabel_str);

figure (3);
plot(epochs-epochs(1),unitvar,'.');
legend('unit_variance');
title_str=sprintf('%s unit_variance ',STA_name);
title(title_str);
xlabel(xlabel_str);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lsdX_new=mean_unitvar*lsdX;
% lsdY_new=mean_unitvar*lsdY;
% lsdZ_new=mean_unitvar*lsdZ;
lsdE_new=sqrt(mean_unitvar)*lsdE;
lsdN_new=sqrt(mean_unitvar)*lsdN;
lsdU_new=sqrt(mean_unitvar)*lsdU;
mean_unitvar
figure (4);
subplot(3,1,1);
plot(epochs-epochs(1),sta_ENU(:,1),'.',epochs-epochs(1),lsdE_new,'.');
legend('E','sd_E');
title_str=sprintf('%s Easting coordinates and standard deviation ',STA_name);
title(title_str);
xlabel(xlabel_str);

subplot(3,1,2);
plot(epochs-epochs(1),sta_ENU(:,2),'.',epochs-epochs(1),lsdN_new,'.');
legend('N','sd_N');
title_str=sprintf('%s Northing coordinates and standard deviation ',STA_name);
title(title_str);
xlabel(xlabel_str);

subplot(3,1,3);
plot(epochs-epochs(1),sta_ENU(:,3),'.',epochs-epochs(1),lsdU_new,'.');
legend('U','sd_U');
title_str=sprintf('%s Up coordinates and standard deviation ',STA_name);
title(title_str);
xlabel(xlabel_str);
