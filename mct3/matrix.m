function [G1,T1,G2,T2,G3,T3,G4,T4]=matrix(A,B,C,D)
sys=ss(A,B,C,D);
[~,den]=ss2tf(A,B,C,D);
p=roots(den)';
for i=1:length(p)
    if p(:,i)>0     %�жϿռ��Ƿ����ȶ���
         fprintf('system is unstable!\n');
         G1=0;T1=0;G2=0;T2=0;G3=0;T3=0;G4=0;T4=0;
         return 
    end    
end
fprintf('system stable\n','computing\n');
fprintf('Computing\n');
[T1,~]=eig(A);%�Խ��߱�׼�ͱ任����
[T2,~]=jordan(A);%Լ����׼�ͱ任����
fprintf('�Խ��߱�׼��\n');
G1=ss2ss(sys,T1)
T1
fprintf('Լ����׼��\n');
G2=ss2ss(sys,T2)
T2
fprintf('ģ̬��׼��\n');
[G3,T3]=canon(sys,'modal')%ģ̬��׼��
fprintf('��������׼��\n');
[G4,T4]=canon(sys,'companion')%��������׼��
Tc1=ctrb(A,B);
To1=obsv(A,C);
if rank(Tc1)~=size(min(A))
    fprintf('���󲻿ɿ�\n');
    [Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C)
else
    fprintf('����ɿ�,���տɿ��Էֽ�gram����\n');
    W1=gram(sys,'c')
    fprintf('����ɿ�,���տɿ��Էֽ�\n')
    [Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C)
end;
if rank(To1)~=size(min(A))
    fprintf('���󲻿ɹ�\n');
    [Ao,Bo,Co,To,Ko]=ctrbf(A,B,C)
else
    fprintf('����ɹۣ����տ͹��Էֽ�gram����\n');
    W2=gram(sys,'o')
    fprintf('����ɹ�,���տɿ��Էֽ�\n');
    [Ao,Bo,Co,To,Ko]=ctrbf(A,B,C)
end
