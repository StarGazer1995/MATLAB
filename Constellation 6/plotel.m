function p_handle = plotel(az,el,t,prn,mask,plot_title)

% p_handle = plotel(az,el,t,prn,mask,plot_title);
%
% Function to plot elevation as a function of time for a single observer
% and return the plot handle.  Each arc generated by a satellite is colored and
% labeled with the prn number. This function will use the current figure
% if one is available. Otherwise, a figure will be created. Zoom 
% capability is added to the figure. See help on ZOOM for more information.
%
% Input:
%   az         - azimuth (-2*pi to 2*pi rad) (nx1)
%                 valid values are -2*pi -> 2*pi
%   el         - elevation (-pi/2 to pi/2 rad) (nx1)
%                 valid values are -pi/2 -> pi/2
%   t          - time in GPS format (nx2) [GPS_week GPS_sec]
%                    or (nx3) [GPS_week GPS_sec rollover_flag]
%                valid GPS_week values are 1-1024
%                valid GPS_sec values are 0-604799
%                GPS week values are kept in linear time accounting for
%                1024 rollovers. Include a rollover_flag of 0 for any times
%                prior to August 22, 1999. Default rollover_flag=1
%                indicating time since August 22, 1999.
%   prn        - satellite number corresponding to each az/el pair, 
%                nx1 (optional), if not provided, one az/el track is drawn 
%                assuming one satellite
%   mask       - observer elevation mask as a function of azimuth (rad) 
%                (1x1 or mx3) (optional) default = [0 0 2*pi], see help on 
%                MASK_VIS for more detail about mask parameters
%   plot_title - title of plot (1xm string) (optional) default = 'Elevation Plot'
% Output:
%   p_handle   - graphics handle to the figure
%
% See also PLOTEL, PLOTAZEL, PLOTPOLR, MASK_VIS, NED2AZEL, ECEF2NED

% Written by: Jimmy LaMance 11/8/96
% Copyright (c) 1998 by Constell, Inc.

% functions called: none

%%%%% BEGIN VARIABLE CHECKING CODE %%%%%
% declare the global debug variable
global DEBUG_MODE

% Initialize the output variables
p_handle=[];

% Check the number of input arguments and issues a message if invalid
msg = nargchk(3,6,nargin);
if ~isempty(msg)
  fprintf('%s  See help on PLOTEL for details.\n',msg);
  fprintf('Returning with empty outputs.\n\n');
  return
end

% check that the size of the prn input is valid, if provided
if nargin < 4
  prn = zeros(size(az,1),1);
end % if nargin < 4
% check that the size of mask is valid         
if nargin < 5,
  mask = 0;
end % if nargin < 5
% Check to make sure the title string is a valid size
if nargin < 6,
  plot_title = ['Elevation Plot'];
end % if nargin == 6

% Get the current Matlab version
matlab_version = version;
matlab_version = str2num(matlab_version(1));

% If the Matlab version is 5.x and the DEBUG_MODE flag is not set
% then set up the error checking structure and call the error routine.
if matlab_version >= 5.0                        
  estruct.func_name = 'PLOTEL';

  % Develop the error checking structure with required dimension, matching
  % dinemsion flags, and input dinemsions.
  estruct.variable(1).name = 'az';
  estruct.variable(1).req_dim = [901 1];
  estruct.variable(1).var = az;
  estruct.variable(1).type = 'ANGLE_RAD';
  
  estruct.variable(2).name = 'el';
  estruct.variable(2).req_dim = [901 1];
  estruct.variable(2).var = el;
  estruct.variable(2).type = 'ELEVATION_RAD';
  
  estruct.variable(3).name = 't';
  estruct.variable(3).req_dim = [901 2; 901 3];
  estruct.variable(3).var = t;
  estruct.variable(3).type = 'GPS_TIME';
  
  estruct.variable(4).name = 'prn';
  estruct.variable(4).req_dim = [901 1];
  estruct.variable(4).var = prn;
  
  estruct.variable(5).name = 'mask';
  estruct.variable(5).req_dim = [1 1; 902 3; 902 4];
  estruct.variable(5).var = mask;
  
  % Call the error checking function
  stop_flag = err_chk(estruct);
  
  if stop_flag == 1           
    fprintf('Invalid inputs to %s.  Returning with empty outputs.\n\n', ...
             estruct.func_name);
    return
  end % if stop_flag == 1
end % if matlab_version >= 5.0 & isempty(DEBUG_MODE) 

%%%%% END VARIABLE CHECKING CODE %%%%%

%%%%% BEGIN ALGORITHM CODE %%%%%

% find satellites above the mask
I_vis = mask_vis(az, el, mask);
if ~any(I_vis), % there are no visible satellites
  fprintf('\nWarning message from PLOTEL: \n');
  fprintf('There are no visible satellites.\n');
  fprintf('Returning to calling function without creating a plot.\n');
  p_handle = gcf;
  clf;
  return
else,
  p_handle = gcf;
  clf;
end;

% reset the arrays to contain only visible data
t = t(I_vis,:);
el = el(I_vis);
prn = prn(I_vis);

% convert elevation to degrees for plotting
el = el * 180 / pi;

% convert GPS time to linear time past an epoch
week_min = min(t(:,1));

% seconds past a minimum week
t_lin = (t(:,1) - week_min) * 604800 + t(:,2);

% sort the data in time (linear time)
[t_sort, I_sort] = sort(t_lin);

t_lin = t_lin(I_sort);
t = t(I_sort,:);
el = el(I_sort);
prn = prn(I_sort);

