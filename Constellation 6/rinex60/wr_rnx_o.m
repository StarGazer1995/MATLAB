function wr_rnx_o(file_name, sat_data, info_struct);
% Function to write RINEX-II observation files.  
%
% function wr_rnx_o(file_name, sat_data, info_struct);
%
% Input:
%    file_name - file name of RINEX-II data file to write (1xn) (string)
%
%    sat_data  - satellite measurement data structure.  This structure 
%        contains all of the measurement data to be output to the RINEX file.
%        sat_data.meas_types - measurement types that follow in the data 
%                              (e.g. L1, C1, D1, L2, D2, C2). (nx2) (string)
%                              the data member of this structure must contain
%                              the same number of arrays.
%        sat_data.data{1}    - measurement data for the first measurement type.
%                              [GPS_week GPS_sec prn data] (nx4) 
%        sat_data.data{2}    - measurement data for the second measurement type.
%                              [GPS_week GPS_sec prn data] (nx4) 
%              .
%              .
%        sat_data.data{n}    - measurement data for the n-th measurement type.
%                              [GPS_week GPS_sec prn data] (nx4) 
%       
%    info_struct - structure with information for the RINEX header (optional)
%        Reasonable default values have been selected for all parameters.  Any
%        of this structure may be left blank.  All fields must be strings.
% 
%        info_struct.data_type   - satellite system. 'G' = GPS, 'R' = GLONASS
%        info_struct.agency      - agency name creating the file
%        info_struct.observer    - observer creating the file
%        info_struct.comment     - comments for comment line
%        info_struct.marker_name - antenna marker name
%        info_struct.marker_num  - antenna marker number
%        info_struct.rectype     - receiver type
%        info_struct.recnum      - receiver number
%        info_struct.recver      - receiver version
%        info_struct.anttype     - antenna type
%        info_struct.antnum      - antenna number
%        info_struct.antposx     - approximate antenna position ECEF WGS-84 - X (m) F14.4
%        info_struct.antposy     - approximate antenna position ECEF WGS-84 - Y (m) F14.4
%        info_struct.antposz     - approximate antenna position ECEF WGS-84 - Z (m) F14.4
%        info_struct.antdelh     - antenna Height (H) above marker - Delta H/E/N (m) F14.4
%        info_struct.antdelh     - antenna East (E) from marker - Delta H/E/N (m) F14.4
%        info_struct.antdelh     - antenna North (N) from marker - Delta H/E/N (m) F14.4
%
% Output:
%
% Note: 1) Does not support mixed GPS/GLONASS RINEX data.  
%       2) Only full wavelength (factors of 1) are allowed.
%
% See also WR_RNX_E, RD_RNX_O 

% Written by: Jimmy LaMance 1/31/00
% Copyright (c) 2000-2003 by Constell, Inc.

%%%%% BEGIN VARIABLE CHECKING CODE %%%%%
% declare the global debug mode
global DEBUG_MODE

% Initialize the output variables
obs = [];
obs_qual = [];
type_str = [];
clk_off = [];

if nargin < 3
	info_struct = [];
end

% Check the number of input arguments and issues a message if invalid
msg = nargchk(2,3,nargin);
if ~isempty(msg)
  fprintf('%s  See help on WR_RNX_O for details.\n',msg);
  fprintf('Returning with empty outputs.\n\n');
  return
end

estruct.func_name = 'WR_RNX_O';

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

% Open the file
fid_rinex = fopen(file_name,'w');
if fid_rinex < 1         
  fprintf('File open for %s failed.\n',file_name); 
  return
end

% Write out the header information
% Start with the first line
line = blanks(80);
line(6) = '2';
line(21:36) = 'OBSERVATION DATA';
if isfield(info_struct,'data_type')
   % Only use the first character, just in case the string is longer
   line(41) = info_struct.data_type(1);
else
   line(41) = 'G';
