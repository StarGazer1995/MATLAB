num1=[1 1];
den1=[1 4 4];
num2=[3 5];
den2=[1 6 11 6];%�������ݺ�����ϵ������
[num3,den3]=parallel(num1,den1,num2,den2);%��⴫�ݺ����Ĳ��д��ݷ���
[num4,den4]=series(num1,den1,num2,den2);%��⴫�ݺ����Ĵ��д��ݷ���
[num5,den5]=feedback(num1,den1,num2,den2);%��⴫�ݺ����ķ������ݷ���
[a,b,c,d]=tf2ss(num3,den3);
[a1,b1,c1,d1]=tf2ss(num4,den4);
[a2,b2,c2,d2]=tf2ss(num5,den5);
[A,B,C,D]=tf2ss(num1,den1);
[A1,B1,C1,D1]=tf2ss(num2,den2);%�����ռ�״̬����
[A2,B2,C2,D2]=parallel(A,B,C,D,A1,B1,C1,D1);%���ռ�״̬�Ĳ��пռ�
[A3,B3,C3,D3]=series(A,B,C,D,A1,B1,C1,D1);%���ռ�״̬�Ĵ��пռ�
[A4,B4,C4,D4]=feedback(A,B,C,D,A1,B1,C1,D1);%���ռ�״̬�ķ����ռ�
[num6,den6]=ss2tf(A2,B2,C2,D2);%���ռ�״̬�Ĳ��пռ����
[num7,den7]=ss2tf(A3,B3,C3,D3);%���ռ�״̬�Ĵ��пռ����
[num8,den8]=ss2tf(A4,B4,C4,D4);%���ռ�״̬�ķ����ռ����
figure(1);uitable('data',[a;a1;a2],'position',[20 20 1000 350],'rowname',{'��������a';' ';' ';' ';' ';'��������a';' ';' ';' ';' ';'��������a';' ';' ';' ';' '})%�г����
figure(2);uitable('data',[num3;num6;num4;num7;num5;num8;den3;den6;den4;den6;den5;den8],'position',[20 20 600 350],'rowname',['��������num';'�ռ䲢��num';'��������num';'�ռ䴮��num';'��������num';'�ռ䷴��num';'��������den';'�ռ䲢��den';'��������den';'�ռ䴮��den';'��������den';'�ռ䷴��den'])%�г����
figure(3);uitable('data',[eig(a) eig(A2) eig(a1) eig(A3) eig(a2) eig(A4)],'position',[20 20 600 350],'columnname',['��������a';'�ռ䲢��A';'��������a';'�ռ䴮��A';'��������a';'�ռ䷴��A'])%�г����