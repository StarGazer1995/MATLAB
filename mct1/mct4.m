num=[0 1 2;1 5 2];
den=[1 2 3 4];
[A,B,C,D]=tf2ss(num,den);
figure(1);uitable('data',A);
figure(2);uitable('data',B);
figure(3);uitable('data',C);
figure(4);uitable('data',D);