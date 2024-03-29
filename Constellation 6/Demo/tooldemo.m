%function tooldemo
% GPS DEMO
clear
close all

global sta_col sta_slct vis_plot sta_sats sta_vis
global vis_handles sta_push sta_slct sta_edt station_fig
global sta_ydim sta_col_str sta_col_ini show_flag esc_flag

sta_col_str={};
sta_col_ini={};

% Get the screen size in pixels to use for location of plots
set(0,'units','pixels');
screen_size = get(0,'screensize');
screen_y_max = screen_size(2) + screen_size(4) - 60;
screen_x_max = screen_size(1) + screen_size(3) - 50;

% Set window dimension for main screen in demo
main_xmin = 10;
main_xdim = 610;
main_ydim = 350;

% Create main figure
demo_fig(1) = figure('Color','white', ...
    'Position',[10 screen_y_max-main_ydim main_xdim main_ydim], ...
        'NumberTitle','off',...
        'Name','Constellation Toolbox Demo Version 5.4',...
    'Tag','Fig1');

% Add title
demo_title(1) = uicontrol(demo_fig(1), ...
  'style','text',...
  'string','Constellation Toolbox Demo',...
  'backgroundcolor','white',...
  'horizontalalignment','center',...
  'position',[20 main_ydim-50 main_xdim-40 30],...
  'fontsize',24,...
  'fontangle','italic',...
  'fontweight','bold');

% Create cell array of category list
category_list = {'-Constellation Toolbox from Constell, Inc.'; ...
 '   Satellite Visibility'; ...
 '   Dilution of Precision (DOP)'; ...
 '   Position Error Analysis/Simulation'; ...
 '   Data Processing'; ...
 '   Differential Processing'; ...
 '   Coordinate Transformations'; ...
 ' '; ...
 '-Constell, Inc.';};

% Define enabled status for main list for Run push button
run_enable = ['off';'on ';'on ';'on '; ...
              'on ';'on ';'off';'off';'off'];

% Define the demo functions to be run for each subcategory
demo_func1 = {'none'};
demo_func2 = {'demo_sta';'demo_orb(1,demo_fig(1))';'demo_sta';};
%demo_func2 = {'demo_sta';'demo_orb(1,demo_fig(1))';'demo_sta(1)';};
demo_func3 = {'demo_sta';'demo_orb(2,demo_fig(1))';};
demo_func4 = {'text_plot_fig=pltdoper;';'text_plot_fig=pltsimpr;'; ...
              'text_plot_fig=pltsa;';'text_plot_fig=plttrop;'; ...
              'text_plot_fig=pltiono;';'text_plot_fig=pltnav;';};
demo_func5 = {'text_plot_fig=rdyumtxt;';'text_plot_fig=rdrxdata;'; ...
              'text_plot_fig=pltnmvis;';'text_plot_fig=pltnmdop;'; ...
              'text_plot_fig=pltnmpos;';'text_plot_fig=pltnmsa;';};
demo_func6 = {'text_plot_fig=pltcovis;';'text_plot_fig=pltnavd;'; ...
              'text_plot_fig=pltrestp;';'text_plot_fig=pltresio;'; ...
              'text_plot_fig=pltposan;';};
demo_func7 = {'none';'none';'none';'none';'none';'none';'none';};
demo_func8 = {'none'};
demo_func9 = {'none'};

% Define the subcategory list items
subcategory_list1 = {'Choose a subtopic to see a list of demos.'};
subcategory_list2 = {'Station to GPS/GLONASS Visibility'; ...
                     'Satellite to GPS/GLONASS Visibility'; ...
                     'Azimuth and Elevation Masking';};
subcategory_list3 = {'Station to GPS/GLONASS DOPs'; ...
                     'Satellite to GPS/GLONASS DOPs';};
subcategory_list4 = {'DOP Contribution'; ...
                     'Simulate Pseudo-Range'; ...
                     'Selective Availability (S/A)'; ...
                     'Troposphere Contribution'; ...
                     'Ionosphere Contribution'; ...
                     'Process Pseudo-Range'};
