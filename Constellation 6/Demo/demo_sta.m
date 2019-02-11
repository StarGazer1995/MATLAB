function demo_sta
global sta_col sta_slct vis_plot sta_sats sta_vis
global vis_handles sta_push sta_slct sta_edt station_fig
global sta_ydim sta_col_str sta_col_ini demo_fig show_flag
%
% Create the window to allow user input to the demo for station
% visibility
%
% Set flag to determine whether this is functional GUI or limited DEMO
op_mode = 'GUI';
% op_mode = 'DEMO';

vis_handles=[];

% Initialize the strings for the table
if ~exist('sta_col_str'),
  set_cols = 1;  % Need to set column values
else,
  set_cols = 0;
end;

sta_col_ini(:,1) = {'Boulder';'';'Guam';'Saint-Denis'};
sta_col_ini(:,2) = {'40.00';'';'13.28';'-20.52'}; % Latitudes
sta_col_ini(:,3) = {'-105.16';'';'144.47';'55.28'}; % Longitudes
sta_col_ini(:,4) = {'4756.0';'';'20.7';'42.3'}; % Altitudes
sta_col_ini(:,5) = {'8.0';'30.0';'5.0';'10.0'}; % Elevation Masks
sta_col_ini(:,6) = {'320.0';'195.6';'0.0';'0.0'}; % Azimuth Min
sta_col_ini(:,7) = {'195.6';'320.0';'360.0';'360.0'}; % Azimuth Max

if set_cols==1 | length(sta_col_str)<1,
  sta_col_str = sta_col_ini;
end;


% Initialize the plotting variables
vis_plot = 0;   % 0 - indicates that no plots are open, 1 - when visibility plots are open

% Get the screen size in pixels to use for location of plots
set(0,'units','pixels');
screen_size = get(0,'screensize');
screen_y_max = screen_size(2) + screen_size(4) - 60;
screen_x_max = screen_size(1) + screen_size(3) - 50;

sta_xmin = 10;
sta_xdim = 820;
sta_ydim = 380;

station_fig(1) = figure( ...
  'Color','Black', ...
  'Units','pixels',...
  'Position',[10 screen_y_max-sta_ydim sta_xdim sta_ydim], ...
  'Visible','On',...
  'NumberTitle','Off',...
  'Name','Visibility from Earth');

sta_frame(1) = uicontrol(station_fig(1),...
  'Style','frame',...
  'Backgroundcolor','white',...
  'Position',[2 2 sta_xdim-4 sta_ydim-4]);

title_str1 = sprintf('%sNorth%sEast%sElevation%sAzimuth Range for%sVisibility Plot Options',...
                 blanks(48),blanks(15),blanks(31),blanks(9),blanks(7));
title_str2 = sprintf('Station%sLatitude%sLongitude%sAltitude%sMask%sElevation Mask%sSky%sAzimuth%sDilution of Precision%sAnimate',...
                      blanks(28),blanks(10),blanks(9),blanks(7), ...
                      blanks(9),blanks(10),blanks(7),blanks(25),blanks(8));
title_str3 = sprintf('Name%s(deg)%s(deg)%s(m)%s(deg)%s(0-360 deg)%sElevation%s# Visible%sGDOP-PDOP-HDOP-VDOP-TDOP',...
                      blanks(31),blanks(16),blanks(18),blanks(10),blanks(13),blanks(19),blanks(4),blanks(2));

sta_label(1) = uicontrol(station_fig(1), ...
  'BackgroundColor','White', ...
  'HorizontalAlignment','left',...
  'string',title_str1, ...
  'position',[10 sta_ydim-30 sta_xdim-20 15],...
  'style','text');

sta_label(2) = uicontrol(station_fig(1), ...
  'BackgroundColor','White', ...
  'HorizontalAlignment','left',...
  'string',title_str2, ...
  'position',[30 sta_ydim-45 sta_xdim-35 15],...
  'style','text');

sta_label(3) = uicontrol(station_fig(1), ...
  'BackgroundColor','White', ...
  'HorizontalAlignment','left',...
  'string',title_str3, ...
  'position',[30 sta_ydim-60 sta_xdim-35 15],...
  'style','text');

