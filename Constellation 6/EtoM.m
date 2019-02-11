function out=EtoM(lat_deg,lat_min,lat_sec,long_deg,long_min,long_sec,h)

% three inner functions do conversions
% 1 ellipsoidal to cartesion on WGS84
% 2 similarity transform
% 3 cartesian to ellipsoidal on ANS
% 4 ellipsoidal to conformal transverse
%                  Mercator AMG66
%
%********************************************
%  written by peter mumford
% for GMAT 2700 assignment 1  may 2000
%********************************************

global xyz		% array [x y z]
global xyz2		% array [x2 y2 z2]
global laloh	% array [lat long h]
global EN		% array [east north]

%*********************************************
% M A I N
%*********************************************

% call function 1
EtoC_WGS84(lat_deg,lat_min,lat_sec,long_deg,long_min,long_sec,h);
% call function 2
similarity(xyz(1),xyz(2),xyz(3))
% call function 3
CtoE_ANS(xyz2(1),xyz2(2),xyz2(3));
% call function 4
EtoM_AGM66(laloh(1),laloh(2));
% output to array (Easting, northing)
out=[EN];

function EtoC_WGS84(lat_deg,lat_min,lat_sec,long_deg,long_min,long_sec,h)
%this function converts ellipsoidal, earth centred, and fixed latitude, longitude and hieghts to cartesian earth centred and fixed coordinates.
%Arguments are: latitude degrees, minutes and seconds, longitude degree, minutes and seconds, hieght, semi-major axis, and invers flatening.
%(in all nine arguments)

global xyz		% array [x y z]

if nargin~=7, error('seven arguments required'), end
   
   %rad conversion
long = pi*abs(long_deg)/180 + pi*abs(long_min)/10800 + pi*abs(long_sec)/648000;
lat = pi*abs(lat_deg)/180 + pi*abs(lat_min)/10800 + pi*abs(lat_sec)/648000;

%put the sign back

if long_deg<0
   long=-long;
end

if lat_deg<0
   lat=-lat;
end
%WGS84 reference ellipsoid
invflat=298.257223563;
semimajor=6378137.0;

%f is the flattening
f=1/invflat;

%esq is a function of flatening
esq=2*f-f^2;

%N is function of latitude and flatening
N=semimajor/(sqrt(1-esq*(sin(lat))^2));

%main conversion calcs
x=(N+h)*cos(lat)*cos(long);
y=(N+h)*cos(lat)*sin(long);
z=(N*(1-esq)+h)*sin(lat);

%output
xyz=[x y z];
return

% function 2

function similarity(x1,y1,z1)

% this function transforms the cartesian
% coordinates from the WGS84 ellipsoid
% to the cartesian coordinates on the
% ANS ellipsoid
global xyz2;

format long;
in=[x1 y1 z1]';

% parameters
Dx=117.763;
Dy=51.51;
Dz=-139.061;

T=[Dx Dy Dz]';

Rx=0.292*pi/648000; %radians
Ry=0.443*pi/648000; %radians
Rz=0.277*pi/648000;
Sc=1+0.191/1000000; %scale

% set up matrix
R1=[1 0 0
   0 cos(Rx) sin(Rx)
   0 -sin(Rx) cos(Rx)];

R2=[cos(Ry) 0 -sin(Ry)
   0 1 0
   sin(Ry) 0 cos(Ry)];

R3=[cos(Rz) sin(Rz) 0
   -sin(Rz) cos(Rz) 0
	0 0 1];

out=T+Sc*R3*R2*R1*in;
xyz2=out';
return

% function 3

function CtoE_ANS(x,y,z)

%This function transforms cartesian coordinates(earth centered, earth fixed)
%to ellipsoidal (earth centered, earth fixed) coordinates.
%input x, y, z

global laloh	% array [lat long h]

if nargin~=3, error('three arguments required'), end
format long;
%main calc lines
%ANS reference ellipsoid
invflat=298.25;
semimajor=6378160;
%f is the flattening
f=1/invflat;

%esq is a function of the flattening
esq=2*f-f^2;

p=sqrt(x^2+y^2);		
r=sqrt(p^2+z^2);
u=atan2(z*(1-f+(esq*semimajor)/r), p);
long=atan2(y, x);
lat=atan2((z*(1-f)+esq*semimajor*(sin(u))^3), ((1-f)*(p-esq*semimajor*(cos(u))^3)));
h=p*cos(lat)+z*sin(lat)-semimajor*sqrt(1-esq*(sin(lat))^2);
laloh=[lat long h];

return

% function 4

function EtoM_AGM66(lat,long)

% this function converts ellipsoidal coordinates
% to conformal transverse Mercator coordinates
% using formulae given in GDA manual
% input latitude and longitude in radians

global EN

if nargin~=2, error('latitude, longitude required as input'), end
format long

% deg conversion
longitude=(long/(2*pi))*360;

% find zone (6 degree zones, 60 total)
% zone 1 has 177 degrees west longitude
% as central meridian
% ie -177 degrees
zone=fix((longitude+180)/6+1);
% long0 is the zone central meridian
% convert to radians
long0=(((zone-1)*6)-177)*2*pi/360;

% set up constants
% ANS reference ellipsoid
invflat=298.25;
a=6378160;
% f is the flatening
f=1/invflat;
esq=2*f-f^2;
e=sqrt(esq);
% V is radius of curvature in meridian
% normal section on ellipsoid
V=a/(sqrt(1-esq*(sin(lat))^2));
% P is radius of curvature in prime
% vertical normal section on ellipsoid
P=a*(1-esq)/((1-esq*(sin(lat))^2)^(3/2));
% W (upper case)
W=V/P;

T=tan(lat);
% K0 is the central scale factor
K0=0.9996;
% w (lower case) is the change in longitude
% long0 (long-zero) is the origin longitude
w=long-long0;
% false easting and northing
fEast=500000;
fNorth=10000000;
% M meridian distance
A0=1-esq/4-(3/64)*(e^4)-(5/256)*(e^6);
A2=(3/8)*(esq+(e^4)/4+(15/128)*(e^6));
A4=(15/256)*(e^4+(3/4)*(e^6));
A6=(35/3072)*(e^6);
M=a*(A0*lat-A2*sin(2*lat)+A4*sin(4*lat)-A6*sin(6*lat));

%*********************
%* main calculations *
%*********************

% term calcs first
t1=((w^2)/6)*((cos(lat))^2)*(W-(T^2));
t2=((w^4)/120)*((cos(lat))^4)*((4*(W^3))*(1-6*(T^2))+(W^2)*(1+8*(T^2))-W*2*(T^2)+T^4);
t3=((w^6)/5040)*((cos(lat))^6)*(61-479*(T^2)+179*(T^4)-T^6);

East=(K0*V*w*cos(lat))*(1+t1+t2+t3)+fEast;
%*****************************************

% next bunch of terms
t4=((w^2)/2)*V*sin(lat)*cos(lat);
t5=((w^4)/24)*V*sin(lat)*((cos(lat))^3)*(4*(W^2)+W-T^2);
t6=((w^6)/720)*V*sin(lat)*(cos(lat)^5)*(8*(W^4)*(11-24*(T^2))-28*(W^3)*(1-6*(T^2))+(W^2)*(1-32*(T^2))-W*(2*(T^2))+T^4);
t7=((w^8)/40320)*V*sin(lat)*((cos(lat))^7)*(1385-3111*(T^2)+543*(T^4)-T^6);

North=K0*(M+t4+t5+t6+t7)+fNorth;
%*******************************************
EN=[East North];
return

   
   
