function [obs, obs_qual, type_str, clk_off] = rd_rnx_o(file_name);
% Function to read RINEX-II observation files.  
%
% function [obs, obs_qual, type_str, clk_off] = rd_rnx_o(file_name);
%
% Input:
%    file_name - file name of RINEX-II data file to read (1xn) (string)
%
% Output:
%    obs      - observation data (nxm) (number_of_obs x 3+number_of_data_types)
%                The columns of the obs matrix are defined as ...
%                    1         2     3     4        5        6
%                [GPS_week, GPS_sec, PRN, data(1), data(2), data(3), ...]
%                data fields depend on RINEX header file.  Use type_str
%                variable to identify each observation type.  Observations are
%                loaded in the data(n) variable in the same order as the typ_str.
%                Example obs matrix with 4 observation types (C1    L1    D1    P2)
%                   1      2     3       4             5           6         7
%                 Week   Sec    PRN     C1             L1         D1        P2
%                [1023  856792  2   20855400.126 109595864.844 -969.622 20855402.416; ...
%                 1023  856792  10  23539064.233 123698609.620  486.471 23539068.706; ...
%                 1023  856792  18  21600694.212 113512400.206 2518.909 21600696.656; ...
%                 1023  856792  28  20883879.485 109745525.139  853.284 20883880.933; ...
%                 1023  856793  2   20855215.771 109594895.988 -969.455 20855217.990]
%
%    obs_qual - observation quality matrix (nx2) [LLI Signal_strength]
%               LLI - loss of lock indicator (0-7) see RINEX format for meaning
%               Signal strngth (1-9, min-max), 0 - unknown/don't care
%    type_str - observation type string (num_obs_types x 2) character string
%    clk_off  - clock offset (nx1) seconds if available
%
% Note: 1) Data that is not available will be filled with NaN.
%       2) Does not handle mixed GPS/GLONASS RINEX data file.  
%       3) GPS time is kept without rollovers (e.g. week 1025 is week 1 with a rollover).
%       4) Data read in will be saved in a *.mat file with the same file prefix
%          as the input data file (e.g. sample.obs data will be saved in sample.obs.mat).
%          When RD_RNX_O is called subsequent time, the mat file will be loaded to
%          same time on reading in the raw data.  Remove the *.mat file to force
%          the raw data to be read from scratch.
%
% See also READEPH, REFRINEX 

% Written by: Jimmy LaMance 10/13/99
% Modified by: Jimmy LaMance 8/21/00 - Improved input read error checking
% Modified by: Jimmy LaMance 10/4/03 - Fixed UTC/GPS time tags.
% Copyright (c) 1999-2003 by Constell, Inc.

%%%%% BEGIN VARIABLE CHECKING CODE %%%%%
% declare the global debug mode
global DEBUG_MODE

% Initialize the output variables
obs = [];
obs_qual = [];
type_str = [];
clk_off = [];

% Check the number of input arguments and issues a message if invalid
msg = nargchk(1,1,nargin);
if ~isempty(msg)
  fprintf('%s  See help on RD_RNX_O for details.\n',msg);
  fprintf('Returning with empty outputs.\n\n');
  return
end

estruct.func_name = 'RD_RNX_O';

% Develop the error checking structure with required dimension, matching
% dimension flags, and input dimensions.
estruct.variable(1).name = 'file_name';
estruct.variable(1).req_dim = [1 901];
estruct.variable(1).var = 'file_name';
estruct.variable(1).type = 'STRING';
  
% Call the error checking function
stop_flag = err_chk(estruct);
  
if stop_flag == 1           
  fprintf('Invalid inputs to %s.  Returning with empty outputs.\n\n', ...
           estruct.func_name);
  return
end % if stop_flag == 1

%%%%% END VARIABLE CHECKING CODE %%%%%

%%%%% BEGIN ALGORITHM CODE %%%%%
% Set a value for the current time to compute an elasped time for the function
t0 = clock;

% See if this file has already been read and formatted for MATLAB
save_file = sprintf('%s.mat',deblank(file_name));

if exist(save_file) == 2
  file_exists = 1;
else   
  file_exists = 0;
end

if file_exists == 1
  % obs, obs_qual, type_str, clk_off
  x = load(save_file);
  obs = x.obs;
  obs_qual = x.obs_qual;
  type_str = x.type_str;
  clk_off = x.clk_off;
  clear x
  fprintf('Data loaded from existing file, %s.\n',save_file);
  return
end

% Open the file
fid_rinex = fopen(file_name);
if fid_rinex < 1         
  fprintf('File open for %s failed.\n',file_name); 
  return
end
fprintf('Reading in RINEX-II data from file %s.\n',file_name);

