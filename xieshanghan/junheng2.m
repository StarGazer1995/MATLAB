[a,Fs]=audioread('G:\\MATLAB\\script\\xieshanghan\\天空之城.mp3');
Na=length(a);
Xa=fftshift(fft(a,Na))/Fs;
fa=-Fs/2+(0:Na-1)*Fs/Na;
subplot(2,2,1);
plot(fa,abs(Xa))

Nwin=637;%凯泽窗的阶数
dealt=3;%凯泽窗的形状参数
Nf=2048;
M=(Nwin-1)/2;
n=0:Nwin-1;
fa=89;fb=178;fc=355;fd=708;fe=1413;ff=2818;fg=5623;fh=11220;%各频率点频率值
wa=2*pi*fa/Fs;wb=2*pi*fb/Fs;wc=2*pi*fc/Fs;wd=2*pi*fd/Fs;we=2*pi*fe/Fs; %频率归一化
wf=2*pi*ff/Fs;wg=2*pi*fg/Fs;wh=2*pi*fh/Fs;
dap=sin(wa*(n-M))./(pi*(n-M)+eps);%频带1滤波器的单位冲激响应
dbp=(sin(wb*(n-M))-sin(wa*(n-M)))./(pi*(n-M)+eps);%频带2滤波器的单位冲激响应
dcp=(sin(wc*(n-M))-sin(wb*(n-M)))./(pi*(n-M)+eps);%频带3滤波器的单位冲激响应
ddp=(sin(wd*(n-M))-sin(wc*(n-M)))./(pi*(n-M)+eps);%频带4滤波器的单位冲激响应
dep=(sin(we*(n-M))-sin(wd*(n-M)))./(pi*(n-M)+eps);%频带5滤波器的单位冲激响应
dfp=(sin(wf*(n-M))-sin(we*(n-M)))./(pi*(n-M)+eps);%频带6滤波器的单位冲激响应
dgp=(sin(wg*(n-M))-sin(wf*(n-M)))./(pi*(n-M)+eps);%频带7滤波器的单位冲激响应
dhp=(sin(wh*(n-M))-sin(wg*(n-M)))./(pi*(n-M)+eps);%频带8滤波器的单位冲激响应
dip=[(n-M)==0]-sin(wh*(n-M))./(pi*(n-M)+eps);%频带9滤波器的单位冲激响应

w_kaiser=kaiser(Nwin,dealt);%凯泽窗
wn=w_kaiser';
hap=wn.*dap;%对单位冲激响应加凯泽窗
hbp=wn.*dbp;
hcp=wn.*dcp;
hdp=wn.*ddp;
hep=wn.*dep;
hfp=wn.*dfp;
hgp=wn.*dgp;
hhp=wn.*dhp;
hip=wn.*dip;
%求冲激响应的傅里叶变换
[y1,fh]=freqz(hap,1,Nf,Fs);
[y2,fh]=freqz(hbp,1,Nf,Fs);[y3,fh]=freqz(hcp,1,Nf,Fs);
[y4,fh]=freqz(hdp,1,Nf,Fs);[y5,fh]=freqz(hep,1,Nf,Fs);[y6,fh]=freqz(hfp,1,Nf,Fs);
[y7,fh]=freqz(hgp,1,Nf,Fs);[y8,fh]=freqz(hhp,1,Nf,Fs);[y9,fh]=freqz(hip,1,Nf,Fs);
mag1=abs(y1);mag2=abs(y2);mag3=abs(y3);mag4=abs(y4);
mag5=abs(y5);mag6=abs(y6);mag7=abs(y7);mag8=abs(y8);
mag9=abs(y9);
%各个波段的幅频图
%subplot(4,2,1),plot(fh,10*log(mag1));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带1滤波器的幅频图');
%subplot(4,2,2),plot(f,20*log(mag2));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带2滤波器的幅频图');
%subplot(4,2,3),plot(f,20*log(mag3));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带3滤波器的幅频图');
%subplot(4,2,4),plot(f,20*log(mag4));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带4滤波器的幅频图');
%subplot(4,2,5),plot(f,20*log(mag5));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带5滤波器的幅频图');
%subplot(4,2,6),plot(f,20*log(mag6));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带6滤波器的幅频图');
%subplot(4,2,7),plot(f,20*log(mag7));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带7滤波器的幅频图');
%subplot(4,2,8),plot(f,20*log(mag8));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('频带8滤波器的幅频图');
%figure;
g1=1;g2=6.3;g3=2.5;g4=1;g5=1;g6=1;g7=1;g8=1.6;g9=1.6;%调节系数，用于调节不同频段的信号的幅值
%y=g1*y1+g2*y2+g3*y3+g4*y4+g5*y5+g6*y6+g7*y7+g8*y8+g9*y9;%均衡器的输出
y=g2*y2+g3*y3+g4*y4+g5*y5+g6*y6+g7*y7+g8*y8+g9*y9;%均衡器的输出
subplot(2,2,2);
plot(fh,10*log10(abs(y)));
c=ifft(y);
d=conv2(a,c);
Nd=length(d);
t=1:Nd;
subplot(2,2,3);
plot(t,d)
Xd=fftshift(fft(d,Nd))/Fs;
fd=-Fs/2+(0:Nd-1)*Fs/Nd;
subplot(2,2,4);
plot(fd,abs(Xd))%虚部未作处理
absd=abs(d);
Xabsd=fftshift(fft(absd,Nd))/Fs;
fabsd=-Fs/2+(0:Nd-1)*Fs/Nd;
plot(fabsd,abs(Xabsd))
plot(fd,absd)
%an=angle(y);
%plot(fh,an(1:Nf))
%audiowrite('C:\Users\Administrator\Desktop\xxxx.wav',absd,Fs);