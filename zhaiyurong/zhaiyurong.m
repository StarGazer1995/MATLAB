%system initial
clear;clc;
%standard paramenter
fs=8*10^3;
i=-21/12:1/12:26/12;
f=440*2.^i;

Tablemate.frequence=[f(1,34),f(1,34),f(1,34),f(1,34),f(1,31),f(1,32),f(1,34),f(1,38),f(1,36),f(1,36),f(1,36),f(1,36),f(1,32),f(1,36),f(1,34),f(1,34)];
Tablemate.timeline=[1,1,1,1,1,1,3,3,1,1,1,1,1,1,3,3];
lbeat=8000/2;
len=lbeat*Tablemate.timeline;
voice=[];
scores=[];stemp=[];
time=[];
harmonic=zeros(8,36);
harmonic(1,:)=ones(1,36);
harmonic(2,:)=0.2*ones(1,36);
harmonic(3,:)=0.3*ones(1,36);
for n=1:length(Tablemate.frequence)
    [ttemp,stemp]=zyr_envepole(Tablemate.frequence(n),len(n),harmonic(:,n),2);
    time=[time,ttemp];scores=[scores,stemp];
end
[dmusic]=segment_test(scores);