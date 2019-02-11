G3_LQRdemo=load('G3_LQRdemo.mat');
G3_lqrshb=load('G3_lqrshb.mat');
G3_PIDdemo=load('G3_PIDdemo.mat');
G3_pPIDde=load('gzppid1.mat');
simulinkpid=load('simulinkpid.mat');
ziyoubai=load('ziyoubai.mat');
global n;
n=1;
% gzplot(simulinkpid.ScopeData.time,simulinkpid.ScopeData.signals.values,string('Response of Step Singal'));
%  gzplot(G3_PIDdemo.ScopeData1.time,G3_PIDdemo.ScopeData1.signals(2).values,string('Angle Response of IPPID'),G3_PIDdemo.ScopeData1.time,G3_PIDdemo.ScopeData1.signals(1).values,string('Postion Response of IPPID'));
%  gzplot(G3_pPIDde.gzppid1.time,G3_pPIDde.gzppid1.signals(2).values,string('Angle Response of Step signal PPID'),G3_pPIDde.gzppid1.time,G3_pPIDde.gzppid1.signals(1).values,string('Postion Response of Step signal PPID'));
gzplot(G3_LQRdemo.ScopeDatalqr.time,G3_LQRdemo.ScopeDatalqr.signals(2).values,string('Angle Response of Step signal LQR'),G3_LQRdemo.ScopeDatalqr.time,G3_LQRdemo.ScopeDatalqr.signals(1).values,string('Postion Response of Step signal LQR'));
% gzplot(ziyoubai.ScopeData3.time,ziyoubai.ScopeData3.signals(2).values,string('Angle Response of Step signalSignal Swing-Up'));
% 
