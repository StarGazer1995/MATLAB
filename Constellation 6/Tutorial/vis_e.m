% vis_e.m
%
% Function to demonstrate the visibility and DOPS routines for a location fixed
% on the Earth.  Computes the DOPS, azimuth and elevation to the GPS satellites
% and displays an elevation vs. time, azimuth vs. time, # of satellites visible, 
% and a sky plot showing azimuth/elevation pairs.
%
% See also vis_o.m

% Written by: Maria Evans
% Copyright (c) 1998-2000 Constell, Inc.

% functions called: LLA2ECEF, READYUMA, ALM2GEPH, UTC2GPS, PROPGEPH, LOS,
%                   ECEF2LLA, ECEF2NED, NED2AZEL, VIS_DATA, NED2DOPS,
%                   GPST2SEC, NUM_VIS, PASSDATA, GPS2UTC, MAKEPLOT
         
clear           % clear all variables in workspace
close all   % close all open windows

% Set simulation parameters
%sta_name = ['Boulder'];         						% Station Name
%location = [40.0*pi/180, -105.16*pi/180, 1700.0];   % Lat, long, alt (rad, m)

%sta_name = ['PERTH'];
%location = [-32/180*pi 116/180*pi, 50];

sta_name = ['UNSW'];
location = [(-33-55/60)/180*pi (151+14/60)/180*pi 64];
%UNSW location -33 55 3.63529;151 13 54.63371 64.465 

%sta_name = ['WFAL'];
%location = [(-34-8/60-3.182/3600)/180*pi (150+59/60+41.88804)/180*pi 229.726];


mask = 5.0*pi/180;              						% simple 5 deg elevation Mask (radians)
%start_time = [2003 7 4 0 0 0];          			% Start Date (yr, mon, day, hr, mn, sc)
%stop_time = [2003 7 4 4 0 0];         			% Stop Date (yr, mon, day, hr, mn, sec)
start_time = [2010 6 20 0 0 0];          			% Start Date (yr, mon, day, hr, mn, sc)
stop_time = [2010 6 20 23 59 0];
time_step = 60;             							% Time step (sec)
gps_start_time = utc2gps(start_time);
%alm_file = find_alm(gps_start_time(1));      	% GPS almanac file to be used here
%alm_file = 'E:\Mywork2010\AsianRNSS\yuma169_2010_no16.alm';
alm_file = 'yuma169_2010.alm';
%%%%% BEGIN ALGORITHM CODE %%%%%

% convert the station location from lat, long, alt. to ECEF vector
location_ecef = lla2ecef(location);

% load the GPS almanac for the given almanac week
alm_2_use = readyuma(alm_file);

% sort out the unhealthy satellites
I_gps_good = find(alm_2_use(:,2) == 0);
alm_2_use = alm_2_use(I_gps_good,:);

% convert the almanacs to ephemeris format
[gps_ephem] = alm2geph(alm_2_use);

% first convert the start and stop times to GPS time
start_gps = utc2gps(start_time);
stop_gps = utc2gps(stop_time);

% compute satellite positions in ECEF frame for the given time range and interval
[t_gps,prn_gps,x_gps,v_gps] = propgeph(gps_ephem,start_gps,stop_gps,time_step);

% compute LOS vectors in ECEF frame
[t_los_gps, gps_los, los_ind] = los(t_gps(1,:), location_ecef, ...
                                              t_gps, [prn_gps x_gps]);
prn_gps_los = prn_gps(los_ind(:,2));
location = ecef2lla(location_ecef(los_ind(:,1),:));
%location = ones(size(gps_los,1),1)*location; %lla2ecef,then ecef2lla will change the value slightly
% convert LOS in ECEF to NED frame
[gps_los_ned] = ecef2ned(gps_los, location);

% Compute masking
[az, el] = ned2azel(gps_los_ned);
[az_el_pass, I_pass] = vis_data(mask, [az el]);

% Compute DOPS using Earth-fixed masking to determine the visible satellites
[dops,t_dops] = ned2dops(gps_los_ned(I_pass,:),t_los_gps(I_pass,:));

% Reset the data array to contain only visible data
if any(I_pass),
  % reset the arrays to contain only visible data
  t_los_gps = t_los_gps(I_pass,:);
  az = az(I_pass);
  el = el(I_pass);
  prn_gps_los = prn_gps_los(I_pass);
end;

% compute number of visible satellites
[t_vis, num_sats] = num_vis(t_los_gps);

% Make arrays for using the MAKEPLOT function
visible_data = [az_el_pass t_los_gps prn_gps_los];
[pass_numbers, pass_times, pass_summary] = passdata(t_los_gps, time_step, ...
              [ones(size(prn_gps_los)) prn_gps_los], visible_data(:,1:2));
number_vis = [t_vis,num_sats];
gps_dops = [t_dops dops];

% Compute pass information and print to screen
pass_times_utc = gps2utc(pass_times(:,2:3));
output_array = [pass_times_utc(:,2:3) pass_times_utc(:,1) pass_times_utc(:,4:6) ...
   pass_times(:,4)/60 pass_times(:,5:6) pass_summary(:,1,1)*180/pi ...
   pass_summary(:,2,1)*180/pi pass_summary(:,1,2)*180/pi ...
   pass_summary(:,2,2)*180/pi pass_summary(:,2,4)*180/pi];
fprintf('Start Time of Pass    Duration Ground S/C Rise Az. Elev.  Set Az. Elev. Max Elev.\n');
fprintf('       (UTC)            (min) Station PRN  (deg)   (deg)   (deg)  (deg)   (deg)\n');
fprintf('%2d/%2d/%4d %2d:%2d:%4.1f %7.2f %5d %5d %7.2f %6.2f %7.2f %6.2f %7.2f\n', ...
  output_array');

%fig_handles = makeplot(visible_data, pass_numbers, number_vis, gps_dops,...
%                       'GPS Visibility for Boulder, CO');
fig_handles = makeplot(visible_data, pass_numbers, number_vis, gps_dops,...
                       ['GPS Visibility for ' sta_name]);


%%% End of plotting

% end of vis_e.m