end % if
line(61:80) = 'RINEX VERSION / TYPE';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the program run by, agency, date line
line = blanks(80);
line(1:20) = 'RINEX MATLAB Toolbox';
if isfield(info_struct,'agency')
   % Make sure the agency spec is <= 20 characters
   if length(info_struct.agency) > 20
      info_struct.agency = info_struct.agency(1:20);
   end
   
   % Only use the first character, just in case the string is longer
   line(21:20+length(info_struct.agency)) = info_struct.agency;
else
   line(21:38) = ' by Constell, Inc.';
end % if
serial_date = now;
s = datestr(serial_date,0);
line(41:40+length(s)) = s;
line(61:80) = 'PGM / RUN BY / DATE ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the comment
line = blanks(80);
if isfield(info_struct,'comment')
   if length(info_struct.comment) > 60
      info_struct.comment = info_struct.comment(1:60);
   end
   line(1:length(info_struct.comment)) = info_struct.comment;
	line(61:80) = 'COMMENT             ';
	fprintf(fid_rinex,'%s\n',line);
end

% Reset the line for the antenna marker name
line = blanks(80);
if isfield(info_struct,'marker_name')
   if length(info_struct.marker_name) > 60
      info_struct.marker_name = info_struct.marker_name(1:60);
   end
   line(1:length(info_struct.marker_name)) = info_struct.marker_name;
else
   marker_string = 'Unknown';
   line(1:length(marker_string)) = marker_string;
end
line(61:80) = 'MARKER NAME         ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the antenna marker number
line = blanks(80);
if isfield(info_struct,'marker_number')
   if length(info_struct.marker_number) > 20
      info_struct.marker_number = info_struct.marker_number(1:20);
   end
   line(1:length(info_struct.marker_number)) = info_struct.marker_number;
else
   marker_string = 'Unknown';
   line(1:length(marker_string)) = marker_string;
end
line(61:80) = 'MARKER NUMBER       ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the observer/agency
line = blanks(80);
if isfield(info_struct,'observer')
   if length(info_struct.observer) > 20
      info_struct.observer = info_struct.observer(1:20);
   end
   line(1:length(info_struct.observer)) = info_struct.observer;
else
   marker_string = 'Simulated Data';
   line(1:length(marker_string)) = marker_string;
end

if isfield(info_struct,'agency')
   if length(info_struct.agency) > 40
      info_struct.agency = info_struct.agency(1:40);
   end
   line(21:length(info_struct.agency) + 20) = info_struct.agency;
end

line(61:80) = 'OBSERVER / AGENCY   ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the REC # / TYPE / VERS 
line = blanks(80);
if isfield(info_struct,'recnum')
   if length(info_struct.recnum) > 20
      info_struct.recnum = info_struct.recnum(1:20);
   end
   line(1:length(info_struct.recnum)) = info_struct.recnum;
end
if isfield(info_struct,'rectype')
   if length(info_struct.rectype) > 20
      info_struct.rectype = info_struct.rectype(1:20);
   end
   line(21:length(info_struct.rectype) + 20) = info_struct.rectype;
else
   marker_string = 'Simulated GPS Receiver';
   line(1:length(marker_string)) = marker_string;
end

if isfield(info_struct,'recver')
   if length(info_struct.recver) > 20
      info_struct.recver = info_struct.recver(1:20);
   end
   line(21:length(info_struct.recver) + 20) = info_struct.recver;
end
line(61:80) = 'REC # / TYPE / VERS ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the ANT # / TYPE
line = blanks(80);
if isfield(info_struct,'antnum')
   if length(info_struct.antnum) > 20
      info_struct.antnum = info_struct.antnum(1:20);
   end
   line(1:length(info_struct.antnum)) = info_struct.antnum;
end
if isfield(info_struct,'anttype')
   if length(info_struct.anttype) > 20
      info_struct.anttype = info_struct.anttype(1:20);
   end
   line(21:length(info_struct.anttype) + 20) = info_struct.anttype;
else
   marker_string = 'Simulated Antenna';
   line(1:length(marker_string)) = marker_string;
end
line(61:80) = 'ANT # / TYPE        ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the APPROX POSITION XYZ  
line = blanks(80);
if isfield(info_struct,'antposx')
   if length(info_struct.antposx) > 14
      info_struct.antposx = info_struct.antposx(1:14);
   end
   line(1:length(info_struct.antposx)) = info_struct.antposx;