% Create the editable text columns
sta_col(1) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','left', ...
  'Position',[10 sta_ydim-255 118 190], ...
  'String',sta_col_str(:,1), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2,...
  'CallBack',[ ...
      '[sta_name,location,mask_info] = get_sta(sta_col);',...
      'if size(sta_name,1)>=1 & size(sta_name,2)>=1,',...
        'set(sta_slct,''string'',sta_name);',...
      'else,',...
        'set(sta_slct,''string'',''None'');',...
      'end;',...
      ]);

sta_col(2) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[136 sta_ydim-255 64 190], ...
  'String',sta_col_str(:,2), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2);

sta_col(3) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[208 sta_ydim-255 64 190], ...
  'String',sta_col_str(:,3), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2);

sta_col(4) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[280 sta_ydim-255 52 190], ...
  'String',sta_col_str(:,4), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2);

sta_col(5) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[340 sta_ydim-255 40 190], ...
  'String',sta_col_str(:,5), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2);

sta_col(6) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[388 sta_ydim-255 50 190], ...
  'String',sta_col_str(:,6), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2);

sta_col(7) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[446 sta_ydim-255 50 190], ...
  'String',sta_col_str(:,7), ...
  'Style','edit', ...
  'FontSize',10,...
  'Max',2);

% Add the visibility plot options
sta_vis=[];
[sta_vis] = plot_opt(sta_col,station_fig(1),sta_ydim,sta_vis);

% Push Buttons
sta_push(1) = uicontrol(station_fig(1), ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','center', ...
    'Position',[sta_xdim-350 8 100 30], ...
    'String','Create Plots', ...
    'Style','push', ...
    'CallBack',[ ...
     'if vis_plot==0,', ...
       '[sta_name,location,mask_info] = get_sta(sta_col);',...
       'if length(sta_name)>0 & length(location)>0 & length(mask_info)>0,',...
         'duration = str2num(get(sta_edt(2),''string''))*3600;',...
         'time_step = str2num(get(sta_edt(3),''string''));',...
         'start_str = deblank(get(sta_edt(1),''string''));',...
         'slash = find(start_str==''/'');',...
         'mon = str2num(start_str(1:slash(1)-1));',...
         'day = str2num(start_str(slash(1)+1:slash(2)-1));',...
         'yr = str2num(start_str(slash(2)+1:slash(2)+2));',...
         'if yr < 50,',...
            'yr = yr + 2000;',...
         'else,',...
            'yr = yr + 1900;',...
         'end;',...
         'hhmmss = start_str(slash(2)+3:length(start_str));',...
         'colon = find(hhmmss=='':'');',...
         'hh = str2num(hhmmss(1:colon(1)-1));',...
         'mm = str2num(hhmmss(colon(1)+1:colon(2)-1));',...
         'ss = str2num(hhmmss(colon(2)+1:length(hhmmss)));',...
         'start_time=[yr mon day hh mm ss];',...
         'nav_system = get(sta_sats(1),''value'')-1;',...
         '[GPS_week, GPS_sec, GPS_day] = utc2gps(start_time);',...
         '[gps_alm_file, glo_alm_file] = find_alm(GPS_week);',...
         'if nav_system==0,',...
           'almanac_week = str2num(gps_alm_file(1,4:6));',...
           'almanac_file = gps_alm_file;',...
         'else,',...
           'almanac_week = str2num(glo_alm_file(1,4:6));',...
           'almanac_file = glo_alm_file;',...
         'end;',...               
         'for k=1:size(location,1),',...
            'plot_selection(k,1:9)=[get(sta_vis(k,1),''Value''),' ...
                                   'get(sta_vis(k,2),''Value''),' ...
                                   'get(sta_vis(k,3),''Value''),' ... 
                                   'get(sta_vis(k,4),''Value''),' ...
                                   'get(sta_vis(k,5),''Value''),' ... 
                                   'get(sta_vis(k,6),''Value''),' ...
                                   'get(sta_vis(k,7),''Value''),' ... 
                                   'get(sta_vis(k,8),''Value''),' ... 
                                   'get(sta_vis(k,9),''Value'')];',...
         'end;',...
         'set(station_fig(1),''Pointer'',''watch'');',...
         'location(:,1:2) = location(:,1:2) * pi/180;',...
         'mask_info(:,2:4) = mask_info(:,2:4) * pi/180;',...
         'vis_handles = grnd2orb(sta_name,location,almanac_file,mask_info,',...
               'start_time,duration,time_step,plot_selection);',...
         'set(station_fig(1),''Pointer'',''arrow'');',...
         'vis_plot = 1;',...
         'set(sta_push(1),''String'',''Close Visibility Plots'');',...
       'else,',...
         'ButtonName = questdlg(''No Stations selected for Visibility.'',''NOTICE'',''OK'',''Cancel'');',...
       'end;',...
     'else,',...
       'if any(vis_handles),',...
          'open_list = get(0,''children'');',...
          'for j=1:length(open_list),',...
            'open_vis = find(vis_handles==open_list(j));',...
            'if any(open_vis),',...
              'close(vis_handles(open_vis));',...
            'end;',...
          'end;',...
          'vis_handles = [];',...
       'end;',...
       'set(sta_push(1),''String'',''Plot Visibility'');',...
       'vis_plot = 0;',...
     'end;',...
      ]);

