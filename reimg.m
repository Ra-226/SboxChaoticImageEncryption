clc;
clear;
%用于裁剪密图，检验健壮性
I=imread('test.png'); 
[m,n]=size(I);
%Q(1:256,1:256)=I(1:256,1:256);
for i=1:m
    for j=1:n/2
        I(i,j)=0;
        
    end
end
%I(1:256,1:256)=Q(1:256,1:256);
imwrite(I,'test.png');  
figure;imshow(I);title('加密后图片');