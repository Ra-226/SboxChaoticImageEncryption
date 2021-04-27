%文献[7]
clc;clear;
c1=imread('lena512color.tiff');
c2=imread('mtest.png');
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
        %cha=cha^2;
        sum=sum+cha;

    end
end
mse=sum/(M*N);
fprintf('Encryption quality：  %25.24f\n',mse);