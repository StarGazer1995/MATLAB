A=[0 1;-5 -6];
B=[0;1];
C=[1 1];
D=0;%建立空间状态方程
A1=eig(A);%求解特征值
sys=ss(A,B,C,D);%建立空间状态函数
[num,den]=ss2tf(A,B,C,D);
den=roots(den);
[z,p,k]=ss2zp(A,B,C,D);
AA=canon(sys,'modal');
A2=eig(AA);
[num1,den1]=ss2tf(AA.A,AA.B,AA.C,AA.D);
den1=roots(den1);
[z1,p1,k1]=ss2zp(AA.A,AA.B,AA.C,AA.D);
figure(1);uitable('data',[A1 den p],'columnname',{'系统特征值';'tf系统极点';'zpk系统极点'})
figure(2);uitable('data',[A2 A1 den1 p1],'Position', [20 20 350 300],'columnname',{'标准化后的系统极点';'系统特征值';'tf系统极点';'zpk系统极点'})