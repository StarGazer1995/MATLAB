clear;clc;
%%%%%%%%%%data load%%%%%%%%%%%%%%%%%%            KP         TI       TD
load('u(k)2017-10-16(10.21).mat');%         5   400        0.75     0
load('waterlevel_2017-10-16(10.21).mat');%
load('u(k)2017-10-16(10.33).mat');%         10  400        0.75     0
load('waterlevel_2017-10-16(10.33).mat');%
load('u(k)2017-10-16(10.57).mat');%         5   400         1.5     0
load('waterlevel_2017-10-16(10.57).mat');%
load('u(k)2017-10-16(11.1).mat');%          5   400         0.25    0
load('waterlevel_2017-10-16(11.1).mat');%
load('u(k)2017-10-16(11.10).mat');%         4   400         0.75    0   
load('waterlevel_2017-10-16(11.10).mat');%
load('u(k)2017-10-16(11.13).mat');%         5   600        0.75     0
load('waterlevel_2017-10-16(11.13).mat');%
load('u(k)2017-10-16(11.18).mat');%         5   200        0.75     0
load('waterlevel_2017-10-16(11.18).mat');%
%%%%%%%%%%%%%data calibrating%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uk.uk1=u_k_2017_10_16_10_21_/711;
waterlevel.waterlevel1=waterlevel_2017_10_16_10_21_(:,1)/5;
uk.uk2=u_k_2017_10_16_10_33_/711;
waterlevel.waterlevel2=waterlevel_2017_10_16_10_33_(:,1)/10;
uk.uk3=u_k_2017_10_16_10_57_/711;
waterlevel.waterlevel3=waterlevel_2017_10_16_10_57_(:,1)/5;
uk.uk4=u_k_2017_10_16_11_1_/711;
waterlevel.waterlevel4=waterlevel_2017_10_16_11_1_(:,1)/5;
uk.uk5=u_k_2017_10_16_11_10_/711;
waterlevel.waterlevel5=waterlevel_2017_10_16_11_10_(:,1)/4;
uk.uk6=u_k_2017_10_16_11_13_/711;
waterlevel.waterlevel6=waterlevel_2017_10_16_11_13_(:,1)/5;
uk.uk7=u_k_2017_10_16_11_18_/711;
waterlevel.waterlevel7=waterlevel_2017_10_16_11_18_(:,1)/5;
uk=struct2cell(uk);
waterlevel=struct2cell(waterlevel);
%%%%%%%%%%%%%analyze data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:max(size(uk))
n=1:length(waterlevel{i,1});
if max(waterlevel{i,1})>1
   e=(max(waterlevel{i,1})-1)*100;
else
    e=0;
end;
%%%%%%%%%%%%%plot%%%%%%%%%%%%%%%%%%%%%%%%%%%
tit=[string('goal:5 KD:400 TI:0.75 TD:0'),string( 'goal:10 KD:400 TI:0.75 TD:0'),string( 'goal:5 KD:400 TI:1.5 TD:0'),string( 'goal:5 KD:400 TI:0.25 TD:0'),string( 'goal:4 KD:400 TI:0.75 TD:0'),string( 'goal:5 KD:600 TI:0.75 TD:0'),string( 'goal:5 KD:400 TI:0.75 TD:0')];
figure(i);
plot(n,uk{i,1},n,waterlevel{i,1});
axis([0,max(n),-0.1,1.2]);
title(tit(i));
legend('电磁阀开度','水箱满度');
x=[max(n)*0.7 max(n)*0.80];
y=0.1;
word=string([string('超调量         %');num2str(e)]);
text(x(1,1),y(1,1),word{1,1});
text(x(1,2),y(1,1),word{2,1});
end