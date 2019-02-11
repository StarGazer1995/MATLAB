function y=simulate(sys,t,flag)
y=step(sys,t);
plot(t,y)
if flag==0
k=dcgain(sys.A,sys.B,sys.C,sys.D);
tr=min(find(y>0.90*k))/100;
legend(['系统稳态值为',num2str(k),'系统上升时间为',num2str(tr),'s']);
else
    legend('由于系统不稳定，无法对其特征数值进行计算\n');
end
end