subcategory_list5 = {'Read YUMA'; ...
                     'Read Receiver Data'; ...
                     'View Visible Satellites'; ...
                     'Receiver DOP Data'; ...
                     'Analyze Position Data'; ...
                     'Analyze Selective Availability Effects';};
subcategory_list6 = {'Common Visibility'; ...
                     'Pseudo-Range Processing'; ...
                     'Residual Troposphere Errors'; ...
                     'Residual Ionosphere Errors'; ...
                     'Position Error Analysis';};
subcategory_list7 = {'Azimuth/Elevation <--> North-East-Down'; ...
                     'Body <--> North-East-Down'; ...
                     'ECEF <--> ECI'; ...
                     'ECEF <--> Local Level'; ...
                     'ECEF <--> Latitude/Longitude/Height'; ...
                     'ECEF <--> North-East-Down'; ...
                     'Local Level -> Azimuth/Elevation';};
subcategory_list8 = {'Choose a subtopic to see a list of demos.'};
subcategory_list9 = {'Choose a subtopic to see a list of demos.'};

% Define the descriptions to be listed in the bottom listbox
describe_list1 = { ...
 'The Constellation Toolbox is a Matlab based set of tools for analysis and simulation '; 
 'of satellite constellations.  The GPS and GLONASS constellations are supported.';
 'through the use of standard almanac information and detailed signal modeling for';
 'these two constellations are provided.  The combination of the Constellation;' 
 'toolbox functionswith the Matlab graphics provide a complete set of analysis and';
 'graphical tools for satellite, ground station, and constellation design and simulation.';
 '';
 'The Constellation Toolbox computes satellite visibility and the GPS specific';
 'measure of constellation coverage called Dilutions of Precision';
 '(DOPs), simulates the effects of Selective Availability (SA), models path ';
 'delays caused by the atmosphere, models receiver noise and satellite selection,';
 'and analyzes performance for stand-alone and differential applications.  This'
 'combination of capabilities provides a complete analysis package for GPS, GLONASS,'
 'or combination of GPS and GLONASS.';
 '';
 'Masking is always a concern when working with satellite navigation systems. This';
 'toolbox provides a robust set of masking capabilities that can be implemented';
 'in Earth fixed coordinates as would be required for Earth fixed sites obstructed';
 'by geographical features or in body-fixed coordinates as would be required for';
 'satellites or rockets.  Mask patterns are provided in terms of a "box" with a';
 'minimum and maximum elevation and a minimum and maximum azimuth.';
 ''; 
 'In addition to the robust set of analysis tools, the Constellation Toolbox comes with a';
 'comprehensive set of graphics tools for animating satellite orbits and displaying';
 'visibility for ground stations, satellites, and rockets.  The animation tool';
 'provides the user with the ability to graphically analyze satellite visibility';
 'and base station configurations. Built in functions for displaying azimuth, ';
 'elevation, and other satellite specific data saves times when visualizing';
 'large amounts of satellite specific data';
 '';
 'Speed is always an issue when doing complex sets of analyses.  To maximize ';
 'execution speed, the Constellation Toolbox functions are highly vectorized.  The only';
 'limits on the number of satellites and amount of data generated are the speed';
 'and memory on the host platform';
 '';
 'Portability is a key feature of Matlab and the Constellation Toolbox.  The';
 'analysis tools will run identically on a PC or workstation environment.';
 'If your simulation normally runs on a UNIX based workstation and you have to';
 'show the results to a customer on your PC based laptop, the portability of the';
 'graphics and data is a must.';
 '';
 'You say you want the source code or that you have functions you want to';
 'integrate with the rest of the package.  Great.  All of the functions are';
 'provided in m-file format for easy modification.  If your existing code is';
 'in another language, no problem.  Matlab allows execution of programs in';
 'the operating system environment without exiting Matlab.  This means that the';
 'orbit propagator you have worked so hard on can be seamlessly integrated with';
 'the Constellation Toolbox.'; 
 '';
 'For more information, contact Constell, Inc. at';
 '    www.constell.org'; ...
 '    info@constell.org'; ...
 '    (540) 338-0289 (Voice)'; ...
 '    (540) 338-0293 (Fax)'; ...
 '    PO Box 433'; ...
 '    Philomont, VA 20131'; ...
 };

