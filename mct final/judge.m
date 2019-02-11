function [flag,flag_ct,flag_ob]=judge(A,B,C,D)
p=eig(A)';
for i=1:length(p)
    if p(:,i)>0     %判断空间是否是稳定的
         fprintf('系统不稳定\n');
         flag=1;
         return
    end    
end
fprintf('系统稳定\n');

flag=0;

Tc1=ctrb(A,B);
To1=obsv(A,C);
if rank(Tc1)~=size(min(Tc1))
    fprintf('矩阵不可控\n');
    fprintf('按照能控性分解\n');
    [Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C);
    flag_ct=1;
else
    fprintf('矩阵可控\n');
    fprintf('因为系统完全能控，不需要按照能控性分解\n');
    flag_ct=0;
end;%判断系统能控性
if rank(To1)~=size(min(To1))
    fprintf('矩阵不可观\n');
    fprintf('按照能观性分解\n');
    [Ao,Bo,Co,To,Ko]=cbsvf(A,B,C)
    flag_ob=1;
else
    fprintf('矩阵可观\n');
    fprintf('因为系统完全能控，不需要按照能控性分解\n');
    flag_ob=0;
end%判断系统能观性

end