end
if isfield(info_struct,'antposy')
   if length(info_struct.antposy) > 14
      info_struct.antposy = info_struct.antposy(1:14);
   end
   line(15:length(info_struct.antposy) + 14) = info_struct.antposy;
end
if isfield(info_struct,'antposz')
   if length(info_struct.antposz) > 14
      info_struct.antposz = info_struct.antposz(1:14);
   end
   line(29:length(info_struct.antposz) + 28) = info_struct.antposz;
end
line(61:80) = 'APPROX POSITION XYZ ';
fprintf(fid_rinex,'%s\n',line);

% Reset the line for the ANTENNA: DELTA H/E/N  
line = blanks(80);
if isfield(info_struct,'antdelh')
   if length(info_struct.antdelh) > 14
      info_struct.antdelh = info_struct.antdelh(1:14);
   end
   line(1:length(info_struct.antdelh)) = info_struct.antdelh;
end
if isfield(info_struct,'antdele')
   if length(info_struct.antdele) > 14
      info_struct.antdele = info_struct.antdele(1:14);
   end
   line(15:length(info_struct.antdele) + 14) = info_struct.antdele;
end
if isfield(info_struct,'antdeln')
   if length(info_struct.antdeln) > 14
      info_struct.antdeln = info_struct.antdeln(1:14);
   end
   line(29:length(info_struct.antdeln) + 28) = info_struct.antdeln;
end
line(61:80) = 'ANTENNA: DELTA H/E/N';
fprintf(fid_rinex,'%s\n',line);

% Check that valid measurement types are provided
if ~isfield(sat_data,'meas_types')
   fprintf('No measurement type provided in sat_data.meas_types.\n');
   fprintf('Check inputs to WR_RNX_O.\n');
   fclose(fid_rinex);
   return;
end

if isempty(sat_data.meas_types)
   fprintf('No observation type specified in sat_data.meas_types.\n');
   fprintf('No obersation data will be written.\n');
   fclose(fid_rinex);
   return;
end

if size(sat_data.meas_types,2) ~= 2
   fprintf('Invalid observation type specified in sat_data.meas_types.\n');
   fprintf('No obersation data will be written.\n');
   fclose(fid_rinex);
   return;
end

if (size(sat_data.meas_types,1) ~= length(sat_data.data))
   fprintf('Observation types specified in sat_data.meas_types do not match data.\n');
   fprintf('No obersation data will be written.\n');
   fclose(fid_rinex);
   return;
end

% Fill in the satellite data structure with additional information that
% is required to complete filling the header.
sat_header = fill_sat_struct(sat_data);

% Reset the line for the WAVELENGTH FACT L1/2
if isfield(info_struct,'data_type')
   sat_system = info_struct.data_type(1);
else
   sat_system = 'G';
end % if ~isempty(info_struct.data_type)

more_to_come = 1;
sats_to_write = sat_header.num_sats;
sats_written = 0;
while more_to_come == 1
	line = blanks(80);
	line(6) = '1';				% wavelength factor of 1
	line(12) = '1'; 			% wavelength factor of 1
	if (sats_to_write > 7)
      more_to_come = 1;
      sats_this_time = 7;
      line(18) = num2str(sats_this_time);
      sats_to_write = sats_to_write - 7;
	else
      more_to_come = 0;
      sats_this_time = sats_to_write;
   	line(18) = num2str(sats_this_time);
   end
   
   % Add the satellite numbers to the line
   for i = 1:sats_this_time
      sat_str = sprintf('%c%2d',sat_system,sat_header.sat_ids(i+sats_written));
      line(22+6*(i-1):22+6*(i-1)+2) = sat_str;
   end % for i = 1:sats_this_time
   
	line(61:80) = 'WAVELENGTH FACT L1/2';
   fprintf(fid_rinex,'%s\n',line);
   
   sats_written = sats_written + sats_this_time;
end

