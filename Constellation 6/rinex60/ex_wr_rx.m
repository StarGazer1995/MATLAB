% ex_wr_rx.m
%
% Example script for writting RINEX formatted observation and ephemeris
% data files.

% Written by: Jimmy LaMance 
% Copyright (c) 2000 by Constell, Inc.

% functions called: UTC2GPS, FIND_ALM, READYUMA, ALM2GEPH,
%                   PROPGEPH, ECEF2NED, PSEUDO_R, ECEF2LLA,
%                   NED2AZEL, VIS_DATA, DOPPLER, LSNAV,
%                   LOS, NED2DOPS, DOPS2ERR, PLOTPASS

% Variables to be used in the examples
start_time = [2000 4 15 0 0 0];         % UTC start time
duration = 1*3600;                     % 1 hour duration
base_station = [40*pi/180 255*pi/180 2000];       % base station coordinates

sample_rate = 20;                   % data sampling every 20 seconds

% Conversion from degree to radians
d2r = pi / 180;

% Compute the stop time based on the start time and duration
start_gps = utc2gps(start_time);
start_gps_sec = gpst2sec(start_gps);
stop_gps_sec = start_gps_sec + duration;
stop_gps = sec2gpst(stop_gps_sec);

% Find the almanac that is most recent to the start time
alm_file = find_alm(start_gps(1));

% Read in the almanac
alm = readyuma(alm_file);

% Sort out the unhealthy satellites
I_healthy = find(alm(:,2) == 0);
alm = alm(I_healthy,:);

% Convert from almanac to ephemeris format
gps_ephem = alm2geph(alm);

% Compute satellite positions in ECEF 
[t_gps,prn_gps,x_gps,v_gps] = propgeph(gps_ephem,start_gps,stop_gps,sample_rate);

% Set the remote time matrix to be the same as the base station
t_base = t_gps(1,:);

% Convert the base and remote station coordinates to ECEF
x_base = ones(size(t_base,1),1) * lla2ecef(base_station);  
v_base = zeros(size(x_base));

% Generate PR measurements for the base and remote stations using default
% values for masking, SA modeling, and random number seeding
% for the base station, force the modeling to have no receiver clock error
% to simulate the base station capability                                       
base_mask = 10*d2r;

% Model SA, tropo, iono, and receiver clock.  Do not model satellite motion,
% Earth rotation, satellite clocks, line baises, or relativity
base_model = [1 1 1 1 1 1 0 0 0 0 0];   % turn all all error models
base_code_noise = .2;
base_carrier_noise = .01;
base_seed = 0; 
max_latency = 2;            % set the maximum latency for a differential corr.

[t_pr_base,prn_base,pr_base,pr_errors_base,base_ndex] = ...
               pseudo_r(t_base,x_base,v_base,t_gps,[prn_gps x_gps],...
                        v_gps,base_model,base_seed, ...
                        base_code_noise, base_carrier_noise);

% Compute Doppler measurements at the site to be used 
% in computing velocity solutions
doppler_model = [1 1 1]; 
dop_noise = .3;
[t_dop,prn_dop,dopp,dop_orb,dop_err] = ...
     doppler(t_base,x_base,v_base,t_gps,[prn_gps x_gps],v_gps,...
             doppler_model,base_seed,dop_noise);

% Compute masking for the base station.  Start by compute the LOS from
% the base to the satellites in ECEF.  This is easily done using the indices
% returned from PSEUDO_R where the LOS has been vectorized.  Masking is
% done external to PSEUDO_R so that it can be performed in any coordinate
% system.  This example is for a station on the surface of the Earth with
% the antenna boresight pointed up.  Therefore, the NED system is used.
los_base_ecef = x_gps(base_ndex(:,2),:) - x_base(base_ndex(:,1),:);

% Rotate the LOS to NED, using the base station as the reference for the NED
% coordinate system and rotation.
ref_lla = ecef2lla(x_base(base_ndex(:,1),:));
los_base_ned = ecef2ned(los_base_ecef,ref_lla);

% Compute the azimuth/elevation of the NED vectors
[az, el] = ned2azel(los_base_ned);

% Apply the masking in the NED coordinate system
[visible_data, I_pass] = vis_data(base_mask,[az el]);

% Remove all of the base station data that did not pass the masking test
t_pr_base = t_pr_base(I_pass,:);
prn_base = prn_base(I_pass,:);
pr_base = pr_base(I_pass,:);   
dopp = dopp(I_pass,:);
dop_orb = dop_orb(I_pass,:);
pr_errors_base = pr_errors_base(I_pass,:);
base_ndex = base_ndex(I_pass,:);
x_ned = los_base_ned(I_pass,:);

% Save the PR, CPH, and Doppler data to a RINEX output file.
% The RINEX standard for file names is ...
%        ssssdddf.yyt      ssss:    4-character station name designator
%                           ddd:    day of the year of first record
%                             f:    file sequence number within day
%                                   0: file contains all the existing
%                                      data of the current day
%                            yy:    year
%                             t:    file type:
%                                   O: Observation file
%                                   N: Navigation file
%                                   M: Meteorological data file
%                                   G: GLONASS Navigation file
% Note, we are letting the info_struct optional input use the default values
%
% Setup the input data in the sat_data structure
% L1 = L1 phase, C1 = L1 code, D1 = L1 Doppler
sat_data.meas_types = ['C1';'L1';'D1'];	
sat_data.data{1} = [t_pr_base prn_base pr_base(:,1)];		% pr_base is nx2 [PR CPH]
sat_data.data{2} = [t_pr_base prn_base pr_base(:,2)];		% pr_base is nx2 [PR CPH]
sat_data.data{3} = [t_pr_base prn_base dopp];	

% Finally write out the RINEX data file
wr_rnx_o('base121A.00o',sat_data);