sta_push(2) = uicontrol(station_fig(1), ...
    'BackgroundColor',[1 1 1], ...
    'HorizontalAlignment','center', ...
    'Position',[sta_xdim-230 8 100 30], ...
    'String','Show Animation', ...
    'Style','push', ...
    'CallBack',[ ...
     '[sta_name,location,mask_info] = get_sta(sta_col);',...
     'start_str = deblank(get(sta_edt(1),''string''));',...
     'slash = find(start_str==''/'');',...
     'mon = str2num(start_str(1:slash(1)-1));',...
     'day = str2num(start_str(slash(1)+1:slash(2)-1));',...
     'yr = str2num(start_str(slash(2)+1:slash(2)+2));',...
     'if yr < 50,',...
        'yr = yr + 2000;',...
     'else,',...
        'yr = yr + 1900;',...
     'end;',...
     'hhmmss = start_str(slash(2)+3:length(start_str));',...
     'colon = find(hhmmss=='':'');',...
     'hh = str2num(hhmmss(1:colon(1)-1));',...
     'mm = str2num(hhmmss(colon(1)+1:colon(2)-1));',...
     'ss = str2num(hhmmss(colon(2)+1:length(hhmmss)));',...
     'start_time=utc2gps([yr mon day hh mm ss]);',...
    '[gps_alm_file,glo_alm_file]=find_alm(start_time(1));',...
     'if get(sta_sats(1),''value'')==1,',...
        'alm_2_use = readyuma(gps_alm_file);',...
     'else,',...
        'alm_2_use = readyuma(glo_alm_file);',...
     'end;',...
     'time_step = 60;',...
     'n_plot = 0;',...
     'n_line = 0;',...
     'n_line_last = 1;',...
     'clear locate names mask_rad,'...
     'for k=1:size(location,1),',...
        'if get(sta_vis(k,10),''Value'')==1,',...
          'n_plot = n_plot + 1;',...
          'locate(n_plot,:) = [location(k,1:2)*pi/180 location(k,3)];',...
          'names(n_plot,:) = sta_name(k,:);',...
          'n_site = find(mask_info(:,1)==k);',...
          'n_line = n_line + length(n_site);',...
          'mask_rad(n_line_last:n_line,:) = ',...
              '[ones(size(n_site))*n_plot mask_info(n_site,2:4)*pi/180];',...
          'n_line_last = n_line+1;',...
        'end;',...
     'end;',...
     'if n_plot > 0,',...
       'animate_handle = figure(''NumberTitle'',''off'',''Name'',''Animation'');',...
       'orb_anim(alm_2_use,start_time,time_step,locate,names,mask_rad);',...
     'else,',...
       'ButtonName = questdlg(''No Stations selected for Orbit Animation.'',''NOTICE'',''OK'',''Cancel'');',...
     'end;',...
     ]);

sta_push(3) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','left', ...
  'Position',[10 sta_ydim-285 140 20], ...
  'String','Add New Station', ...
  'Style','push', ...
  'CallBack',[ ...
      'add_sta(sta_col);',...
      '[sta_vis] = plot_opt(sta_col,station_fig(1),sta_ydim,sta_vis);',...
      '[sta_name,location,mask_info] = get_sta(sta_col);',...
      'if size(sta_name,1)>=1 & size(sta_name,2)>=1,',...
        'set(sta_slct,''string'',sta_name);',...
      'else,',...
        'set(sta_slct,''string'',''None'');',...
      'end;',...
      ]);

