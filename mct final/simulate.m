function y=simulate(sys,t,flag)
y=step(sys,t);
plot(t,y)
if flag==0
k=dcgain(sys.A,sys.B,sys.C,sys.D);
tr=min(find(y>0.90*k))/100;
legend(['ϵͳ��ֵ̬Ϊ',num2str(k),'ϵͳ����ʱ��Ϊ',num2str(tr),'s']);
else
    legend('����ϵͳ���ȶ����޷�����������ֵ���м���\n');
end
end