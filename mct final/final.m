t=0:0.01:30;                     %全局时间设定 

num=50;
den1=[1,10];
den2=[1,5];
den3=[1,3.2882,5.4059];
den=conv(conv(den1,den2),den3);
sys=tf(num,den);
y=step(sys,t);
k=dcgain(sys);
tr1=min(find(y>=0.9*k))/100;%matlab计算下的上升时间
[~,tp1]=max(y);%matlab计算下的峰值时间
tp1=tp1/100;%matlab计算下的峰值时间
sigma1=(max(y)-k)/k;
ts=max(find(y(:,1)>1.02*k))/100;
plot(t,y);
num1=2*num/k;
sys1=tf(num1,den);
y1=step(sys1,t);
k1=dcgain(sys1);
figure()
plot(t,y1);
