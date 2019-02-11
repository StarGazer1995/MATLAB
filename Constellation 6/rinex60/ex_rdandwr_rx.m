% Sample script to read in a RINEX-II data file and reformat the observations
% to be in an array format.

% Read in a RINEX file named sample.obs
[obs, obs_qual, type_str, clk_off] = rd_rnx_o('base121A.00o');

% Reformat the output to have the data format described in refrinex
% and save the data into variables with the names in the type_str 
% output (e.g. L1, L2, P2, D1, etc)
% The call the refrinex looks like ...
%     [gps_time, prn, L1, L2, D1, ...] = refrinex(obs, obs_qual, clk_off);
% Use a sprintf to fill in the data variables with the strings from type_str.
% Do this by building up the command string and using the eval function to
% execute the command
command_str = sprintf('[gps_time, prn ');    % initial part of command string

% Add the measurement type output
for i = 1:size(type_str,1)
  command_str = sprintf('%s, %s',command_str,type_str(i,:));
end

% Final portion of the command string
command_str = sprintf('%s] = refrinex(obs, obs_qual, clk_off);',command_str);
eval(command_str);

% Print info to the screen
fprintf('Reformatted RINEX-II data using the command ...\n%s\n',command_str);

% Now the sample.obs data is stored in the format describe in refrinex with
% each data set having the name of the measurement type.

% Now write the data out to a new RINEX file
sat_data.meas_types = type_str;	
for i=1:size(type_str,1)
   sat_data.data{i} = [obs(:,1:3) obs(:,i+3)];						
end

% Finally write out the RINEX data file
wr_rnx_o('newdata.00o',sat_data);

