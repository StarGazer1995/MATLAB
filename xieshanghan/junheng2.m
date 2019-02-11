[a,Fs]=audioread('G:\\MATLAB\\script\\xieshanghan\\���֮��.mp3');
Na=length(a);
Xa=fftshift(fft(a,Na))/Fs;
fa=-Fs/2+(0:Na-1)*Fs/Na;
subplot(2,2,1);
plot(fa,abs(Xa))

Nwin=637;%���󴰵Ľ���
dealt=3;%���󴰵���״����
Nf=2048;
M=(Nwin-1)/2;
n=0:Nwin-1;
fa=89;fb=178;fc=355;fd=708;fe=1413;ff=2818;fg=5623;fh=11220;%��Ƶ�ʵ�Ƶ��ֵ
wa=2*pi*fa/Fs;wb=2*pi*fb/Fs;wc=2*pi*fc/Fs;wd=2*pi*fd/Fs;we=2*pi*fe/Fs; %Ƶ�ʹ�һ��
wf=2*pi*ff/Fs;wg=2*pi*fg/Fs;wh=2*pi*fh/Fs;
dap=sin(wa*(n-M))./(pi*(n-M)+eps);%Ƶ��1�˲����ĵ�λ�弤��Ӧ
dbp=(sin(wb*(n-M))-sin(wa*(n-M)))./(pi*(n-M)+eps);%Ƶ��2�˲����ĵ�λ�弤��Ӧ
dcp=(sin(wc*(n-M))-sin(wb*(n-M)))./(pi*(n-M)+eps);%Ƶ��3�˲����ĵ�λ�弤��Ӧ
ddp=(sin(wd*(n-M))-sin(wc*(n-M)))./(pi*(n-M)+eps);%Ƶ��4�˲����ĵ�λ�弤��Ӧ
dep=(sin(we*(n-M))-sin(wd*(n-M)))./(pi*(n-M)+eps);%Ƶ��5�˲����ĵ�λ�弤��Ӧ
dfp=(sin(wf*(n-M))-sin(we*(n-M)))./(pi*(n-M)+eps);%Ƶ��6�˲����ĵ�λ�弤��Ӧ
dgp=(sin(wg*(n-M))-sin(wf*(n-M)))./(pi*(n-M)+eps);%Ƶ��7�˲����ĵ�λ�弤��Ӧ
dhp=(sin(wh*(n-M))-sin(wg*(n-M)))./(pi*(n-M)+eps);%Ƶ��8�˲����ĵ�λ�弤��Ӧ
dip=[(n-M)==0]-sin(wh*(n-M))./(pi*(n-M)+eps);%Ƶ��9�˲����ĵ�λ�弤��Ӧ

w_kaiser=kaiser(Nwin,dealt);%����
wn=w_kaiser';
hap=wn.*dap;%�Ե�λ�弤��Ӧ�ӿ���
hbp=wn.*dbp;
hcp=wn.*dcp;
hdp=wn.*ddp;
hep=wn.*dep;
hfp=wn.*dfp;
hgp=wn.*dgp;
hhp=wn.*dhp;
hip=wn.*dip;
%��弤��Ӧ�ĸ���Ҷ�任
[y1,fh]=freqz(hap,1,Nf,Fs);
[y2,fh]=freqz(hbp,1,Nf,Fs);[y3,fh]=freqz(hcp,1,Nf,Fs);
[y4,fh]=freqz(hdp,1,Nf,Fs);[y5,fh]=freqz(hep,1,Nf,Fs);[y6,fh]=freqz(hfp,1,Nf,Fs);
[y7,fh]=freqz(hgp,1,Nf,Fs);[y8,fh]=freqz(hhp,1,Nf,Fs);[y9,fh]=freqz(hip,1,Nf,Fs);
mag1=abs(y1);mag2=abs(y2);mag3=abs(y3);mag4=abs(y4);
mag5=abs(y5);mag6=abs(y6);mag7=abs(y7);mag8=abs(y8);
mag9=abs(y9);
%�������εķ�Ƶͼ
%subplot(4,2,1),plot(fh,10*log(mag1));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��1�˲����ķ�Ƶͼ');
%subplot(4,2,2),plot(f,20*log(mag2));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��2�˲����ķ�Ƶͼ');
%subplot(4,2,3),plot(f,20*log(mag3));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��3�˲����ķ�Ƶͼ');
%subplot(4,2,4),plot(f,20*log(mag4));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��4�˲����ķ�Ƶͼ');
%subplot(4,2,5),plot(f,20*log(mag5));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��5�˲����ķ�Ƶͼ');
%subplot(4,2,6),plot(f,20*log(mag6));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��6�˲����ķ�Ƶͼ');
%subplot(4,2,7),plot(f,20*log(mag7));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��7�˲����ķ�Ƶͼ');
%subplot(4,2,8),plot(f,20*log(mag8));xlabel('f/Hz');ylabel('|H(f)|/dB');grid on;title('Ƶ��8�˲����ķ�Ƶͼ');
%figure;
g1=1;g2=6.3;g3=2.5;g4=1;g5=1;g6=1;g7=1;g8=1.6;g9=1.6;%����ϵ�������ڵ��ڲ�ͬƵ�ε��źŵķ�ֵ
%y=g1*y1+g2*y2+g3*y3+g4*y4+g5*y5+g6*y6+g7*y7+g8*y8+g9*y9;%�����������
y=g2*y2+g3*y3+g4*y4+g5*y5+g6*y6+g7*y7+g8*y8+g9*y9;%�����������
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
plot(fd,abs(Xd))%�鲿δ������
absd=abs(d);
Xabsd=fftshift(fft(absd,Nd))/Fs;
fabsd=-Fs/2+(0:Nd-1)*Fs/Nd;
plot(fabsd,abs(Xabsd))
plot(fd,absd)
%an=angle(y);
%plot(fh,an(1:Nf))
%audiowrite('C:\Users\Administrator\Desktop\xxxx.wav',absd,Fs);