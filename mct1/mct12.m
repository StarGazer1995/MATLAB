num1=[1 6 8];%分子tf函数模型
den1=[1 4 3];%建立分母tf函数模型
[A,B,C,D]=tf2ss(num1,den1);%求解状态空间表达式
[num2,den2]=ss2tf(A,B,C,D);%从状态空间表达式转换到传递函数形式
[E]=jordants(num1,den1);%建立约旦标准型
[num3,den3]=ss2tf(E.A,E.B,E.C,E.D);
figure(1);
uitable('data',[num1;num2;num3;den1;den2;den3],'position',[0 0 600 400],'RowName',['num1';'num2';'num3';'den1';'den2';'den3'])