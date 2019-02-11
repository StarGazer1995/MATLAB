function[xm,fv]=PSO(fitness,N,c1,c2,w,M,D)
%{xm,fv算法最后得到的最优解时的x及最优解，fitness为适应度，即要优化的目标函数，N为种群数量,
% c1,c2为学习因子,w为惯性权重，M为迭代次数，D为粒子的维数}%?
format long; %初始化种群?
for i=1:N
for j=1:D 
x(i,j)=randn; %随机初始化位置?????????
v(i,j)=randn; %随机初始化速度?
end 
end
%先计算各个粒子的适应度pi，并初始化y-粒子个体极值，pg-全局极值
for i=1:N 
p(i)=fitness(x(i,:));%适应???
y(i,:)=x(i,:); %个体极值
end
pg=x(N,:);%初始化全局极值/最优
for i=1:N-1
if fitness(x(i,:))<fitness(pg)
    pg=x(i,:);%替换并选出全局极值
end
end
%进入粒子群算法主要循环，更新v及x?
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
    pbest(t)=fitness(pg);%M次迭代后最优解?
end
xm=pg';%为何要共轭转置？?
fv=fitness(pg);