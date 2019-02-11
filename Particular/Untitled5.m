%粒子群算法求解极大值  
clc,clear  
  
vmax = 60;  
w = 1;  
num = 10000;  
  
x1 = zeros(2,num);  
x2 = zeros(2,num);  
x3 = zeros(2,num);  
x4 = zeros(2,num);  
x5 = zeros(2,num);  
x1(:,1) = [20; 20];  
x2(:,1) = [20; 40];  
x3(:,1) = [40; 20];  
x4(:,1) = [40; 40];  
x5(:,1) = [30; 30];  
x = zeros(5,2,num);  
x(1,:,1) = [20;20];  
x(2,:,1) = [20;40];  
x(3,:,1) = [40;20];  
x(4,:,1) = [40;40];  
x(5,:,1) = [30;30];  
  
pbest = zeros(5,2,num);  
pbest(1,:,1) = x(1,:,1);  
pbest(2,:,1) = x(2,:,1);  
pbest(3,:,1) = x(3,:,1);  
pbest(4,:,1) = x(4,:,1);  
pbest(5,:,1) = x(5,:,1);  
gbest = zeros(2,num);  
gbest(:,1) = x(1,:,1);  
for i = 2:5  
    if thefunction(gbest(1,1),gbest(2,1))<thefunction(pbest(i,1,1),pbest(i,2,1))  
        gbest(:,1) = pbest(i,:,1);  
    end  
end  
  
v = zeros(5,2,10000);  
for i = 1:5  
    v(i,:,1) = [1;1];  
end  
  
for i = 2:10000  
    for j = 1:5  
          
        v(j,:,i) = w*v(j,:,i-1)+rand(1)*(pbest(j,:,i-1)-x(j,:,i-1));  
        if v(j,1,i)>vmax  
            v(j,1,i) = vmax;  
        end  
        if v(j,2,i)>vmax  
            v(j,2,i) = vmax;  
        end  
          
        x(j,:,i) = x(j,:,i-1)+v(j,:,i);  
        if x(j,1,i)<0  
            x(j,1,i) = 0;  
        end  
        if x(j,1,i)>60  
            x(j,1,i) = 60;  
        end  
        if x(j,2,i)<0  
            x(j,2,i) = 0;  
        end  
        if x(j,2,i)>60  
            x(j,2,i) = 60;  
        end  
          
        if thefunction(x(j,1,i),x(j,2,i)>thefunction(pbest(j,1,i-1),pbest(j,2,i-1)))  
            pbest(j,:,i) = x(j,:,i);  
        else  
            pbest(j,:,i) = pbest(j,:,i-1);  
        end  
    end  
      
    gbest(:,i) = pbest(1,:,i);  
    for j = 2:4  
        if thefunction(gbest(1,i),gbest(2,i))<thefunction(pbest(j,1,i),pbest(j,2,i))  
            gbest(:,i) = pbest(j,:,i);  
        end  
    end  
      
end  
  
scatter(1:80,gbest(2,1:80))  
hold on  
%scatter(1:10000,gbest(2,:)) 