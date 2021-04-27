%% �ϸ�ѩ��׼�� Strict Avalanche Criterion�� SAC����ѩ��ЧӦ����ʽ����
%��ָ�������κ�һ������λ����תʱ������е�ÿһλ����50%�ĸ��ʷ����仯��
%�ϸ�ѩ��׼����������ѧ����ȫ�Ը����ϣ���Webster��Tavares��1985�������
clc;clear;
% [a,chuzhi1]=Sbox(0.1000000000000181);
% [b,chuzhi2]=Sbox(0.1000000000000180);

% [a,chuzhi1]=Sbox(0.2000000000000000);
% [b,chuzhi2]=Sbox(0.2000000000000001);
s=[];
temp=2;
t=1;
ra=rand(25,1);
for i=1:25
    for j=temp:25
        [a,chuzhi1]=Sbox(ra(i,1));
        [b,chuzhi2]=Sbox(ra(j,1));
        s(t)=sac(a,b);
        t=t+1;
        
    end
    temp=temp+1;
end
figure;
plot([1,300],[0.5,0.5],'r-');
hold on;
plot(s);
axis([1 300 0.46 0.54]);
xlabel('SAC��������');  ylabel('SACֵ');
title('SAC����');

text(1,0.535,sprintf('MAX:%5.4f  MIN:%5.4f  AVERAGE:%5.4f',max(s),min(s),sum(s)/length(s)))



function av=sac(a,b)
a=dec2bin(a);
b=dec2bin(b);

sum=0;

for i=1:length(a(:,1))
    for j=1:length(a(1,:))
        if a(i,j)~=b(i,j)
            sum=sum+1;
        end
    end
end
av=sum/(length(a(:,1))*length(a(1,:)));
%fprintf('ռ�ȣ�%f\n',av);
end