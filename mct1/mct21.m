A=[0 1;-5 -6];
B=[0;1];
C=[1 1];
D=0;%�����ռ�״̬����
A1=eig(A);%�������ֵ
sys=ss(A,B,C,D);%�����ռ�״̬����
[num,den]=ss2tf(A,B,C,D);
den=roots(den);
[z,p,k]=ss2zp(A,B,C,D);
AA=canon(sys,'modal');
A2=eig(AA);
[num1,den1]=ss2tf(AA.A,AA.B,AA.C,AA.D);
den1=roots(den1);
[z1,p1,k1]=ss2zp(AA.A,AA.B,AA.C,AA.D);
figure(1);uitable('data',[A1 den p],'columnname',{'ϵͳ����ֵ';'tfϵͳ����';'zpkϵͳ����'})
figure(2);uitable('data',[A2 A1 den1 p1],'Position', [20 20 350 300],'columnname',{'��׼�����ϵͳ����';'ϵͳ����ֵ';'tfϵͳ����';'zpkϵͳ����'})