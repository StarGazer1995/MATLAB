% ex_dgps.m
%
% Example script for generating GPS and DGPS measurements and computing position
% and velocity solutions using the raw data. This example is for a dynamic 
% receiver with position, velocity, and error.

% Written by: Jimmy LaMance 
% Copyright (c) 1999-2000 by Constell, Inc.

% functions called: UTC2GPS, FIND_ALM, READYUMA, ALM2GEPH,
%                   PROPGEPH, ECEF2NED, PSEUDO_R, ECEF2LLA,
%                   NED2AZEL, VIS_DATA, DOPPLER, LSNAV, DIFFCORR,
%                   ADD_DPR, LOS, NED2DOPS, DOPS2ERR, PLOTPASS

% Variables to be used in the examples
start_time = [1998 7 4 0 0 0];        % UTC start time

% Select a base station location close to the start of the trajectory
% or wherever the base station will be located.  The airplane trajectory
% starts at lat/lon [0,0].  The pi/180 is just a reminder.
base_station = [0*pi/180 0*pi/180 0];       % base station coordinates

% Conversion from degree to radians
d2r = pi / 180;

% Compute the stop time based on the start time and duration
% first convert the start time to GPS time
[startweek startsec startday roll] = utc2gps(start_time);
if roll==0,
    start_gps=[startweek startsec roll];
else
    start_gps=[startweek startsec];
end

start_gps_sec = gpst2sec(start_gps);

% Read in airplane data:  time, position, velocity, attitude
load airplane.dat;              % aircraft data in an ascii file
ac_time_lin = airplane(:,1);        % aircraft relative time: 0-300 sec
ac_pos = [airplane(:,2:4)];     % aircraft ECEF xyz position (m)
ac_vel = [airplane(:,5:7)];     % aircraft ECEF xyz velocity (m/s)
ac_att = [airplane(:,8:10)];    % aircraft attitude wrt NED (deg)
ac_att = ac_att*d2r;            % convert to radians

% Convert aircraft relative time to gps time, using start_time as time0
ac_time_s = ac_time_lin + start_gps_sec;  % absolute aircraft time (secs)
ac_time = sec2gpst(ac_time_s);      % GPS time version of ac_time

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
[t_gps,prn_gps,x_gps,v_gps] = propgeph(gps_ephem,ac_time);

% Set the remote time matrix to be the same as the base station
t_base = t_gps(1,:);

% Convert the base and remote station coordinates to ECEF
x_base = lla2ecef(base_station);                 
v_base = zeros(size(x_base));

% Compute the base line length
base_line_ecef(:,1) = x_base(1) - ac_pos(:,1);
base_line_ecef(:,2) = x_base(2) - ac_pos(:,2);
base_line_ecef(:,3) = x_base(3) - ac_pos(:,3);
base_line_ned = ecef2ned(base_line_ecef,ecef2lla(x_base(1,:)));
base_line_km = norm(base_line_ned) / 1000;

% Generate PR measurements for the base and remote stations using default
% values for masking, SA modeling, and random number seeding
% for the base station, force the modeling to have no receiver clock error
% to simulate the base station capability                                       
base_mask = 0*d2r;

% Model SA, tropo, iono, and receiver clock.  Do not model satellite motion,
% Earth rotation, satellite clocks, line baises, or relativity
base_model = [1 1 1 1 1 1 1 0 0 0 0];   % turn on error models
base_code_noise = .2;
base_carrier_noise = .01;
base_seed = 0; 
max_latency = 2;            % set the maximum latency for a differential corr.

[t_pr_base,prn_base,pr_base,pr_errors_base,base_ndex] = ...
               pseudo_r(t_base,x_base,v_base,t_gps,[prn_gps x_gps],...
                        v_gps,base_model,base_seed, ...
                        base_code_noise, base_carrier_noise);

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
pr_errors_base = pr_errors_base(I_pass,:);
base_ndex = base_ndex(I_pass,:);

% Rename the pr_errors for easier use later
pr_sa_errb = pr_errors_base(:,1) + pr_errors_base(:,2);
trop_base = pr_errors_base(:,3) + pr_errors_base(:,4);
iono_base = pr_errors_base(:,5);
clk_biasb = pr_errors_base(:,6);
clk_driftb = pr_errors_base(:,7);

