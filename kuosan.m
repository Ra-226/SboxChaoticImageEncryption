function fv=kuosan(kuai,t,S,x,y,z,h)

k1=mod(x*y,256)+1;
k2=mod(z*h,256)+1;
k3=mod(x*z,256)+1;
k4=mod(x*h,256)+1;
k5=mod(y*z,256)+1;
k6=mod(y*h,256)+1;
k7=mod(x*y*z,256)+1;
k8=mod(x*y*h,256)+1;
k9=mod(x*z*h,256)+1;
k10=mod(y*z*h,256)+1;
k11=mod(x*y*z*h,256)+1;
k12=mod(x*x,256)+1;
k13=mod(y*y,256)+1;
k14=mod(z*z,256)+1;
k15=mod(h*h,256)+1;
k16=mod(sum(t(:)),256);
%kp=mod(floor(sqrt(x*y*z*h)),256)+1;

%% 法1、法2各有特色，择一

%% 法1.用以下公式迭代fv
%fv=kuai     fv(i+1)=fv(i)?{mod(S(k[i])*S(k[j]),256)},i=1,2,...,14   j=2,3,...,15
% k=[k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15];
% fv=bitxor(mod(S(1,k(1,1))*S(1,k(1,1)),256),kuai);
% temp=2;
% for i=1:length(k(1,:))
%     for j=temp:length(k(1,:))
%         fv=bitxor(fv,mod(S(1,k(1,i))*S(1,k(1,j)),256));
%         %根据k在S盒中随机选择迭代异或
%         temp=temp+1;
%     end
% end

%% 法2.仅使用排序的x，y，z，h生成的k1、k2选择S盒
fv=bitxor(mod(S(1,k1)*S(1,k2),256),kuai);

% fv=bitxor(fv,mod(S(1,k3)*S(1,k4),256));
% fv=bitxor(fv,mod(S(1,k5)*S(1,k6),256));
% fv=bitxor(fv,mod(S(1,k1)*S(1,k3),256));
% fv=bitxor(fv,mod(S(1,k1)*S(1,k4),256));
% fv=bitxor(fv,mod(S(1,k1)*S(1,k5),256));
% fv=bitxor(fv,mod(S(1,k1)*S(1,k6),256));
% fv=bitxor(fv,mod(S(1,k2)*S(1,k3),256));

%fv=bitxor(kuai,k16);
fv=bitxor(fv,k16);
%与4*4替换盒之和异或
% yix=mod(S(1,k3),4);
% yiy=mod(S(1,k4),4);
% fv=circshift(fv,[2,2]);
