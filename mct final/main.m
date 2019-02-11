t=0:0.01:30;                     %全局时间设定       
            %%%%%计算前的准备工作%%%%%
K=0.5;
Jm=0.1;
Jl=0.05;
Bm=0.1;
Bl=0.7;                          %设定系数

den1=[Jl,Bl,K];
den2=[Jm,Bm,K];
den=conv(den1,den2);
num=K^2/den(:,1);                  %调整分子
den=(den-[0,0,0,0,K^3])/den(:,1);% 调整分母
[A,B,C,D]=tf2ss(num,den);        %建立系统状态矩阵
sys=ss(A,B,C,D);
            %%%%%系统零极点重新配置之前的计算%%%%%
fprintf('原系统判定\n');           
[flag,flag_ct,flag_ob]=judge(A,B,C,D);
                                 %系统判稳，flag为0时系统稳定，为1时系统不稳定
                                 %系统能控能观性判断
                                 %flag_oc为0时，矩阵可观,为1时不可观
                                 %flag_ct为0时，矩阵可控，为1时不可控
figure(1);
y=simulate(sys,t,flag);%计算系统单位阶跃响应并绘制响应曲线
            %%%%%系统零极点重新配置并计算%%%%%
P=[-10,-1,-1+1i,-1-1i];
k=place(A,B,P);
A1=A-B*k;
sys2=ss(A1,B,C,D);               %进行零极点配置，并重新生成状态控制量

fprintf('修改系统零极点后的判定');
[flag1,flag_ct1,flag_ob1]=judge(A1,B,C,D);
                                 %系统判稳，flag为0时系统稳定，为1时系统不稳定
                                 %系统能控能观性判断
                                 %flag_oc为0时，矩阵可观,为1时不可观
                                 %flag_ct为0时，矩阵可控，为1时不可控

figure(2);
y1=simulate(sys2,t,flag1);       %计算系统单位阶跃响应并绘制响应曲线

          %%%%%%设计全维观测器%%%%%%%
t=0:0.01:7;          
P1=[-10 -5 -2 -100];
G=(acker(A1',C',P1))';
A2=A1-G*C;
sys3=ss(A2,B,eye(4),D);
fprintf('全维观测器判定');
[flag2,flag_ct2,flag_ob2]=judge(A2,B,C,D);               %系统判稳，
                                 % flag为0时系统稳定
                                 %为1时系统不稳定
                                 %系统能控能观性判断
                                 %flag_oc为0时，矩阵可观,为1时不可观
                                 %flag_ct为0时，矩阵可控，为1时不可控
e1=initial(sys3,[1;1;1;1],t);
figure;
gzplot(e1,t);
          %%%%%%设计降维观测器%%%%%%%
C0=[1 0 0 0;0 1 0 0;0 0 1 0];
TL=[C0;C];
T=TL^-1;
A3=TL*A2*T;
B3=TL*B;
C3=C*T;                          %矩阵变换

A11=[A3(1,:);A3(2,:);A3(3,:)];
A11(:,4)=[];
A12=[A3(:,4)];
A12(4,:)=[];
A21=A3(4,:);
A21(:,4)=[];
A22=A3(4,4);
BO=B3;
BO(4,:)=[];
BI=B3(4,:);                      %矩阵分离，降维

P2=[-10 -5 -100];
G1=(acker(A11',A21',P2))';
Ahat=A11-G1*A21;
Bhat=A12-G1*A22;
Fhat=BO-G1*BI;                   %计算降维观测器的系数矩阵
%%%%%绘图比较%%%%%
sys4=ss(A11-G1*A21,BO,eye(3),0);
e=initial(sys4,[1;1;1],t);
figure();
gzplot(e,t);

