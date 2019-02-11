A=[0 1;-3 -4];
B=[0;1];
C=[3 2];
D=0;
J=[-4 -5];%数据输入
k=place(A,B,J);%计算k值
ss1=ss(A,B,C,D);
ss2=ss(A-B*k,B,C,D);
t=0:0.01:5;
y10=initial(ss1,[1;1],t);
y20=initial(ss2,[1;1],t);
[num,den]=ss2tf(A,B,C,D);
[num1,den1]=ss2tf(A-B*k,B,C,D);
y1=step(ss1,t);
y2=step(ss2,t);
figure(1);
subplot(2,1,1);plot(t,y10');legend('未加入负反馈控制矩阵k');title('零输入响应');
subplot(2,1,2);plot(t,y20','r');legend('加入反馈控制矩阵k');
figure(2);
subplot(2,1,1);plot(t,y1);legend('未加入负反馈控制矩阵k');title('系统零状态响应');
subplot(2,1,2);plot(t,y2','r');legend('加入反馈控制矩阵k');