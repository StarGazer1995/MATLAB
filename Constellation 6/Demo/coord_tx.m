%
% function to build gui for coordinate transformations
%
% Create main figure
ydim = 200;
xdim = 400;

coord_fig = figure('Color','white', ...
	'Position',[100 200 xdim ydim], ...
        'NumberTitle','off',...
        'Name','COORDINATE TRANSFORMATIONS',...
	'Tag','Fig1');

coord_str = {'Azimuth/Elevation'; ...
             'Body-Fixed'; ...
             'Earth-Centered-Earth-Fixed'; ...
             'Earth-Centered-Inertial'; ...
             'Latitude-Longitude-Altitude'; ...
             'Local-Level'; ...
             'North-East-Down';};

%num_entries = {2;
               

coord_1 = uicontrol(coord_fig,...
  'style','listbox',...
  'position',[10 ydim-125 160 120],...
  'backgroundcolor','white',...
  'string',coord_str);