describe_list2 = { ...
 'The Constellation Toolbox contains an extensive array of functions to allow quick analysis';
 'of satellite visibility.  These tools provide the user with the ability to ';
 'determine the numbers of satellites available from GPS, GLONASS, or other sets';
 'of GPS satellites.  ';
 '';
 'For complete visibility analysis, a robust masking capability allows masking in';
 'Earth-fixed and body-fixed coordinates.  Built-in plotting function display';
 'azimuth, elevation, and sky plots of the satellites.  For another view of the';
 'visibility, use the animation function to display satellite orbits, ground';
 'stations, masking, and visible satellites.';
 };

describe_list3 = { ...
 'Dilution of Precision (DOP) is a measure of the relative satellite geometry for';
 'determining position and velocity accuracies.  The Constellation Toolbox supports computation';
 'of Geometric (GDOP), Position (PDOP), Horizontal (HDOP), Vertical (VDOP), and';
 'Time (TDOP) DOPs.';
 '';
 'Lower DOP values indicate a better satellite geometry, while large values indicate';
 'that the position solution will be limited by relative satellite locations.';
 'A simple relationship exists to convert from DOP to the expected accuracy of';
 'a position or velocity solution.  The estimate of the position error is obtained by';
 'multiplying the uncertainty (or sigma) value of the pseudorange data with the appropriate DOP';
 'For example, given a PDOP of 2.5 and a pseudorange sigma of 25 meters (characteristic';
 'of SA corrupted measurements) a position uncertainty of about 63 meters is obtained.';
 'The same type of quick analysis applies in a differential mode, however, the value';
 'of the sigma on the pseudorange would be on the order of 1 to 3 meters.';
 '';
  };

describe_list4 = { ...
 'Error analysis and simulation starts with the raw measurements.  The Constellation Toolbox';
 'models the pseudorange measurements that a receiver uses to compute position solutions.';
 'To fully model the pseudorange, error models for Selective Availability (SA),';
 'atmospheric path delay, receiver clock errors, and receiver tracking loop noise.';
 };

describe_list5 = { ...
 'Reading in real data is a strength of the Constellation Toolbox.  To obtain the most recent';
 'information on a satellite constellation or read in data generated by a receiver,';
 'functions for reading standard data formats such as YUMA almanacs and NMEA data';
 'are standard features';
 };

describe_list6 = { ...
 'Differential data analysis includes modeling base stations and remote receivers,';
 'as well as the errors that effect the raw data types.  The Constellation Toolbox has robust';
 'receiver and error model simulation capabilities.  Errors that can be analyzed';
 'include residual atmospheric delays, common visibility effects, and receiver noise.';
 };

describe_list7 = { ...
 'Coordinate transformations are essential for complete analysis and simulation.';
 'The Constellation Toolbox supports many essential systems.  These include Earth-Centered-';
 'Earth-Fixed (ECEF), Earth-Centered-Inertial (ECI), latitude-longitude-height,';
 'North-East-Down (NED), body fixed, and local-level coordinates.';
 };

describe_list8 = {' ';}; ...

describe_list9 = { ...
 'Constell, Inc. provides extensive design and analysis services for the'; ...
 'development of satellite and aircraft guidance and navigation systems with'; ...
 'an emphasis on GPS and GPS integration.  In addition to the navigation work, Constell also'; 
 'provides analysis for satellite constellations and satellite mission analysis, as well as';
 'automated command and telemetry ground station development.';...
 '';
 'For further information, you can reach us at';
 '    www.constell.org'; ...
 '    info@constell.org'; ...
 '    (540) 338-0289 (Voice)'; ...
 '    (540) 338-0293 (Fax)'; ...
 '    PO Box 433'; ...
 '    Philomont, VA 20131'; ...
 };
          