% Add the default values for the wavelength factor line
line = blanks(80);
line(6) = '1';				% wavelength factor of 1
line(12) = '1'; 			% wavelength factor of 1
line(61:80) = 'WAVELENGTH FACT L1/2';
fprintf(fid_rinex,'%s\n',line);

% Add the default values for the # / TYPES OF OBSERV  line
more_to_come = 1;
types_to_write = sat_header.num_types;
types_written = 0;
first = 1;
while more_to_come == 1
   line = blanks(80);
   if first == 1
		type_num_str = sprintf('%6d',types_to_write);
      line(1:6) = type_num_str;			
      first = 0;
   end
   
	if (types_to_write > 9)
      more_to_come = 1;
      types_this_time = 9;
	else
      more_to_come = 0;
      types_this_time = types_to_write;
   end
   
   % Add the satellite numbers to the line
   for i = 1:types_this_time
      type_str = sprintf('%c',sat_data.meas_types(i+types_written,1:2));
      line(11+6*(i-1):11+6*(i-1)+1) = type_str;
   end % for i = 1:sats_this_time
   
	line(61:80) = '# / TYPES OF OBSERV ';
   fprintf(fid_rinex,'%s\n',line);
   
   types_written = types_written + types_this_time;
   types_to_write = types_to_write - types_written;
end

% Add the default values for the INTERVAL              line
line = blanks(80);
if ~isnan(sat_header.interval) & ~isinf(sat_header.interval);
	type_num_str = sprintf('%6d',sat_header.interval);
	line(1:6) = type_num_str;			
end
line(61:80) = 'INTERVAL            ';
fprintf(fid_rinex,'%s\n',line);

% Add the default values for the TIME OF FIRST OBS   line
line = blanks(80);
date_str = sprintf('%6d%6d%6d%6d%6d%12.6f',sat_header.utc_first);
line(1:42) = date_str;	
line(49:51) = 'GPS';
line(61:80) = 'TIME OF FIRST OBS   ';
fprintf(fid_rinex,'%s\n',line);

% Add the default values for the TIME OF LAST OBS   line
line = blanks(80);
date_str = sprintf('%6d%6d%6d%6d%6d%12.6f',sat_header.utc_last);
line(1:42) = date_str;	
line(49:51) = 'GPS';
line(61:80) = 'TIME OF LAST OBS    ';
fprintf(fid_rinex,'%s\n',line);

% Add the default values for the LEAP SECONDS line
line = blanks(80);
leap_str = sprintf('%6d',sat_header.leap_secs);
line(1:6) = leap_str;	
line(61:80) = 'LEAP SECONDS        ';
fprintf(fid_rinex,'%s\n',line);

% Add the default values for the # OF SATELLITES     line
line = blanks(80);
sats_str = sprintf('%6d',sat_header.num_sats);
line(1:6) = sats_str;	
line(61:80) = '# OF SATELLITES     ';
fprintf(fid_rinex,'%s\n',line);

% Add the default values for the PRN / # OF OBS      line
for i = 1:sat_header.num_sats
	more_to_come = 1;
	types_to_write = sat_header.num_types;
   types_written = 0;
   first = 1;
	while more_to_come == 1
      line = blanks(80);
      if first == 1
	      sat_str = sprintf('%c%2d',sat_system,sat_header.sat_ids(i+types_written));
         line(4:6) = sat_str;
         first = 0;
      end
      
		if (types_to_write > 9)
	      more_to_come = 1;
   	   types_this_time = 9;
   	   types_to_write = types_to_write - 9;
		else
   	   more_to_come = 0;
	      types_this_time = types_to_write;
   	end
   
	   % Add the satellite numbers to the line
	   for j = 1:types_this_time
	      obs_str = sprintf('%6d',sat_header.num_obs(j,i));
      	line(7+6*(j-1):7+6*(j-1)+5) = obs_str;
   	end % for i = 1:sats_this_time
   
		line(61:80) = 'PRN / # OF OBS      ';
   	fprintf(fid_rinex,'%s\n',line);
   
 	  	types_written = types_written + types_this_time;
	end
