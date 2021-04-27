%{
clc;
clear all;

[a,chuzhi1]=SBox(0.1000000000000181);
[b,chuzhi2]=SBox(0.1000000000000182);
%��ֵ����10^-16
if ~isequal(a,b)
    disp(reshape(a,16,16));
    disp(reshape(b,16,16));
end
figure1=figure(1);
%plot(a,'x-r');
h1=plot(a,'or');
set(figure1,'name','��ͬ��ֵ�Ա�','Numbertitle','off');
hold on;
%plot(b,'+-b');
h2=plot(b,'+b');
title('S�У�256������');
legend(sprintf('��ʼֵx(1):%17.16f',chuzhi1),sprintf('��ʼֵx(1):%17.16f',chuzhi2));
grid on; %����������������

%}

%% ����S��
function [Z,k] = Sbox(k)

Y=0:1:255;
Z=[];   %������
x=zeros(1000000,1); %zeros�����Ƿ���һ��double�������100000��1�����ڶ�ε���
u=3.9999;   %Logistic����[3.5699456,4]
x(1)=k; %�趨��ʼֵ����ʼֵ��ͬ��S�����ɲ�ͬ
temp=length(Z)+2;
%��ת��Z������Y��Ԫ��ʱ���������м�������������ֹԭ��̤����u����̫С
%��3.99ʱ����256��С��������������ɾ��Ȳ��ߣ�S�����ɲ���ȫ

while(length(Z)<256)
    %ֱ��S��256��Ԫ������
    x(temp)=u*x(temp-1)*(1-x(temp-1)); %һάlogistic����ӳ���������ʽ��x(i+1)=ax(i)(1-x(i))
    %x(temp)=(2/pi)*asin(sqrt(x(temp)));
    %disp(x(temp));
    for i=0:255
        %[0,1/256),(1/256,2/256)......(255/256,1]
        %256������ÿ�ε����Ļ�����ֵ����ĳһ���䣬ȡiֵ
        if x(temp)>i/256 && x(temp)<(i+1)/256
            %��Y[i]����Z��ʱ��Y[i]�����Zĩβ
            if ~ismember(Y(i+1),Z) && temp>256
                %ȥ��ǰ256��
                Z(length(Z)+1)=Y(i+1);
            end
            %Y[i]��Z��ʱ��temp+1�����ִ��
            if ismember(Y(i+1),Z) || temp<=256
                temp=temp+1;
            end
        end
    end
end
%Sbox=reshape(Z,16,16);  %����S�о���

end
