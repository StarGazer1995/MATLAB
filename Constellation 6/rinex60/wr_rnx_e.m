function wr_rnx_e(file_name, eph_data, info_struct);
% Function to write RINEX-II ephemeris data files.  
%
% function wr_rnx_e(file_name, sat_data, info_struct);
%
% Input:
%    file_name - file name of RINEX-II ephemeris data file to write (1xn) (string)
%
%    eph_data  - ephemeris matrix for all satellites (nx24), with columns of
%                   1   2    3    4      5                     6               
%                 [prn,M0,delta_n,e,sqrt_a,long. of asc_node at GPS week epoch,
%                 7    8       9      10    11  12  13  14  15  16  17  18
%                 i,perigee,ra_rate,i_rate,Cuc,Cus,Crc,Crs,Cic,Cis,Toe,IODE,
%                  19       20  21  22  23      24 
%                 GPS_week,Toc,Af0,Af1,Af2,perigee_rate] 
%                 Ephemeris parameters are from ICD-GPS-200 with the 
%                 exception of perigee_rate.
%
%    info_struct - structure with information for the RINEX header (optional)
%        Reasonable default values have been selected for all parameters.  Any
%        of this structure may be left blank.  All fields must be strings.
% 
%        info_struct.ion_alpha  	- Ionosphere parameters A0-A3 of almanac, 
%                                   (page 18 of subframe 4), (1x4)
%        info_struct.ion_beta    - Ionosphere parameters B0-B3 of almanac (1x4)
%        info_struct.comment     - comments for comment line
%
% Output: None.
%
% Notes: 1) Lines 6 and 7 of the broadcast orbit data are filled with zeros.  These
%           data are note stored within the Constellation Toolbox array definitions.  
%           To include these lines, add the data to the info_struct, and modify the
%           corresponding lines of code where lines 6 and 7 are written.
%        2) Broadcast orbit line 5 has the L2 flag and L2 data fields filled with 0.
%        3) A temporary data file called temp.dat will be created in the current
%           directory.  This file is used to get from the "E" format allowed by MATLAB
%           (and C) when writing data to the "D" format used by FORTRAN and RINEX.
%
% See also WR_RNX_O, RD_RNX_O 

% Written by: Jimmy LaMance 2/14/00
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
  fprintf('%s  See help on WR_RNX_E for details.\n',msg);
  fprintf('Returning with empty outputs.\n\n');
  return
end

estruct.func_name = 'WR_RNX_E';

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
line(21:36) = 'NAVIGATION DATA ';
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

% Reset the line for the ionosphere alpha data
line = blanks(80);
if isfield(info_struct,'ion_alpha')
   if length(info_struct.ion_alpha) == 4
      line(1:50) = sprintf('  %12.3e %12.3e %12.3e %12.3e',info_struct.ion_alpha);
	  	line(61:80) = 'ION ALPHA           ';
   	fprintf(fid_rinex,'%s\n',line);
   else
      fprintf('Invalid length in the ion_alpha data.  Should be 1x4.\n');
      fprintf('Skipping the Alpha data.\n')
   end
end

% Reset the line for the ionosphere beta data
line = blanks(80);
if isfield(info_struct,'ion_beta')
   if length(info_struct.ion_beta) == 4
      line(1:50) = sprintf('  %12.3e %12.3e %12.3e %12.3e',info_struct.ion_beta);
	  	line(61:80) = 'ION BETA            ';
   	fprintf(fid_rinex,'%s\n',line);
   else
      fprintf('Invalid length in the ion_beta data.  Should be 1x4.\n');
      fprintf('Skipping the Beta data.\n')
   end
end

% Finally write the end of the header record
line = blanks(80);
line(61:80) = 'END OF HEADER       ';
fprintf(fid_rinex,'%s\n',line);

% Now that the entire header record is complete, start actually writting out the ephemeris data.
number_of_sats = size(eph_data,1);

% Open a temoprary file to save the "E" formatted data and later write to the real file
% with "D" formatted data.
fid_temp = fopen('temp.dat','w');

% Loop over the number of unique data times
for i = 1:number_of_sats
   line = blanks(80);
   
   % Get the Time of Clock in UTC with a 2 digit year
   toc = gps2utc([eph_data(i,19) eph_data(i,20)]);
   year_str = num2str(toc(1));
   year_2_digit_str = year_str(3:4);
   toc(1) = str2num(year_2_digit_str);
   
   %                PRN  <------- UTC Time ---------><---SV clock terms ->
   line = sprintf('%2d %02d %02d %02d %02d %02d %4.1f %19.11E %19.11E %19.11E', ...
      eph_data(i,1),toc,eph_data(i,21:23));
	fprintf(fid_temp,'%s\n',line);
   
   %                     IODE   CRS   del-n   M0
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', ...
      eph_data(i,18),eph_data(i,14),eph_data(i,3),eph_data(i,2));
	fprintf(fid_temp,'%s\n',line);
   
   %                     CUC    e      CUS  sqrt(a)
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', ...
      eph_data(i,11),eph_data(i,4),eph_data(i,12),eph_data(i,5));
	fprintf(fid_temp,'%s\n',line);
   
   %                     Toe    CIC   Omega  CIS
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', ...
      eph_data(i,17),eph_data(i,15),eph_data(i,6),eph_data(i,16));
	fprintf(fid_temp,'%s\n',line);
   
   %                    i      CRC   perig  ra-rate
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', ...
      eph_data(i,7),eph_data(i,13),eph_data(i,8),eph_data(i,9));
	fprintf(fid_temp,'%s\n',line);
   
   %                     i-dot  L2c   week  L2-flag
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', ...
      eph_data(i,10),0,eph_data(i,19),0);
	fprintf(fid_temp,'%s\n',line);
   
   % BROADCAST ORBIT - 6, health, accuracy, TDG and IODC
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', 0,0,0,0);
	fprintf(fid_temp,'%s\n',line);
   
   % BROADCAST ORBIT - 7, transmission time
   line = sprintf('    %19.11E %19.11E %19.11E %19.11E', 0,0,0,0);
	fprintf(fid_temp,'%s\n',line);
   
end % for i = 1:number_of_sats

% Close the temporary file
fclose(fid_temp);

% Open the temporary file again, this time for reading.
fid_temp = fopen('temp.dat','r');
[data, num_read] = fscanf(fid_temp,'%c');

ID = findstr(data,'E');

% Loop over all of the Es found and replace the E+??? with
% D+??.  This takes a little string manipulication...
for i = 1:length(ID)
   % Extract the sign and the exponent
   sign = data(ID(i)+1);
   exp = str2num(data(ID(i)+2:ID(i)+4));
   new_str = sprintf('D%c%02d',sign,exp);
   
   % Replace the E+??? with *s
   data(ID(i):ID(i)+4) = '*****';
   data = strrep(data,'*****',new_str);
   ID = ID-1;
end

% Close the temporary file again
fclose(fid_temp);

% Write the reformatted data out to the real RINEX ephemeris file
fprintf(fid_rinex,'%c',data);

% Finally close the RINEX file
fclose(fid_rinex);

%%%%% END ALGORITHM CODE %%%%%
  


    
