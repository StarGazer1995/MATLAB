function[xm,fv]=PSO(fitness,N,c1,c2,w,M,D)
%{xm,fv�㷨���õ������Ž�ʱ��x�����Ž⣬fitnessΪ��Ӧ�ȣ���Ҫ�Ż���Ŀ�꺯����NΪ��Ⱥ����,
% c1,c2Ϊѧϰ����,wΪ����Ȩ�أ�MΪ����������DΪ���ӵ�ά��}%?
format long; %��ʼ����Ⱥ?
for i=1:N
for j=1:D 
x(i,j)=randn; %�����ʼ��λ��?????????
v(i,j)=randn; %�����ʼ���ٶ�?
end 
end
%�ȼ���������ӵ���Ӧ��pi������ʼ��y-���Ӹ��弫ֵ��pg-ȫ�ּ�ֵ
for i=1:N 
p(i)=fitness(x(i,:));%��Ӧ???
y(i,:)=x(i,:); %���弫ֵ
end
pg=x(N,:);%��ʼ��ȫ�ּ�ֵ/����
for i=1:N-1
if fitness(x(i,:))<fitness(pg)
    pg=x(i,:);%�滻��ѡ��ȫ�ּ�ֵ
end
end
%��������Ⱥ�㷨��Ҫѭ��������v��x?
for t=1:M 
    for i=1:N
v(i,:)=w*v(i,:)+c1*rand*(y(1,:)-x(1,:))+c2*rand*(pg-x(i,:));
x(i,:)=x(i,:)+v(i,:); 
if fitness(x(i,:))<p(i)
    p(i)=fitness(x(i,:));
    y(i,:)=x(i,:);
end
if p(i)<fitness(pg)
    pg=y(i,:);
end
    end
    pbest(t)=fitness(pg);%M�ε��������Ž�?
end
xm=pg';%Ϊ��Ҫ����ת�ã�?
fv=fitness(pg);