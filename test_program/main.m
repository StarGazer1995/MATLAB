clc
clear
addpath 'G:\MATLAB\script\Constellation 6' -begin
addpath 'G:\MATLAB\script\Constellation 6\rinex60' -end
addpath 'G:\MATLAB\script\test_program\data' -begin

%%%%%%%%%%%%%%%%%% Compute by using spp.m provided (RINEX nav file used)
% %%%%%%%% MGRV
 %STA_name='MGRV';
 %Rinex_o= 'MGRV.obs';
 %Rinex_n='MGRV052.07n';
 %YUMA = 0;
 %x0 = [-4642160.146   2591122.130  -3512053.191 ];
 %x_true = [0 0 0];
 %cutoff= 10;
 %file='MGRV_output_result.txt';
 %[sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%SYDN
% STA_name='MGRV';
%Rinex_o= 'MGRV.obs';
% Rinex_n='MGRV052.07n';
% YUMA = 0;
% x0 = [-4642160.146   2591122.130  -3512053.191 ];
% x_true = [0 0 0];
% cutoff= 10;
% file='MGRV_output_result_withoutatmocorr.txt';
%  [sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% when using YUMA
%%%%%%%%% MGRV
% STA_name='MGRV';
% Rinex_o= 'MGRV.obs';
% Rinex_n='gps050.alm';
% YUMA = 1;
% x0 = [-4642160.146   2591122.130  -3512053.191 ];
% x_true = [0 0 0];
% cutoff= 10;
% file='MGRV_output_result_withYUMA.txt';
% [sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%% SYDN
% STA_name='SYDN';
% Rinex_o= 'SYDN0010.obs';
% Rinex_n='001.ALM';
% YUMA = 1;
% x0 = [-4648240.3900  2560636.5470 -3526318.5890 ];
% x_true=[-4648240.2377, 2560636.481, -3526318.6064];
% cutoff= 10;
% file='SYDN_output_result_withYUMA.txt';
% [sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%%%% when removing tropospheric correction
%%%%%%%%% MGRV
% STA_name='MGRV';
% Rinex_o= 'MGRV.obs';
% Rinex_n='MGRV052.07n';
% YUMA = 0;
% x0 = [-4642160.146   2591122.130  -3512053.191 ];
% x_true = [0 0 0];
% cutoff= 10;
% file='MGRV_output_result_withoutatmocorr.txt';
% [sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%% SYDN
 %STA_name='SYDN';
 %Rinex_o= 'SYDN0010.obs';
 %Rinex_n='SYDN0010.12n';
 %YUMA = 0;
 %x0 = [-4648240.3900  2560636.5470 -3526318.5890 ];
 %x_true=[-4648240.2377, 2560636.481, -3526318.6064];
 %cutoff= 10;
 %file='SYDN_output_result_withoutatmocorr.txt';
 %[sta_xyz_clk,DOP,num_sat]= SPP(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%%%% when using iterative method to determine the TOT
%%%%%%%%% MGRV
% STA_name='MGRV';
% Rinex_o= 'MGRV.obs';
% Rinex_n='MGRV052.07n';
% YUMA = 0;
% x0 = [-4642160.146   2591122.130  -3512053.191 ];
% x_true = [0 0 0];
% cutoff= 10;
% file='MGRV_output_result_TOT.txt'
% [sta_xyz_clk,DOP,num_sat]= SPP_1(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%% SYDN
% STA_name='SYDN';
% Rinex_o= 'SYDN0010.obs';
% Rinex_n='SYDN0010.12n';
% YUMA = 0;
% x0 = [-4648240.3900  2560636.5470 -3526318.5890 ];
% x_true=[-4648240.2377, 2560636.481, -3526318.6064];
% cutoff= 10;
% file='SYDN_output_result_TOT.txt'
% [sta_xyz_clk,DOP,num_sat]= SPP_1(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%%%%%%%%%%%%%%%%%%% relative time correction
%%%%%%%%% MGRV
% STA_name='MGRV';
% Rinex_o= 'MGRV.obs';
% Rinex_n='MGRV052.07n';
% YUMA = 0;
% x0 = [-4642160.146   2591122.130  -3512053.191 ];
% x_true = [0 0 0];
% cutoff= 10;
% file='MGRV_Relative_cor.txt'
% [sta_xyz_clk,DOP,num_sat]= SPP_1(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%% SYDN
% STA_name='SYDN';
% Rinex_o= 'SYDN0010.obs';
% Rinex_n='SYDN0010.12n';
% YUMA = 0;
% x0 = [-4648240.3900  2560636.5470 -3526318.5890 ];
% x_true=[-4648240.2377, 2560636.481, -3526318.6064];
% cutoff= 10;
% file='SYDN_Relative_cor.txt'
% [sta_xyz_clk,DOP,num_sat]= SPP_1(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%%%%%%%%%%%%GD correction
%%%%%%%%% MGRV
% STA_name='MGRV';
% Rinex_o= 'MGRV.obs';
% Rinex_n='MGRV052.07n';
% YUMA = 0;
% x0 = [-4642160.146   2591122.130  -3512053.191 ];
% x_true = [0 0 0];
% cutoff= 10;
% file='MGRV_GD_cor.txt';
% [sta_xyz_clk,DOP,num_sat]= SPP_1(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);

%%%%%%%%% SYDN
 STA_name='SYDN';
 Rinex_o= 'SYDN0010.obs';
 Rinex_n='SYDN0010.12n';
 YUMA = 0;
 x0 = [-4648240.3900  2560636.5470 -3526318.5890 ];
 x_true=[-4648240.2377, 2560636.481, -3526318.6064];
 cutoff= 10;
 file='SYDN_GD_cor.txt';
 [sta_xyz_clk,DOP,num_sat]= SPP_1(STA_name,Rinex_o,Rinex_n,YUMA,x0,x_true,cutoff,file);
