z=[];%���ģ��
p=[0 -1 -1 -3];%����Ľ���
k=4;%����zpk����ģ��
[A,B,C,D]=zp2ss(z,p,k);%���״̬�ռ���ʽ
[num1,den1]=ss2tf(A,B,C,D);%��״̬�ռ���ʽת�������ݺ�����ʽ
[E]=jordants(num1,den1);%����Լ����׼��
[num2,den2]=ss2tf(E.A,E.B,E.C,E.D);
figure(1);
uitable('data',[num1;num2;den1;den2],'position',[0 0 600 400],'RowName',['num1';'num2';'den1';'den2'])