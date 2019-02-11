num=[1 1 1];
den=[1 6 11 6];
[z,p,k]=tf2zp(num,den);% 建立ZPK模型
[A,B,C,D]=zp2ss(z,p,k);%求解状态空间表达式
[z1,p1,k1]=ss2zp(A,B,C,D);%从状态空间表达式转换到传递函数形式
[E]=jordants(num,den);%建立约旦标准型
[z2,p2,k2]=ss2zp(E.A,E.B,E.C,E.D);%建立约旦标准型后的重建
figure(1);
uitable('data',[z z1 z2],'position',[0 0 600 400],'ColumnName',{'z';'z1';'z2'})
figure(2);
uitable('data',[p p1 p2],'position',[0 0 600 400],'ColumnName',{'p';'p1';'p2'})