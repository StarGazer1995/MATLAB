num1=[1 1];
den1=[1 4 4];
num2=[3 5];
den2=[1 6 11 6];%建立传递函数的系数矩阵
[num3,den3]=parallel(num1,den1,num2,den2);%求解传递函数的并行传递方程
[num4,den4]=series(num1,den1,num2,den2);%求解传递函数的串行传递方程
[num5,den5]=feedback(num1,den1,num2,den2);%求解传递函数的反馈传递方程
[a,b,c,d]=tf2ss(num3,den3);
[a1,b1,c1,d1]=tf2ss(num4,den4);
[a2,b2,c2,d2]=tf2ss(num5,den5);
[A,B,C,D]=tf2ss(num1,den1);
[A1,B1,C1,D1]=tf2ss(num2,den2);%建立空间状态矩阵
[A2,B2,C2,D2]=parallel(A,B,C,D,A1,B1,C1,D1);%求解空间状态的并行空间
[A3,B3,C3,D3]=series(A,B,C,D,A1,B1,C1,D1);%求解空间状态的串行空间
[A4,B4,C4,D4]=feedback(A,B,C,D,A1,B1,C1,D1);%求解空间状态的反馈空间
[num6,den6]=ss2tf(A2,B2,C2,D2);%求解空间状态的并行空间求解
[num7,den7]=ss2tf(A3,B3,C3,D3);%求解空间状态的串行空间求解
[num8,den8]=ss2tf(A4,B4,C4,D4);%求解空间状态的反馈空间求解
figure(1);uitable('data',[a;a1;a2],'position',[20 20 1000 350],'rowname',{'传函并联a';' ';' ';' ';' ';'传函串联a';' ';' ';' ';' ';'传函反馈a';' ';' ';' ';' '})%列出表格
figure(2);uitable('data',[num3;num6;num4;num7;num5;num8;den3;den6;den4;den6;den5;den8],'position',[20 20 600 350],'rowname',['传函并联num';'空间并联num';'传函串联num';'空间串联num';'传函反馈num';'空间反馈num';'传函并联den';'空间并联den';'传函串联den';'空间串联den';'传函反馈den';'空间反馈den'])%列出表格
figure(3);uitable('data',[eig(a) eig(A2) eig(a1) eig(A3) eig(a2) eig(A4)],'position',[20 20 600 350],'columnname',['传函并联a';'空间并联A';'传函串联a';'空间串联A';'传函反馈a';'空间反馈A'])%列出表格