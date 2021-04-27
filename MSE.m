clc;clear;
%����Կ�����ԵĲ���
%MSE�������ϵͣ����������ϵ�
%���ڽ��ܵ�ͼƬ��ԭͼƬ�������������ã����㷨�ʣ��Ը�ͼ���ά�ֵ���7735���ң�����8200���ң�Ч�����ã�û�б����Կ������ǿ
%����ȱ����128λ��Կ��C0��G0����10λ�����ϵͳԭ����Կ�޸ĺ�����ܿ���һ��ԭͼ����
c1=imread('peppers.png');
c2=imread('����.png');
if numel(size(c1))>2
    c1=rgb2gray(c1);      %�Ҷȴ���
end
[M,N]=size(c1);

sum=0;

for i=1:M
    for j=1:N
        cha=(double(c2(i,j))-double(c1(i,j)));
        if cha<0
            cha=-cha;
        end
        cha=cha^2;
        sum=sum+cha;

    end
end
mse=sum/(M*N);
fprintf('MSE��  %25.24f\n',mse);