% Compute the file size
fseek(fid_rinex,0,'eof');       % put the pointer at the end of the file
f_size = ftell(fid_rinex);      % get the position and file size in bytes
fseek(fid_rinex,0,'bof'); 	     % set the pointer to the beginning of the file
  
% Search for the end of the header message
eoh_found = 0;				% flag - end of header found
num_types_found = 0;		% flag - number of data types found in header
interval_record_found = 0;	% flag - interval record found in header
start_time_found = 0;		% flag - start epoch found in header
stop_time_found = 0;		% flag - start epoch found in header
prn_numobs_found = 0;		% flag - prn/#obs record found in header
num_obs_tot = 0;			% total # of obs, computed from header

% Get the first line of the file (must be RINEX VERSION / TYPE)
line = fgetl(fid_rinex);

while (~feof(fid_rinex) & eoh_found == 0)
  line = fgetl(fid_rinex);
  
  % See if this record has the number and type of observations
  k = findstr(line,'# / TYPES OF OBSERV');
  if ~isempty(k) 	% Record with # and type founds
    [num_obs_per_record,type_str,success] = parse_type(line);
    if success == 1
      num_types_found = 1;
    end % if success == 1
  end % if ~isempty(k)
  
  % See if this record has the recording interval
  k = findstr(line,'INTERVAL');
  if ~isempty(k) 	% Record with # and type founds
    str = sscanf(line(1:6),'%c');
    interval = str2num(str);
    interval_record_found = 1;
  end % if ~isempty(k)
  
  % See if this record has the recording start time
  k = findstr(line,'TIME OF FIRST OBS');
  if ~isempty(k) 	% Record with # and type founds
    [start_time_utc] = parse_utc_time(line);
    start_time_found = 1;
  end % if ~isempty(k)
  
  % See if this record has the recording stop time
  k = findstr(line,'TIME OF LAST OBS');
  if ~isempty(k) 	% Record with # and type founds
    [stop_time_utc] = parse_utc_time(line);
    stop_time_found = 1;
  end % if ~isempty(k)
  
  % See if this record has the number of obs for each PRN
  k = findstr(line,'PRN / # OF OBS');
  if ~isempty(k) 	% Record with # and type founds
    [this_sat,num_obs_this_sat] = parse_num_obs(line);
    num_obs_tot = num_obs_tot + num_obs_this_sat;
    prn_numobs_found = 1;
  end % if ~isempty(k)

  % See if this is the end of the header section
  k = findstr(line,'END OF HEADER');
  if ~isempty(k) 	% End of header found
    eoh_found = 1;
  end % if ~isempty(k)
end % while ~feof(fid_rinex) & eoh_found == 0

if eoh_found ~= 1 & num_types_found ~= 1
  fprintf('Unable to read in the header for this RINEX file (%s).\n',file_name);
  fprintf('Verify that this is a valid RINEX-II observation file.\n');
  return;
end % if eoh_found ~= 1 & num_types_found ~= 1
  
% Allocate the memory for the data if there is a start/stop time and interval or
% a set of records with the number of observations for each satellite.  This speeds
% up the processing for large files, but is not critical for successful reading.
if (interval_record_found & start_time_found & stop_time_found & num_obs_tot == 0)
  % Compute the total seconds of data in the file
  start_gps = utc2gps(start_time_utc,0);
  stop_gps = utc2gps(stop_time_utc,0);
  start_sec = gpst2sec(start_gps);
  stop_sec = gpst2sec(stop_gps);
  dt = stop_sec - start_sec;
  
  % Assume an average of 8 satellites visibile.  Using the total number of 
  % satellites in the observation file would cause an over estimation of the size
  % of the total number of observations for long data sets where satellites are
  % not visibile for the entire observation period.  This is the crude method.  Below
  % is the better method that uses the PRN/# OBS record to obtains the exact number
  % of obs from the header information.
  num_obs = round(dt/interval) * 8;		
  
  obs = ones(num_obs,num_types_found+3)*NaN;
  obs_qual = ones(num_obs,2)*NaN; 
  clk_off = ones(num_obs,1)*NaN;
end

% If the PRN/# OBS information is in the header, use the total number of observations
% from that section of the header.
if (num_obs_tot ~= 0)
  num_obs = num_obs_tot;
  obs = ones(num_obs,num_types_found+3)*NaN;
  obs_qual = ones(num_obs,2)*NaN; 
  clk_off = ones(num_obs,1)*NaN;
end % if (num_obs_tot ~= 0)  

% Start reading in the observation data
obs_count = 1;
time_count = 1;
blk = 1;

