syms t; A=[0,-1;4,0]; f=expm(A*t)
syms t; A=[0 1 0;0 0 1;2 -5 4]; f1=expm(A*t)
syms t,syms lambda; A=[lambda 0 0;0,lambda 0;0 0 lambda]; f2=expm(A*t)
syms t,syms lambda; A=[lambda 0 0 0;0 lambda 1 0;0 0 lambda 1;0 0 0 lambda]; f3=expm(A*t)