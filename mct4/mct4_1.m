A=[0 1;-3 -4];
B=[0;1];
C=[3 2];
D=0;
J=[-4 -5];%��������
k=place(A,B,J);%����kֵ
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
subplot(2,1,1);plot(t,y10');legend('δ���븺�������ƾ���k');title('��������Ӧ');
subplot(2,1,2);plot(t,y20','r');legend('���뷴�����ƾ���k');
figure(2);
subplot(2,1,1);plot(t,y1);legend('δ���븺�������ƾ���k');title('ϵͳ��״̬��Ӧ');
subplot(2,1,2);plot(t,y2','r');legend('���뷴�����ƾ���k');