% Build the listboxes         
main_list(1) = uicontrol(demo_fig(1),...
  'style','listbox',...
  'string',category_list,...
  'backgroundcolor','white',...
  'fontsize',10,...
  'position',[10 main_ydim-210 main_xdim/2.1 150], ...
  'callback',[ ...
    'closewin(demo_fig(1));',...
    'line_list1 = get(main_list(1),''value'');',...
    'str = sprintf(''subcategory_list%d'',line_list1);',...
    'tmp = eval(str);',...
    'set(main_list(2),''value'',1,''string'',tmp);',...
    'str = sprintf(''Run %s'',char(tmp(get(main_list(2),''value''))));',...
    'set(main_push(1),''string'',str);',...
    'enable_test = char(run_enable(line_list1,:));',...
    'if enable_test(1,1:3)==''off'',',...
      'set(main_push(1),''string'',''Run'');',...
    'end;',...
    'set(main_push(1),''enable'',run_enable(line_list1,:));',...
    'str = sprintf(''describe_list%d'',line_list1);',...
    'set(main_list(3),''value'',1,''string'',eval(str));',...
     ]);


main_list(2) = uicontrol(demo_fig(1),...
  'style','listbox',...
  'string',subcategory_list1,...
  'value',1,...
  'backgroundcolor','white',...
  'fontsize',10,...
  'position',[20+main_xdim/2.1 main_ydim-210 main_xdim/2.1-10 150],...
  'CallBack',[ ...
    'closewin(demo_fig(1));',...
    'line_list1 = get(main_list(1),''value'');',...
    'str = sprintf(''subcategory_list%d'',line_list1);',...
    'tmp = eval(str);',...
    'str = sprintf(''Run %s'',char(tmp(get(main_list(2),''value''))));',...
    'set(main_push(1),''string'',str);']);

main_list(3) = uicontrol(demo_fig(1),...
  'style','listbox',...
  'string',describe_list1,...
  'backgroundcolor','white',...
  'fontsize',10,...
  'position',[10 main_ydim-298 main_xdim-20 80]);

% Build the push buttons
main_push(1) = uicontrol(demo_fig(1),...
  'style','push',...
  'string','Run',...
  'fontsize',10,...
  'enable',run_enable(1,:),...
  'position',[20+main_xdim/6 10 main_xdim/2.2 30],...
  'CallBack',[ ...
    'closewin(demo_fig(1));',...
    'line_list1 = get(main_list(1),''value'');',...
    'str = sprintf(''demo_func%d'',line_list1);',...
    'line_list2 = get(main_list(2),''value'');',...
    'tmp = char(eval(str));',...
    'demo_2_run = deblank(tmp(line_list2,:));',...
    'if strcmp(demo_2_run,''none'')~=1,',...
       'set(demo_fig(1),''visible'',''off'');',...
       'eval(demo_2_run);',...
    'else,',...
       'ButtonName = questdlg(''No Demo is Currently Available.'',''NOTICE'',''OK'',''Cancel'');',...
    'end;',...
     ]);

main_push(2) = uicontrol(demo_fig(1),...
  'style','push',...
  'string','Close',...
  'fontsize',10,...
  'position',[10 10 main_xdim/6 30],...
  'CallBack',[ ...
    'close all;',...
    'clear;']);

main_push(3) = uicontrol(demo_fig(1),...
  'style','push',...
  'string','Run in Automatic Mode',...
  'fontsize',10,...
  'position',[30+main_xdim/6+main_xdim/2.2 10 main_xdim/3.2 30],...
  'CallBack',[ ...
    'closewin(demo_fig(1));',...
    'set(demo_fig(1),''visible'',''off'');',...
    'auto_fig = figure(''color'',''black'',''pos'','...
          '[30 50 screen_x_max-30 screen_y_max-50],''NumberTitle'',''off'','...
          '''Name'',''GPS DEMO'','...
          '''keypressfcn'',''esc_flag=1;'');',...
    'run_auto;',...
    'close(auto_fig);',...
    'set(demo_fig(1),''visible'',''on'');']);