sta_push(4) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','left', ...
  'Position',[10 sta_ydim-315 140 20], ...
  'String','Add More Masking for -->', ...
  'Style','push', ...
  'CallBack',[ ...
      'sta_2_mod = get(sta_slct,''Value'');',...
      'if sta_2_mod > 0,',...
        'add_sta(sta_col,sta_2_mod);',...
        '[sta_vis] = plot_opt(sta_col,station_fig(1),sta_ydim,sta_vis);',...
      'end;',...
      ]);

sta_push(5) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','left', ...
  'Position',[10 sta_ydim-340 140 20], ...
  'String','Delete Station Named -->', ...
  'Style','push', ...
  'CallBack',[ ...
      'sta_2_del = get(sta_slct,''Value'');',...
      'if sta_2_del > 0,',...
        'del_sta(sta_col,sta_2_del);',...
        '[sta_vis] = plot_opt(sta_col,station_fig(1),sta_ydim,sta_vis);',...
        '[sta_name,location,mask_info] = get_sta(sta_col);',...
        'if size(sta_name,1)>=1 & size(sta_name,2)>=1,',...
          'set(sta_slct,''string'',sta_name);',...
        'else,',...
          'set(sta_slct,''string'',''None'');',...
        'end;',...
        'set(sta_slct,''value'',1);',...
      'end;',...
      ]);


sta_slct = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[155 sta_ydim-328 90 20], ...
  'String','None',...
  'Style','popup');

[sta_name,location,mask_info] = get_sta(sta_col);
if size(sta_name,1)>= 1 & size(sta_name,2)>=1,
  set(sta_slct,'String',sta_name);
end;

sta_push(6) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','left', ...
  'Position',[10 sta_ydim-370 140 20], ...
  'String','Reset Initial Station Values', ...
  'Style','push', ...
  'CallBack',[ ...
     'set(sta_col(1),''string'',sta_col_ini(:,1));',...
     'set(sta_col(2),''string'',sta_col_ini(:,2));',...
     'set(sta_col(3),''string'',sta_col_ini(:,3));',...
     'set(sta_col(4),''string'',sta_col_ini(:,4));',...
     'set(sta_col(5),''string'',sta_col_ini(:,5));',...
     'set(sta_col(6),''string'',sta_col_ini(:,6));',...
     'set(sta_col(7),''string'',sta_col_ini(:,7));',...
     '[sta_vis] = plot_opt(sta_col,station_fig(1),sta_ydim,sta_vis);',...
     '[sta_name,location,mask_info] = get_sta(sta_col);',...
     'if size(sta_name,1)>=1 & size(sta_name,2)>=1,',...
       'set(sta_slct,''string'',sta_name);',...
     'else,',...
       'set(sta_slct,''string'',''None'');',...
     'end;',...
      ]);

sta_push(7) = uicontrol(station_fig(1), ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Position',[sta_xdim-110 8 100 30], ...
  'String','Return to Main', ...
  'Style','push', ...
  'CallBack',[ ...
     'if any(vis_handles),',...
        'open_list = get(0,''children'');',...
        'for j=1:length(open_list),',...
          'open_vis = find(vis_handles==open_list(j));',...
          'if any(open_vis),',...
            'close(vis_handles(open_vis));',...
          'end;',...
        'end;',...
        'vis_handles = [];',...
     'end;',...
     'sta_col_str={};',...
     'tmp = get(sta_col(1),''String'');',...
     'sta_col_str(1:size(tmp,1),1) = tmp;',...
     'tmp = get(sta_col(2),''String'');',...
     'sta_col_str(1:size(tmp,1),2) = tmp;',...
     'tmp = get(sta_col(3),''String'');',...
     'sta_col_str(1:size(tmp,1),3) = tmp;',...
     'tmp = get(sta_col(4),''String'');',...
     'sta_col_str(1:size(tmp,1),4) = tmp;',...
     'tmp = get(sta_col(5),''String'');',...
     'sta_col_str(1:size(tmp,1),5) = tmp;',...
     'tmp = get(sta_col(6),''String'');',...
     'sta_col_str(1:size(tmp,1),6) = tmp;',...
     'tmp = get(sta_col(7),''String'');',...
     'sta_col_str(1:size(tmp,1),7) = tmp;',...
     'set(demo_fig(1),''visible'',''on'');',...
     'sta_win = findobj(''Name'',''Visibility from Earth'');',...
     'if any(sta_win),',...
        'close(sta_win);',...
     'end;',...
      ]);
 
