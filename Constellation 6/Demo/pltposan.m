function fig_handle = pltnav(auto_mode)

% Example function to plot processed simulated PR measurements with S/A
% The data are loaded from the file demoplt1.mat
% which is generated by the example function demoplt1.m
% Input:
%   auto_mode = optional flag (only include when in auto mode)

% Written by: Jimmy LaMance 9/5/97
% Copyright (c) 1998 by Constell, Inc.

% load in the data
load demoplt1

% compute the total position error and add it to the NED position error matrix
[unit_err, total_pos_err] = normvect(pos_err_ned_dgps);

pos_err_ned_dgps = [pos_err_ned_dgps total_pos_err];

% compute statistics
sigma = std(pos_err_ned_dgps(:,1:3));
ned_mean = mean(pos_err_ned_dgps(:,1:3));

% build strings for the statistics legend
n_string = sprintf('N \\mu = %4.2f, \\sigma = %4.2f (m)',ned_mean(1),sigma(1));
e_string = sprintf('E \\mu = %4.2f, \\sigma = %4.2f (m)',ned_mean(2),sigma(2));
d_string = sprintf('D \\mu = %4.2f, \\sigma = %4.2f (m)',ned_mean(3),sigma(3));

if nargin < 1,
  % Get the screen size in pixels to use for location of plots
  set(0,'units','pixels');
  screen_size = get(0,'screensize');
  y_max = screen_size(2) + screen_size(4) - 60;
  x_max = screen_size(1) + screen_size(3) - 50;
  x_step = 110;
  y_step = 60 + y_max;

  % set the figure colors to be black background like Matlab 4
  colordef none                                

  % generate the position error figure
  fig_handle = figure('color','black', ...
   'position',[30 50 x_max-30 y_max-50],  ...
   'NumberTitle','off', ...
   'Name','Simulated Position Solution', ...
   'Tag','fign');
end;

% create a string for the plot title (to be put in the cell array)
title_string = sprintf('DGPS Position Error for %d km Baseline',...
                        round(base_line_km)); 

fig_title_cell={'Simulated DGPS Position Solution';};
x = plot_time ./ 60;
y = pos_err_ned_dgps(:,1:3);
axis_label_cell = {'Minutes Since Start'; 'Position Error (m)'; ...
                    title_string;};

legend_cell = {n_string,e_string,d_string};

descriptive_text_cell = ...
 {'What better way to analyze data than with built-in Matlab functions and the';
  'Constellation Toolbox coordinate system transformations.  This examples shows DGPS';
  'position errors in North, East, Down coordinates.  The mean and standard';
  'deviation of the NED position errors are obtained using built-in Matlab MEAN';
  'and STD functions.  The Down component is clearly the dominant error source.';
  'From this point, the user could further explore masking and geometry.'};

if nargin < 1,
  text_win(fig_title_cell,x,y,axis_label_cell,legend_cell, ...
      descriptive_text_cell,1);

  % Determine the location for the plot in upper right corner
  x_min = x_max / 10;
  y_min = y_max / 10;

  % set the figure position
  set(fig_handle,'position',[x_min y_min x_max/1.25 y_max/1.25]);
else,
  fig_handle = gcf;
  text_win(fig_title_cell,x,y,axis_label_cell,legend_cell, ...
      descriptive_text_cell);
end;
  
% end of PLTNAV
