num1=[1 6 8];%����tf����ģ��
den1=[1 4 3];%������ĸtf����ģ��
[A,B,C,D]=tf2ss(num1,den1);%���״̬�ռ���ʽ
[num2,den2]=ss2tf(A,B,C,D);%��״̬�ռ���ʽת�������ݺ�����ʽ
[E]=jordants(num1,den1);%����Լ����׼��
[num3,den3]=ss2tf(E.A,E.B,E.C,E.D);
figure(1);
uitable('data',[num1;num2;num3;den1;den2;den3],'position',[0 0 600 400],'RowName',['num1';'num2';'num3';'den1';'den2';'den3'])