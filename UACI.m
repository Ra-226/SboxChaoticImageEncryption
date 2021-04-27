clc;clear;
%抗差分攻击能力分析
%对明文的敏感性越强，算法抵抗差分攻击的能力也就越强。
%可以用像素数改变率NPCR (Numberof Pixels Change Rate)指标度量加密算法对明文的敏感性；
%也可以用归一化像素值平均改变强度UACI (Unified Average Changing Intensity)指标度量敏感性。
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
