num=20;
den=[1 20 20];
J=[-7.07+1i*7.07,-7.07-1i*7];%��������
[A,B,C,D]= tf2ss(num,den);
k=place(A,B,J)%����kֵ
ss1=ss(A,B,C,D);
ss2=ss(A-B*k,B,C,D);
t=0:0.01:5;
y10=initial(ss1,[1;1],t);
y20=initial(ss2,[1;1],t);
y1=step(ss1,t);
y2=step(ss2,t);
figure(1);
subplot(2,1,1);plot(t,y10');legend('δ���븺�������ƾ���k');title('��������Ӧ');
subplot(2,1,2);plot(t,y20','r');legend('���뷴�����ƾ���k');
figure(2);
subplot(2,1,1);plot(t,y1);legend('δ���븺�������ƾ���k');title('ϵͳ��״̬��Ӧ');
subplot(2,1,2);plot(t,y2','r');legend('���뷴�����ƾ���k');