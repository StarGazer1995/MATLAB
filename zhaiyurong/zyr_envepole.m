function [time,wave]=zyr_envepole(freq,timelen,harmonic,mode)
%The function of this program is to genrate signal according to its
%amplitude,frequence,time lenth, harmonic strength.
time=1:timelen;
wave=zeros(1,timelen);
for n=1:length(harmonic)
    wave=wave+harmonic(n)*sin(time*2*n*pi*freq/8000);
end
if strcmp(mode,'1')
    window=zeros(1,timelen);
    window(1:floor(timelen./6))=linspace(0,2,floor(timelen./6));
    window(floor(timelen/6)+1:floor(timelen/3))=linspace(2,1,floor(timelen/3)-floor(timelen/6));
    window(floor(timelen/3)+1:floor(2*timelen/3))=linspace(1,1,floor(2*timelen/3)-floor(timelen/3));
    window(floor(2*timelen/3)+1:floor(timelen))=linspace(1,0,timelen-floor(2*timelen/3));
elseif strcmp(mode,'2')
    window(1:50)=linspace(0,50,50);
    regression=50:timelen;
    window(regression)=exp(-(regression/regression(1)-1)/60);
else 
    window=ones(1,timelen);
end

wave=wave.*window;

end