end % for i = 1:sat_header.num_sats

% Finally write the end of the header record
line = blanks(80);
line(61:80) = 'END OF HEADER       ';
fprintf(fid_rinex,'%s\n',line);

% Now that the entire header record is complete, start actually writting out the observations.
% This is brute force, but because of the RINEX format, there is no other way to do it.
% Vectorization is used eveywhere possible, but this can be time consuming because of
% the looping and disk access time.  Start by getting GPS second time tags on all of the data.
for i = 1:sat_header.num_types
   sat_data.gps_time_sec{i} = gpst2sec(sat_data.data{i}(:,1:2));
end

% Loop over the number of unique data times
for i = 1:sat_header.num_data_times
   sat_ids_this_time = [];
   obs = ones(sat_header.num_sats,sat_header.num_types) * NaN;
   obs_qual = ones(sat_header.num_sats,sat_header.num_types) * NaN;
   sat_ndx = [];
   
   % Loop over the satellite IDs
   for j = 1:sat_header.num_sats
      
      % Loop over the number of data types
   	for k = 1:sat_header.num_types
      
         % Find matching times and satellite IDs
         I = find(sat_data.gps_time_sec{k} == sat_header.data_times_sec(i) & ...
                  sat_data.data{k}(:,3) == sat_header.sat_ids(j));
      
      	% If an observation for this data type, time, and satellite ID is found
         if ~isempty(I)
            sat_ids_this_time = unique([sat_ids_this_time; sat_header.sat_ids(j)]);
            sat_ndx = unique([sat_ndx; j]);		
            obs(j,k) = sat_data.data{k}(I,4);
            
            if size(sat_data.data{k},2) == 5   		% data quality field given
               obs_qual(j,k) = sat_data.data{k}(I,5);
            end % if size(sat_data.data{k},2) == 5          
         end % if ~isempty(I)
         
      end % for k = 1:sat_header.num_types
   end % for j = 1:sat_header.num_sats
   
   % Now we have all of the data for this time step
   num_sats_this_time = length(sat_ids_this_time);
   gps_time = sec2gpst(sat_header.data_times_sec(i));
   utc_time = gps2utc(gps_time);
   year_str = num2str(utc_time(1));
   year_2_digit_str = year_str(3:4);
   utc_time(1) = str2num(year_2_digit_str);
   
   % Format the header line(s)
	more_to_come = 1;
	sats_to_write = num_sats_this_time;
	sats_written = 0;
	first = 1;
	while more_to_come == 1
   	line = blanks(80);
	   if first == 1
			head_str = sprintf(' %02d %02d %02d %02d %02d%11.7f%3d%3d',utc_time,0,num_sats_this_time);
      	line(1:32) = head_str;			
	      first = 0;
   	end
   
		if (sats_to_write > 12)
   	   more_to_come = 1;
      	sats_to_write = sats_to_write - 12;
      	sats_this_time = 12;
		else
   	   more_to_come = 0;
      	sats_this_time = sats_to_write;
	   end
   
   	% Add the satellite numbers to the line
	   for k = 1:sats_this_time
         sat_str = sprintf('%c%2d',sat_system,sat_ids_this_time(k+sats_written));
         ndx = 33+3*(k-1);
         line(ndx:ndx+2) = sat_str;
	   end % for i = 1:sats_this_time
   
		fprintf(fid_rinex,'%s\n',line);
      
      sats_written = sats_written + sats_this_time;
   end % while more_to_come == 1
   
   % Format and write the data line(s)
   for j = 1:length(sat_ndx)
   	more_to_come = 1;
		obs_to_write = sat_header.num_types;
      obs_written = 0;
      this_sat_ndx = sat_ndx(j);
      
		while more_to_come == 1
   		line = blanks(80);
   
			if (obs_to_write > 5)
	   	   more_to_come = 1;
   	   	obs_to_write = obs_to_write - 5;
	   	  	obs_this_time = 5;
			else
   		   more_to_come = 0;
      		obs_this_time = obs_to_write;
		   end
   
   		% Add the satellite data to the line
         for k = 1:obs_this_time
            
            if isnan(obs_qual(this_sat_ndx,k+obs_written))
               if ~isnan(obs(this_sat_ndx,k+obs_written))
                  obs_str = sprintf('%14.3f  ',obs(this_sat_ndx,k+obs_written));
               else
                  obs_str = blanks(16);
               end
            else
               obs_str = sprintf('%14.3f %1d', ...
                          obs(this_sat_ndx,k+obs_written),obs_qual(this_sat_ndx,k+obs_written));
            end % if obs_qual(this_sat_ndx,k+obs_written) == NaN
            
            ndx = 16*(k-1)+1;
            obs_length = length(obs_str);
            if (obs_length ~= 16)
               fprintf('Overflow in observation data.\n');
               obs_str = obs_str(1:16);
            	obs_length = length(obs_str);
            end
            
   	      line(ndx:ndx+15) = obs_str;
	   	end % for i = 1:sats_this_time
   
			fprintf(fid_rinex,'%s\n',line);
         obs_written = obs_written + obs_this_time;
         
      end % while more_to_come == 1
      
   end % for j = 1:length(sat_ndx)
   