% Build radio buttons for selection of GPS or GLONASS
system_str = {'Show Output for GPS';'Show Output for GLONASS';};

sta_sats(1) = uicontrol(station_fig(1), ...
  'style','listbox',...
  'string',system_str,...
  'backgroundcolor','white',... 
  'Position',[260 sta_ydim-315 180 40]);

% Build the start date, duration, and time step portions
sta_txt(1)=uicontrol(station_fig(1), ...
  'style','text',...
  'string','Start:',...
  'backgroundcolor','white',...
  'fontsize',10,...
  'position',[450 sta_ydim-285 50 17],...
  'horizontalalignment','left');

sta_txt(2)=uicontrol(station_fig(1), ...
  'style','text',...
  'string','Duration (hrs):',...
  'backgroundcolor','white',...
  'fontsize',10,...
  'position',[450 sta_ydim-305 150 17],...
  'horizontalalignment','left');

sta_txt(3)=uicontrol(station_fig(1), ...
  'style','text',...
  'string','Time Step (sec):',...
  'backgroundcolor','white',...
  'fontsize',10,...
  'position',[450 sta_ydim-325 150 17],...
  'horizontalalignment','left');

% Make the following 3 inputs disabled for the demo only
% Would really be 'edit'
if strcmp(op_mode,'DEMO')==1,       % Limited functionality DEMO
  sta_edt(1)=uicontrol(station_fig(1), ...
   'style','edit',...
   'string','09/01/02 00:00:00',...
   'backgroundcolor',[0.9 0.9 0.9],...
   'fontsize',10,...
   'position',[490 sta_ydim-285 130 17],...
   'horizontalalignment','center',...
   'CallBack',[ ...
    'set(sta_edt(1),''string'',''09/01/02 00:00:00.000'');',...
    'ButtonName = questdlg(''Start Time may not be modified in Demo.'',''NOTICE'',''OK'',''Cancel'');',...
    ]);

  sta_edt(2)=uicontrol(station_fig(1), ...
   'style','edit',...
   'string','1.0',...
   'backgroundcolor',[0.9 0.9 0.9],...
   'fontsize',10,...
   'position',[540 sta_ydim-305 40 17],...
   'horizontalalignment','center',...
   'CallBack',[ ...
    'set(sta_edt(2),''string'',''1.0'');',...
    'ButtonName = questdlg(''Duration may not be modified in Demo.'',''NOTICE'',''OK'',''Cancel'');',...
    ]);

  sta_edt(3)=uicontrol(station_fig(1), ...
   'style','edit',...
   'string','60',...
   'backgroundcolor',[0.9 0.9 0.9],...
   'fontsize',10,...
   'position',[550 sta_ydim-325 30 17],...
   'horizontalalignment','center',...
   'CallBack',[ ...
    'set(sta_edt(3),''string'',''60'');',...
    'ButtonName = questdlg(''Time Step may not be modified in Demo.'',''NOTICE'',''OK'',''Cancel'');',...
    ]);

elseif strcmp(op_mode,'GUI')==1,    % Fully functional GUI
  sta_edt(1)=uicontrol(station_fig(1), ...
   'style','edit',...
   'string','09/01/02 00:00:00',...
   'backgroundcolor','white',...
   'fontsize',10,...
   'position',[490 sta_ydim-285 130 17],...
   'horizontalalignment','center');

  sta_edt(2)=uicontrol(station_fig(1), ...
   'style','edit',...
   'string','1.0',...
   'backgroundcolor','white',...
   'fontsize',10,...
   'position',[540 sta_ydim-305 40 17],...
   'horizontalalignment','center');

  sta_edt(3)=uicontrol(station_fig(1), ...
   'style','edit',...
   'string','60',...
   'backgroundcolor','white',...
   'fontsize',10,...
   'position',[550 sta_ydim-325 30 17],...
   'horizontalalignment','center');
end;