% If this is MATLAB 5.3, open a percent complete bar
v = version;
v_num = str2num(v(1:3));
if (v_num >= 5.3)
  waitbar_string = sprintf('Reading in data from RINEX file %s',file_name);
  
  % Open a wait bar with a dummy string the same size as the real string
  % we're going to feed it.
  dummyString = char(ones(length(waitbar_string),1) * 'X')';
  h_per = waitbar(0, dummyString);
  % Get the handle to the wait bar's children.  The only child is an axes.
  hc = get(h_per,'Children');
  % Get the handle to the title string on the axes
  ht = get(hc,'Title');
  % Set the title property Interpreter to none such that when supplied
  % with a path with "\" characters it does not try to print them 
  % as TeX strings.
  set(ht,'Interpreter','none')
  % Now add the read title
  h_per = waitbar(0,h_per,waitbar_string);
end % if (v_num == 5.3)

% Read observations through to the end of the file
sat_num = [];
num_sats = [];
while ~feof(fid_rinex)
   clear sat_num num_sats;
   bad_record = 0;
  
  % Get the line with the UTC time tag and the clock bias (if it's there)
  str_obs = fgetl(fid_rinex);
  
  % Make sure that UTC time is marked
  if (length(str_obs) < 26) 
     % Not enough characters for UTC label - bad record?
     bad_record = 1;
  else
  
  if (bad_record == 0)
    % Parse the UTC time marker
    str = sscanf(str_obs(1:3),'%c');
    utc_time(1) = str2num(str);
    str = sscanf(str_obs(4:6),'%c');
    utc_time(2) = str2num(str);
    str = sscanf(str_obs(7:9),'%c');
    utc_time(3) = str2num(str);
    str = sscanf(str_obs(10:12),'%c');
    utc_time(4) = str2num(str);
    str = sscanf(str_obs(13:15),'%c');
    utc_time(5) = str2num(str);
    str = sscanf(str_obs(16:26),'%c');
    utc_time(6) = str2num(str);
    end
      
    % Read in the event flag and number of satellites
    str = sscanf(str_obs(27:29),'%c');
    event_flag = str2num(str);
    
    % Check for non-zero event markers
    if (event_flag ~= 0) 
       % Event marker.  Read in the next two lines and toss them.  Then continue.
       str_obs = fgetl(fid_rinex);
       str_obs = fgetl(fid_rinex);
       bad_record = 1;
    end
    
    str = sscanf(str_obs(30:32),'%c');
    num_sats = str2num(str);
  end % if (bad_record == 0)
 
  if (bad_record == 0) 
    % Make sure there are <= 12 satellites in this record
    if (num_sats > 12)
      fprintf('This version of rd_rnx_o can only read up to 12 satellites per record.\n')
      return
    end % if (num_sats > 12)
  
    % Read in the satellite numbers
    for i = 1:num_sats
      start_ndx = 33 + (i-1)*3;
      sat_str = sscanf(str_obs(start_ndx:start_ndx+2),'%c');
      if ~isempty(deblank(sat_str(2:3)))
        sat_num(i) = str2num(sat_str(2:3));
      else
        sat_num(i) = NaN;
      end
    
    end % for i = 1:num_sats
  
    % Read in the clock bias from the end of the line 
    clk_str = sscanf(str_obs(33+12*3+1:end),'%c');
    if ~isempty(deblank(clk_str))
      clk_offset = str2num(clk_str);
    else
      clk_offset = NaN;
    end
  
    % Convert the UTC time to GPS time 
    gps_time = utc2gps(utc_time,0);
    utc_time
    for j = 1:num_sats
      % Read in the observation data record
      str_obs = fgetl(fid_rinex);
    
      for i = 1:num_obs_per_record
        % Set a pointer to the beginning of the measurement to be decoded
        start_pos = i;
      
        if (i >= 6)
          start_pos = i-5;
        end % if (i >= 6)
      
        if (i == 6)
          str_obs = fgetl(fid_rinex);
        end % if (i == 6)
      
        % Start offset for this data field within the 80 char record
	     rd_ndx = (start_pos-1)*16;    
      
        % Parse out the individual data 
        str_obsn = sscanf(str_obs(rd_ndx+1:rd_ndx+14),'%c');
      
        % See if the string flags are present for the data quality.  This
        % mainly applies for the last obseration in the string.  The previous
        % data will have blanks if the data quality indicators are not present.
        if (length(str_obs) >= rd_ndx+16)
          str_flg1 = sscanf(str_obs(rd_ndx+15:rd_ndx+15),'%c',1);
          str_flg2 = sscanf(str_obs(rd_ndx+16:rd_ndx+16),'%c',1);
        else % if (length(str_obs) >= rd_ndx+16)
          str_flg1 = [];
          str_flg2 = [];
        end % if (length(str_obs) >= rd_ndx+16)
            
        % If this observation is not empty, load the data into the output structure
        if ~isempty(deblank(str_obsn))
          obs(obs_count,1:2) = gps_time;
          obs(obs_count,3) = sat_num(j);
          obs(obs_count,3+i) = str2num(str_obsn);
          if ~isempty(clk_offset) & length(clk_offset) == 1
             clk_off(obs_count,1) = clk_offset;
          else
             clk_off(obs_count,1) = NaN;
          end
                   
          % Get the Loss-of-Lock indicator flag (LLI)
          if ~isempty(deblank(str_flg1))
            obs_qual(obs_count,1) = str2num(str_flg1);
          else
            obs_qual(obs_count,1) = NaN;
          end
        
          % Get the signal strength indicator (1-9 or 0 for don't care)
          if ~isempty(deblank(str_flg2)) & length(str2num(str_flg2)) == 1
            obs_qual(obs_count,2) = str2num(str_flg2);
          end
        else 
          %  
        end
    
      end % for i = 1:num_obs_per_record
    
      % Increment the observation counter
      obs_count = obs_count + 1;
    
    end % for j = 1:num_sats
   
  end % if (bad_record == 0)

  time_count = time_count + 1;
  stop_flag = 1;
  blk = blk + 1;
  
  if (v_num >= 5.3)
    % Update the % complete bar
    percent_complete = ftell(fid_rinex) / f_size;
    waitbar(percent_complete,h_per);
    name_string = sprintf('%d Observations Read',obs_count-1);
    set(h_per,'Name',name_string);
  end % if (v_num == 5.3)

end % while ~feof(fid_rinex)

if (v_num >= 5.3)
  % Close the % complete bar
  close(h_per);
end % if (v_num == 5.3)
  
% Close the file
fclose(fid_rinex);

% Resize the output matrices to have the number of elements read.  This
% is just in case we have over dimensioned the initial size.
obs = obs(1:obs_count-1,:);
obs_qual = obs_qual(1:obs_count-1,:);
clk_off = clk_off(1:obs_count-1,:);

% obs, obs_qual, type_str, clk_off
save_string = sprintf('save ''%s'' obs obs_qual type_str clk_off',save_file);
err_string = sprintf('unable to save output file %s',save_file);
eval(save_string)      
fprintf('%d obs read for %d time steps in %g minutes.\n', ...
         obs_count-1, time_count-1,etime(clock,t0)/60);
  
%%%%% END ALGORITHM CODE %%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Begin support functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Begin subroutine for parsing the number and type
%%%%% of observation record
function [num_obs_per_record,type_str,success] = parse_type(line);
    
% Set the success flag to 1, reset to 0 if something doesn't work out
success = 1;

% Parse out the number of obs
str_num_types = sscanf(line(1:6),'%c');
num_obs_per_record = str2num(str_num_types);
    
% If num_obs_per_record > 9, flag that this version does not support that format
if num_obs_per_record > 9
  fprintf('This version of rd_rnx_o does not support RINEX-II with \n');
  fprintf('more than 9 observation types.\n')
  success = 0;
  return
end % if obs_per_record > 9
    
% Parse out the obs types
for nt = 1:num_obs_per_record
  % Skip the I6, 4x for each record and 2 char for each type
  start_ndx = 6 + 4*nt + (2 * (nt-1)) + 1;   % Start index for this 2 character set
  type_str(nt,:) = sscanf(line(start_ndx:start_ndx+1),'%c');
end % for nt = 1:num_obs_per_record


%%%%% Begin subroutine for parsing the recording interval
function [utc_time, time_sys] = parse_utc_time(line);

% Parse the UTC time marker
str = sscanf(line(1:6),'%c');
utc_time(1) = str2num(str);
str = sscanf(line(7:12),'%c');
utc_time(2) = str2num(str);
str = sscanf(line(13:18),'%c');
utc_time(3) = str2num(str);
str = sscanf(line(19:24),'%c');
utc_time(4) = str2num(str);
str = sscanf(line(25:30),'%c');
utc_time(5) = str2num(str);
str = sscanf(line(31:42),'%c');
utc_time(6) = str2num(str);

% Get the time system string
time_sys = sscanf(line(49:51),'%c');


%%%%% Begin subroutine for parsing the prn/number of obs record
function [this_sat,num_obs_this_sat] = parse_num_obs(line);

% Get the satellite number as a string
this_sat = sscanf(line(4:6),'%c');

% Read in the remainder of the number of observations for this satellite/record
for i = 1:9     % limited to 9 observations for now
  start_ndx = 7+(i-1)*6;
  str = sscanf(line(start_ndx:start_ndx+5),'%c');
  if ~isempty(deblank(str))
    num_obs(i) = str2num(str);
  end % if ~isempty(str)
end

num_obs_this_sat = max(num_obs);