end % for i = 1:sat_header.num_data_times

% Finally close the RINEX file
fclose(fid_rinex);

%%%%% END ALGORITHM CODE %%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Begin support functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Begin subroutine for parsing the satellite data structure for
%%%%% header information
function header_struct = fill_sat_struct(sat_data);

% Find the number of ovservation types
header_struct.num_types = size(sat_data.meas_types,1);

% Find the satellite numbers for all of the data used
prn_unique = [];
for i=1:header_struct.num_types
   prn_this = unique(sat_data.data{i}(:,3));
   prn_unique = unique([prn_unique prn_this]);
end % for
header_struct.num_sats = length(prn_unique);
header_struct.sat_ids = prn_unique;

% Find the first, last, and interval of the observation.  Do this in GPS seconds to 
% more easily manage a linear time scale.  While we're here, get all of the times
% for which there is data.
gps_first_sec = 1e20;
gps_last_sec = 0;
data_interval = NaN;
data_times_sec = [];
for i=1:header_struct.num_types
   gps_time = sat_data.data{i}(:,1:2);
   gps_time_sec = gpst2sec(gps_time);
   mint = min(gps_time_sec);
   maxt = max(gps_time_sec);
   
   if (mint < gps_first_sec)
      gps_first_sec = mint;
   end
   if (maxt > gps_last_sec)
      gps_last_sec = maxt;
   end
   
   % Get a unique set of data time stamps.  Unique is also kind enough to sort this for us.
   data_times_sec = unique([data_times_sec; gps_time_sec]);
   
   % Find the data interval for the data set
   dt = diff(unique(gps_time_sec));
   diff_t = diff(dt);			% should be 0 if the interval is the same for all obs
   I = find(diff_t ~= 0);
   if isempty(I)
      if isnan(data_interval)
         data_interval = dt(1);
      else
         % Check that this is the same interval
         if data_interval ~= dt(1)
            data_interval = inf;
         end % if data_interval ~= dt(1)
      end % if (data_interval == NaN)
   end % if isempty(I)
end % for

% Fill the header structure with the min, max, and interval
gps_first = sec2gpst(gps_first_sec);
gps_last = sec2gpst(gps_last_sec);
[header_struct.utc_first,header_struct.leap_secs] = gps2utc(gps_first);
header_struct.utc_last = gps2utc(gps_last);
header_struct.interval = data_interval;
header_struct.data_times_sec = data_times_sec;
header_struct.num_data_times = length(data_times_sec);

% Find the number of observations per data type
for i=1:header_struct.num_types
   for j = 1:header_struct.num_sats
      I = find(sat_data.data{i}(:,3) == header_struct.sat_ids(j));
      if ~isempty(I)
         header_struct.num_obs(i,j) = length(I);
      else
         header_struct.num_obs(i,j) = 0;
      end % if ~isempty(I)
   end % for j = 1:header_struct.num_sats
end % for i=1:header_struct.num_types





    
