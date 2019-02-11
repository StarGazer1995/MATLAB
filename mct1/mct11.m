z=[];%零点模型
p=[0 -1 -1 -3];%极点的建立
k=4;%建立zpk函数模型
[A,B,C,D]=zp2ss(z,p,k);%求解状态空间表达式
[num1,den1]=ss2tf(A,B,C,D);%从状态空间表达式转换到传递函数形式
[E]=jordants(num1,den1);%建立约旦标准型
[num2,den2]=ss2tf(E.A,E.B,E.C,E.D);
figure(1);
uitable('data',[num1;num2;den1;den2],'position',[0 0 600 400],'RowName',['num1';'num2';'den1';'den2'])