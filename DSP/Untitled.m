[x,fs]=audioread('G:\\MATLAB\\script\\DSP\\plane.wav');
fc1=15000;
x1=demod(x,fc1,fs,'am');
l=length(x);
f=[-l/2:l/2-1]*fs/l;
figure();
plot(f,fftshift(fft(x1)));
