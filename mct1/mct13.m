num=[1 1 1];
den=[1 6 11 6];
[z,p,k]=tf2zp(num,den);% ����ZPKģ��
[A,B,C,D]=zp2ss(z,p,k);%���״̬�ռ���ʽ
[z1,p1,k1]=ss2zp(A,B,C,D);%��״̬�ռ���ʽת�������ݺ�����ʽ
[E]=jordants(num,den);%����Լ����׼��
[z2,p2,k2]=ss2zp(E.A,E.B,E.C,E.D);%����Լ����׼�ͺ���ؽ�
figure(1);
uitable('data',[z z1 z2],'position',[0 0 600 400],'ColumnName',{'z';'z1';'z2'})
figure(2);
uitable('data',[p p1 p2],'position',[0 0 600 400],'ColumnName',{'p';'p1';'p2'})