% compute the starting UTC time tag
start_utc = gps2utc(t(1,:));
  
% total duration (seconds)
duration = max(t_lin) - min(t_lin);

% set the time scale to be used for the plotting (minutes, hours, or days)
if duration <= 3600        % shorter than an hour
  min_flag = 1;            % flag to use the minute time scale
  hour_flag = 0;           % flag not to use the hour time scale
  day_flag = 0;            % flag not to use the day time scale 
  
  % round to the start of a second
  start_utc(6) = 0;        % 0 seconds into the minute
  
  % convert to GPS time
  start_time_gps = utc2gps(start_utc);
  
  t_lin_start = (start_time_gps(:,1) - week_min) * 604800 + start_time_gps(:,2);
  
  t_plot = (t_lin - t_lin_start) / 60;     % plotting times in minutes
  
elseif duration > 3600 & duration <= 86400  % between an hour and a day
  min_flag = 0;            % flag not to use the minute time scale
  hour_flag = 1;           % flag to use the hour time scale
  day_flag = 0;            % flag not to use the day time scale

  % round to the start of a minute
  start_utc(5) = 0;        % 0 minutes into the hour
  start_utc(6) = 0;        % 0 seconds into the minute
  
  % convert to GPS time
  start_time_gps = utc2gps(start_utc);
  
  t_lin_start = (start_time_gps(:,1) - week_min) * 604800 + start_time_gps(:,2);

  t_plot = (t_lin - t_lin_start) / 3600;   % plotting times in hours

elseif duration > 86400    % longer than a day
  min_flag = 0;            % flag not to use the minute time scale
  hour_flag = 0;           % flag not to use the hour time scale
  day_flag = 1;            % flag to use the day time scale

  % round to the beginning of the day
  start_utc(4) = 0;        % 0 hours into the day
  start_utc(5) = 0;        % 0 minutes into the day
  start_utc(6) = 0;        % 0 seconds into the day
  
  % convert to GPS time
  start_time_gps = utc2gps(start_utc);
  
  t_lin_start = (start_time_gps(:,1) - week_min) * 604800 + start_time_gps(:,2);

  t_plot = (t_lin - t_lin_start) / 86400;  % plotting times in days

end % if duration <= 3600 

% determine the total number of satellites
% start by sorting the prn numbers and looking for changes
prn_sort = sort(prn);
prn_change = find(diff(prn_sort) ~= 0);

% create a matrix that has sorted and reduced prns [1 2 4 5 6 8 ... 28]
active_sats = [prn_sort(prn_change); prn_sort(length(prn_sort))];

% compute the total number of prns 
num_prns = length(active_sats);

% set the colors that will be used in this function
% first check the background color of the graph
graph_color = get(p_handle,'color');
if graph_color==[0 0 0], % Then black background
  avail_colors = ['ymcrgbw'];
else, % Assume which or grey background
  avail_colors = ['ymcrgbk'];
end;
num_colors = length(avail_colors);

for i = 1:num_prns                   % loop over the active satellites
  I = find(prn == active_sats(i));   % all satellites with the same prn number 
  label_color = avail_colors(rem(i,num_colors) + 1);   % cycle through colors
  
  % plot the az/el pairs for this satellite
  p_handle = plot(t_plot(I),el(I),'Color',label_color);

  hold on       % turn hold on so the next satellite is added

  % add prn label to each elevation arc
  % put the label in the center if the satellite is visible then, otherwise put the
  % label at the beginning or the end
  % verify that each has length of at least 2
  if length(t_plot(I)) < 3  % not even 2 points, no labels
    I_mid = []; 
    I_end = []; 
    I_beg = []; 
  
  else
    I_mid = fix(length(I)/2);      % mid point
    I_end = length(I);             % end point
    I_beg = 1;                     % start point
  
  end % if size(t_plot(I) < 3)  % not even 2 points, no labels
  
  if any(I_mid)
    qts = text(t_plot(I(I_mid)),el(I(I_mid)),num2str(active_sats(i)), ...
               'Color',label_color);         % put the label on       
    clear I_mid
  elseif any(I_end)
    qts = text(t_plot(I(I_end)),el(I(I_end)),num2str(active_sats(i)), ...
               'Color',label_color);         % put the label on
    clear I_end
  elseif any(I_beg)
    qts = text(t_plot(I(I_beg)),el(I(I_beg)),num2str(active_sats(i)), ...
               'Color',label_color);         % put the label on
    clear I_beg
  end % if any(I_mid)
end % for

% set the plot label to be Satellite Elevation Plot if it is not already named
if isempty(get(gcf,'Name'))==1,
  set(gcf,'Name','Satellite Elevation Plot')
end;

% label the plot
ylabel('Elevation (deg)')

start_time_string = sprintf('%d/%d/%02d %d:%02d:%02d',  ...
                    start_utc(2),start_utc(3),mod(start_utc(1)-1900,100),start_utc(4:6));

if min_flag == 1        % using the minute time scale
  xlabel_text = sprintf('Minutes past %s ',start_time_string);

elseif hour_flag == 1   % using the hour time scale
  xlabel_text = sprintf('Hours past %s ',start_time_string);

elseif day_flag == 1    % using the day time scale
  xlabel_text = sprintf('Days past %s ',start_time_string);

end % if min_flag == 1

% Add the title and zoom capabilities
title(plot_title);
zoom on       

% finally label the x axis
xlabel(xlabel_text)

%%%%% END ALGORITHM CODE %%%%%

% end PLOTEL

