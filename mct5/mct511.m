fprintf('����ȫά�۲���');
A=[0 1;0 -2];
B=[0;1]; 
C=[4 0]; 
V1=[-2+1i*2*sqrt(3) -2-1i*2*sqrt(3)];
fprintf('�ջ�����ϵ��K1');
K1=acker(A,B,V1)
V2=[-8 -8];
fprintf('ȫά�۲���\n');
G=(acker((A-B*K1)',C',V2))'

fprintf('Ϊ��ά�۲���������任');
T =[0 0.25;1 0];
T1=T^-1;
A1 =T1*A*T
B1 =T1*B;
C1 =C*T;

Aaa=A1(1,1);
Aab=A1(1,2); 
Aba=A1(2,1); 
Abb=A1(2,2); 
Ba=B1(1,1); 
Bb=B1(2,1); 
v3=-8; 

fprintf('����ϵ������\n');
l=(acker(Aaa,Aba,v3)) 
Ahat=Abb-l*Aab 
Bhat=Ahat*l+Aba-l*Aaa 
Fhat=Bb-l*Ba
% ��ͼ����
sys=ss(A-B*K1,[0;0],eye(2),0);
t=0:0.01:4; 
x=initial(sys,[1;0],t); 
x1=[1 0 ]*x'; 
x2=[0 1 ]*x'; 
subplot(3,2,1);plot(t,x1),grid; 
title('x1') ;
ylabel('x1');
subplot(3,2,2);plot(t,x2),grid; 
title('x2') ;
ylabel('x2');

sys1=ss(A-G*C,[0;0],eye(2),0);
e=initial(sys1,[1;0],t); 
e1=[1 0 ]*x'+x1; 
e2=[0 1 ]*x'+x2; 
subplot(3,2,3);plot(t,e1),grid; 
title('ȫ��״̬�۲�x1'); 
ylabel('x1״̬�仯');
subplot(3,2,4);plot(t,e2),grid ;
title('ȫ��״̬�۲�x2');
ylabel('x2״̬�仯') ;

sys2=ss(Aaa-l*Aba,1,eye(1),0);
t=0:0.01:4;
e3=initial(sys2,1,t); 
e4=e3'+x1; 
e5=x2; 
subplot(3,2,5);plot(t,e4),grid; 
title('����״̬�۲�x1') ;
ylabel('x1״̬�仯');
subplot(3,2,6);plot(t,e5),grid; 
title('����״̬�۲�x2');
ylabel('x2״̬�仯') ;