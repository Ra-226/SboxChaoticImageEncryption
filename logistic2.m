function [x,y]=logistic2(x0,y0,n)
%��άlogistic���磬0.815<��<0.89����=0.1
x=[];
y=[];
u1=0.9;
u2=0.9;
r=0.1;
x(1)=x0; %�趨��ʼֵ
y(1)=y0;
for i=2:1000+n
x(i)=4*u1*x(i-1)*(1-x(i-1))+r*y(i-1); %һ���������ʽ�Ķ�άLogistic ӳ��
y(i)=4*u2*y(i-1)*(1-y(i-1))+r*x(i-1); % x(n+1)=4*u*x(n)*(1-x(n))+r*y(n)---y(n+1)=4*u*y(n)*(1-y(n))+r*x(n)
end
% figure(1);
% plot(x,'xr');
% hold on;
% plot(y,'+b');
end