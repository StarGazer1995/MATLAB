function [dmusic]=segment_test(music)
fs=8000;
[B,A]=butter(8,2*2000/fs,'low');
dmusic=filter(B,A,music);
[B,A]=butter(8,2*150/fs,'high');
dmusic=filter(B,A,dmusic);
dmusic=diff(diff(dmusic));
len=length(dmusic);
roundmusic=zeros(len-9,1);
for n=1:len-9
    roundmusic(n)=mean(dmusic(n:n+9)');
end
dmusic=roundmusic;
end