clc;clear;
%对密钥敏感性的测试
%MSE均方误差较低，加密质量较低
%用于解密的图片与原图片求均方差，愈大愈好，因算法故，对各图大多维持到了7735左右，个别8200左右，效果不好，没有别的密钥敏感性强
%致命缺点是128位密钥中C0和G0所在10位因混沌系统原因，密钥修改后解密能看到一点原图角落
c1=imread('peppers.png');
c2=imread('解密.png');
if numel(size(c1))>2
    c1=rgb2gray(c1);      %灰度处理
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
fprintf('MSE：  %25.24f\n',mse);