remote_mask = 5*d2r;           
% Model SA, tropo, iono, and receiver clock.  Do not model satellite motion,
% Earth rotation, satellite clocks, line baises, or relativity.  The LSNAV
% function used to compute navigation solutions does not currently support
% this PR modeling.  However, these effects could be modeled and then absorbed
% into the differential correction.
remote_model = [1 1 1 1 1 1 1 0 0 0 0];
remote_code_noise = 1;
remote_carrier_noise = .01;
remote_seed = 0;
[t_pr_remote,prn_remote,pr_remote,pr_errors_remote,remote_ndex] = ...
               pseudo_r(ac_time,ac_pos,ac_vel,t_gps,[prn_gps x_gps],v_gps,...
                        remote_model,remote_seed,...
                        remote_code_noise, remote_carrier_noise);

% Save the remote orbits associate with this PR data into it's own
% matrix for easier booking keeping later.
pr_orb_remote = x_gps(remote_ndex(:,2),:);

% Compute Doppler measurements at the remote site to be used 
% in computing velocity solutions
remote_doppler_model = [1 1 1]; 
remote_dop_noise = .3;
[t_dop,prn_remote_dop,dopp,dop_orb,dop_err] = ...
     doppler(ac_time,ac_pos,ac_vel,t_gps,[prn_gps x_gps],v_gps,...
             remote_doppler_model,remote_seed,remote_dop_noise);

% Compute masking for the remote receiver.  Here again, the NED system is used.
los_remote_ecef = x_gps(remote_ndex(:,2),:) - ac_pos(remote_ndex(:,1),:);

% Rotate the LOS to NED, using the A/C truth as the reference for the NED
% coordinate system and rotation.
ref_lla = ecef2lla(ac_pos(remote_ndex(:,1),:));

% Compute LOS in NED
los_remote_ned = ecef2ned(los_remote_ecef,ref_lla);

% Rotate LOS from NED to body coordinates
los_remote_body = ned2body(los_remote_ned,ac_att(remote_ndex(:,1),:));

% Compute the azimuth/elevation of the body vectors
[az, el] = ned2azel(los_remote_body);

% Apply the masking in the NED coordinate system
[visible_data, I_pass] = vis_data(remote_mask,[az el]);

% Remove all of the remote station data that did not pass the masking test
t_pr_remote = t_pr_remote(I_pass,:);
prn_remote = prn_remote(I_pass,:);
pr_remote = pr_remote(I_pass,:);
pr_orb_remote = pr_orb_remote(I_pass,:);
pr_errors_remote = pr_errors_remote(I_pass,:);
remote_ndex = remote_ndex(I_pass,:);
dopp = dopp(I_pass,:);
dop_orb = dop_orb(I_pass,:);

% Rename the pr_errors for easier use later
pr_sa_errr = pr_errors_remote(:,1) + pr_errors_remote(:,2);
trop_remote = pr_errors_remote(:,3) + pr_errors_remote(:,4);
iono_remote = pr_errors_remote(:,5);
clk_biasr = pr_errors_remote(:,6);
clk_driftr = pr_errors_remote(:,7);

% Compute a position and velocity solution at the remote site without DGPS
[t_nav,x_nav,num_remote,nav_index,v_nav] = ...
     lsnav(t_pr_remote,pr_remote(:,1),...
           [prn_remote x_gps(remote_ndex(:,2),:)],[ac_pos(1,:)+5000 0],dopp, ...
            dop_orb(:,4:6),[0 0 0 0]); 

% Compute differential corrections given the base station locations.  Model
% the GPS satellite clocks, relativistic effects, satellite motion, and
% Earth rotation.  SA, ionosphere, troposphere, and receiver clock are not
% modeled in the PR for computing differential corrections.  If a term is 
% not modeled in the correction, but was included in the PR measurement, it
% will effectively be absorbed into the differential correction. 
diff_model = [0 0 0 0 0 0 0 0 0 0 0];
[t_dpr, dpr] = ...
       diffcorr(t_pr_base, [prn_base pr_base], x_gps(base_ndex(:,2),:), ...
                v_gps(base_ndex(:,2),:), x_base(1,:),diff_model,gps_ephem);
       
% Set the differential correction rate of change to zero
dprr = zeros(size(dpr,1),1);

