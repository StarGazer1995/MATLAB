%BP�㷨ѵ�����ලѧϰ%
clear;
x=-4:0.01:4; %����[-4,4]֮���������
y1=sin((1/2)*pi*x)+sin(pi*x);%�������

for i=1000:1000:10000
%step1:newffǰ�����紴������
%minmax(x)��ȡ����x��ȡֵ��Χ��min��max����һ�����ز���ʵ�൱�ڶ�������й�һ��
%��1�����ز㺬1����Ԫ���������tansig,��2�����ز㺬20�����������tansig,����㺬1��,����������Ժ���
%ѵ���������ݶ��½�����traingd
net=newff(minmax(x),[1,20,1],{'tansig','tansig','purelin'},'traingd'); 
net.trainparam.epochs=i; %��������������
net.trainparam.goal=0.00001; %����������ѵ����Ŀ�����

net=train(net,x,y1); %step2:ѵ�������磬����ѵ���õ����������¼
y2=sim(net,x); %step3:��ȡBPѵ�����ʵ�����
max_e(i/1000)=max(abs(y1-y2));
avg_e(i/1000)=mean(y1-y2);
figure(i/1000);
%Pause  %��ͼ��ԭͼ����ɫ�⻬�ߣ��ͷ���Ч��ͼ����ɫ+�ŵ��ߣ� 
plot(x,y1);%��������ͼ�� 
hold on 
plot(x,y2,'r'); %����ѵ���õ���ͼ��
title(['trainparam.epochs=',string(i)]);
end