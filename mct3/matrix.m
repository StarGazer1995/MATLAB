function [G1,T1,G2,T2,G3,T3,G4,T4]=matrix(A,B,C,D)
sys=ss(A,B,C,D);
[~,den]=ss2tf(A,B,C,D);
p=roots(den)';
for i=1:length(p)
    if p(:,i)>0     %判断空间是否是稳定的
         fprintf('system is unstable!\n');
         G1=0;T1=0;G2=0;T2=0;G3=0;T3=0;G4=0;T4=0;
         return 
    end    
end
fprintf('system stable\n','computing\n');
fprintf('Computing\n');
[T1,~]=eig(A);%对角线标准型变换矩阵
[T2,~]=jordan(A);%约旦标准型变换矩阵
fprintf('对角线标准型\n');
G1=ss2ss(sys,T1)
T1
fprintf('约旦标准型\n');
G2=ss2ss(sys,T2)
T2
fprintf('模态标准型\n');
[G3,T3]=canon(sys,'modal')%模态标准型
fprintf('伴随矩阵标准型\n');
[G4,T4]=canon(sys,'companion')%伴随矩阵标准型
Tc1=ctrb(A,B);
To1=obsv(A,C);
if rank(Tc1)~=size(min(A))
    fprintf('矩阵不可控\n');
    [Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C)
else
    fprintf('矩阵可控,按照可控性分解gram矩阵\n');
    W1=gram(sys,'c')
    fprintf('矩阵可控,按照可控性分解\n')
    [Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C)
end;
if rank(To1)~=size(min(A))
    fprintf('矩阵不可观\n');
    [Ao,Bo,Co,To,Ko]=ctrbf(A,B,C)
else
    fprintf('矩阵可观，按照客观性分解gram矩阵\n');
    W2=gram(sys,'o')
    fprintf('矩阵可观,按照可控性分解\n');
    [Ao,Bo,Co,To,Ko]=ctrbf(A,B,C)
end
