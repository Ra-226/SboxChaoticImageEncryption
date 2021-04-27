clc;clear;
%����ֹ�����������
%�����ĵ�������Խǿ���㷨�ֿ���ֹ���������Ҳ��Խǿ��
%�������������ı���NPCR (Numberof Pixels Change Rate)ָ����������㷨�����ĵ������ԣ�
%Ҳ�����ù�һ������ֵƽ���ı�ǿ��UACI (Unified Average Changing Intensity)ָ����������ԡ�
c1=imread('c1mtest.png');
c2=imread('c2mtest.png');
[M,N]=size(c1);
sum=0;
for i=1:M
    for j=1:N
        if c1(i,j)~=c2(i,j)
            sum=sum+1;
        end
    end
end
npcr=1/(M*N)*sum*100;
fprintf('NPCR  %25.24f\n',npcr);