% Add the corrections to the remote PR measurements
% the return variable cpr_index is an index into the input remote
% site pseudoranges that have differential corrections applied to them  
[t_cpr, prn_cpr, cpr, cpr_index] = ...
      add_dpr(t_pr_remote,[prn_remote pr_remote],t_dpr,dpr,dprr,max_latency);

% Compute a LS nav solotuion at the remote site with DGPS
[t_nav_dgps,x_nav_dgps,num_dgps] = ...
     lsnav(t_cpr,cpr(:,1),[prn_remote(cpr_index) pr_orb_remote(cpr_index,:)],...
           [ac_pos(1,:)+5000 0]); 

% Compute residual troposphere errors using the ADD_DPR function.  this function
% handles all of the common visibility analysis.  Instead of pseudoranges and
% pseudorange corrections, we will send it troposphere errors.  To obtain the
% troposphere differences, we will send in the negative of one set of tropo
% errors.
[t_dtrop, prn_dtrop, dtrop, dtrop_index] = ...
      add_dpr(t_pr_remote,[prn_remote trop_remote],t_pr_base,...
              [prn_base -trop_base],dprr,0);

% Compute the residual ionospheric errors the same way
[t_diono, prn_diono, diono, diono_index] = ...
      add_dpr(t_pr_remote,[prn_remote iono_remote],t_pr_base,...
              [prn_base -iono_base],dprr,0);

% Compute LOS at remote station in ECEF frame
[t_los, los_vect, los_ind] = los(ac_time, ac_pos, t_gps, [prn_gps x_gps]);

% Rotate ECEF los to NED
[x_ned] = ecef2ned(los_vect, ecef2lla(ac_pos(los_ind(:,1),:)));

% Rotate LOS from NED to body coordinates
x_body = ned2body(x_ned,ac_att(los_ind(:,1),:));

[az, el] = ned2azel(x_body);

% Apply the masking in the NED coordinate system
[visible_data, I_pass] = vis_data(remote_mask,[az el]);

% Compute DOPs at the remote station (with masking for the remote station)
[remote_dops, t_dops, num_remote] = ned2dops(x_ned(I_pass,:),t_los(I_pass,:));

% Compute the position errors with and without DGPS
% these vectors are in ECEF
pos_err = x_nav(:,1:3) - ac_pos;
vel_err = v_nav(:,1:3) - ac_vel;
pos_err_dgps = x_nav_dgps(:,1:3) - ac_pos;

% Rotate position difference to NED relative to the truth location
% for easier interpretation                                       
[pos_err_ned] = ecef2ned(pos_err, ecef2lla(ac_pos));
[vel_err_ned] = ecef2ned(vel_err, ecef2lla(ac_pos));
[pos_err_ned_dgps] = ecef2ned(pos_err_dgps, ecef2lla(ac_pos));

% Generate a figure with 2 plots, one with the uncorrected position errors
% and one with differentially corrected position solutions     
plot_time = ac_time(:,2) - ac_time(1,2);  % simple time in seconds

% generate the position error figure
clear fh
fh(1) = figure;
subplot(2,1,1)
plot(plot_time,pos_err_ned)
legend('North','East','Down',-1);
ylabel('Position Err (m)')                
title_string = ...
  sprintf('Position Errors without DGPS for Aircraft Flight');
title(title_string) 

subplot(2,1,2)
plot(pos_err_ned_dgps)
legend('North','East','Down',-1);
ylabel('Position Err (m)')
title_string = ...
  sprintf('Position Errors with DGPS for Aircraft Flight');
title(title_string) 
xlabel('time past start (sec)') 

fh(2) = figure;
plot(plot_time,vel_err_ned)
legend('North','East','Down',-1);
ylabel('Position Err (m)')                
title_string = ...
  sprintf('Velocity Errors without DGPS for Aircraft Flight');
title(title_string)                 

fh(3) = figure;
plot(t_dops(:,2)-t_dops(1,2),remote_dops)
legend('GDOP','PDOP','HDOP','VDOP','TDOP',-1);
xlabel('time past start (sec)') 
ylabel('DOP Value')                
title_string = ...
  sprintf('DOP Values with DGPS Only Satellites Along the Trajectory');
title(title_string)                 



         