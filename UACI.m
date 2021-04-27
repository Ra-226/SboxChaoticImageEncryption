clc;clear;
%����ֹ�����������
%�����ĵ�������Խǿ���㷨�ֿ���ֹ���������Ҳ��Խǿ��
%�������������ı���NPCR (Numberof Pixels Change Rate)ָ����������㷨�����ĵ������ԣ�
%Ҳ�����ù�һ������ֵƽ���ı�ǿ��UACI (Unified Average Changing Intensity)ָ����������ԡ�
c1=imread('c1mtest.png');
c2=imread('c2mtest.png');
[M,N]=size(c1);
sum=0;
flag=0;
for i=1:M
    for j=1:N
        cha=(double(c2(i,j))-double(c1(i,j)))/255;
        if cha<0
            cha=-cha;
        end
        sum=sum+cha;

    end
end
uaci=1/(M*N)*sum*100;
fprintf('UACI  %25.24f\n',uaci);
