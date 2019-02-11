%BP算法训练：监督学习%
clear;
x=-4:0.01:4; %产生[-4,4]之间的行向量
y1=sin((1/2)*pi*x)+sin(pi*x);%期望输出

for i=1000:1000:10000
%step1:newff前馈网络创建函数
%minmax(x)获取输入x的取值范围，min和max，第一个隐藏层其实相当于对输入进行归一化
%第1个隐藏层含1个神经元，激活函数是tansig,第2个隐藏层含20个，激活函数是tansig,输出层含1个,激活函数是线性函数
%训练函数是梯度下降函数traingd
net=newff(minmax(x),[1,20,1],{'tansig','tansig','purelin'},'traingd'); 
net.trainparam.epochs=i; %设置最大迭代次数
net.trainparam.goal=0.00001; %设置神经网络训练的目标误差

net=train(net,x,y1); %step2:训练神经网络，返回训练好的网络和误差记录
y2=sim(net,x); %step3:获取BP训练后的实际输出
max_e(i/1000)=max(abs(y1-y2));
avg_e(i/1000)=mean(y1-y2);
figure(i/1000);
%Pause  %绘图，原图（蓝色光滑线）和仿真效果图（红色+号点线） 
plot(x,y1);%画出期望图像 
hold on 
plot(x,y2,'r'); %画出训练得到的图像
title(['trainparam.epochs=',string(i)]);
end