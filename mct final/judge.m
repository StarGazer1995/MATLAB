function [flag,flag_ct,flag_ob]=judge(A,B,C,D)
p=eig(A)';
for i=1:length(p)
    if p(:,i)>0     %�жϿռ��Ƿ����ȶ���
         fprintf('ϵͳ���ȶ�\n');
         flag=1;
         return
    end    
end
fprintf('ϵͳ�ȶ�\n');

flag=0;

Tc1=ctrb(A,B);
To1=obsv(A,C);
if rank(Tc1)~=size(min(Tc1))
    fprintf('���󲻿ɿ�\n');
    fprintf('�����ܿ��Էֽ�\n');
    [Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C);
    flag_ct=1;
else
    fprintf('����ɿ�\n');
    fprintf('��Ϊϵͳ��ȫ�ܿأ�����Ҫ�����ܿ��Էֽ�\n');
    flag_ct=0;
end;%�ж�ϵͳ�ܿ���
if rank(To1)~=size(min(To1))
    fprintf('���󲻿ɹ�\n');
    fprintf('�����ܹ��Էֽ�\n');
    [Ao,Bo,Co,To,Ko]=cbsvf(A,B,C)
    flag_ob=1;
else
    fprintf('����ɹ�\n');
    fprintf('��Ϊϵͳ��ȫ�ܿأ�����Ҫ�����ܿ��Էֽ�\n');
    flag_ob=0;
end%�ж�ϵͳ�ܹ���

end