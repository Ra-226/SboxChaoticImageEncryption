%{
clc;
clear all;

[a,chuzhi1]=SBox(0.1000000000000181);
[b,chuzhi2]=SBox(0.1000000000000182);
%初值精度10^-16
if ~isequal(a,b)
    disp(reshape(a,16,16));
    disp(reshape(b,16,16));
end
figure1=figure(1);
%plot(a,'x-r');
h1=plot(a,'or');
set(figure1,'name','不同初值对比','Numbertitle','off');
hold on;
%plot(b,'+-b');
h2=plot(b,'+b');
title('S盒（256）点阵');
legend(sprintf('初始值x(1):%17.16f',chuzhi1),sprintf('初始值x(1):%17.16f',chuzhi2));
grid on; %命令用于生成网格

%}

%% 生成S盒
function [Z,k] = Sbox(k)

Y=0:1:255;
Z=[];   %空序列
x=zeros(1000000,1); %zeros功能是返回一个double类零矩阵，100000行1列用于多次迭代
u=3.9999;   %Logistic参数[3.5699456,4]
x(1)=k; %设定初始值，初始值不同，S盒生成不同
temp=length(Z)+2;
%中转，Z中已有Y中元素时，混沌序列继续向后迭代，防止原地踏步，u设置太小
%如3.99时，对256个小区间混沌序列生成精度不高，S盒生成不完全

while(length(Z)<256)
    %直至S盒256个元素填满
    x(temp)=u*x(temp-1)*(1-x(temp-1)); %一维logistic迭代映射混沌现象公式：x(i+1)=ax(i)(1-x(i))
    %x(temp)=(2/pi)*asin(sqrt(x(temp)));
    %disp(x(temp));
    for i=0:255
        %[0,1/256),(1/256,2/256)......(255/256,1]
        %256个区间每次迭代的混沌数值落入某一区间，取i值
        if x(temp)>i/256 && x(temp)<(i+1)/256
            %且Y[i]不在Z中时，Y[i]添加至Z末尾
            if ~ismember(Y(i+1),Z) && temp>256
                %去除前256个
                Z(length(Z)+1)=Y(i+1);
            end
            %Y[i]在Z中时，temp+1，向后执行
            if ismember(Y(i+1),Z) || temp<=256
                temp=temp+1;
            end
        end
    end
end
%Sbox=reshape(Z,16,16);  %生成S盒矩阵

end
