function Gj=jordants(num,den)  %�ò��ַ�ʽչ�������ݺ���ת��ΪԼ����׼��
[R,P,K]=residue(num,den);
j=1;q=P(1);m(1)=0;
for i=1:length(P)
   if P(i)==q
       m(j)=m(j)+1;
   else q=P(i);
       j=j+1;
       m(j)=1;
   end
end               %��������������
Aj=diag(P);
for i=1:length(P)-1
   if Aj(i,i)==Aj(i+1,i+1)
       Aj(i,i+1)=1;
   else Aj(i,i+1)=0;
   end
end           %����ϵͳ����Aj
B1=0;
l=0;
for j=1:length(m)
l=l+m(j);
B1(l)=1;
end     
Bj=B1';        %�����������Bj
n=1;l=m(1);
Cj(:,1:m(1))=rot90(R(1:m(1),:),3);
for k=2:length(m)
n=l+1;l=l+m(k);
Cj(:,n:l)=rot90(R(n:l,:),3);
end           %�����������Cj 
if K==[ ]
 Dj=0;
else
 Dj=K; 
end         %����ֱ������Dj 
Gj=ss(Aj,Bj,Cj,Dj);
