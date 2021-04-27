clear;clc;
tic;%计时
I=imread('$LSF){($YQCX_Y1}PJUO}`8.png');         %读取图像信息
h=hashSHA(I,'SHA-512');
K=[];
for i = 1:2:length(h)
    %K(ceil(i/2))=str2double(dec2bin(hex2dec(h(1,i:i+1)),8));
    K(ceil(i/2))=hex2dec(h(1,i:i+1));
    %每两个十六进制值转十进制，K长度64
end


if numel(size(I))>2
    I=rgb2gray(I);      %灰度处理
end
[M,N]=size(I);                      %将图像的行列赋值给M,N
t=4;    %分块大小
%disp([M,N]);
%I=Arnold(I);

figure;imhist(I);title('明文图像直方图');

%% 1.补零
%将图像的行列数都补成可以被t整除的数，t为分块的大小。
M1=mod(M,t);
N1=mod(N,t);
if M1~=0
    I(M+1:M+t-M1,:)=0;
end
if N1~=0
    I(:,N+1:N+t-N1)=0;
end
[M,N]=size(I);  %补零后的行数和列数
SUM=M*N;
%disp([M,N]);
r=(M/t)*(N/t);      %r为分块个数
%disp(r);

%% 2.生成初始值

tianchong=sum(K(1,61:64))/(4*10^14);
%disp(tianchong);
%填充初始值小数的后13-16位,干扰因子
x0=key(K,1,10,sum(K(1,1:10))/10);
X0=key(K,11,20,sum(K(1,11:20))/10);
Y0=key(K,21,30,sum(K(1,21:30))/10);
Z0=key(K,31,40,sum(K(1,31:40))/10);
H0=key(K,41,50,sum(K(1,41:50))/10);
C0=key(K,51,55,sum(K(1,51:55))/10);
G0=key(K,56,60,sum(K(1,56:60))/10);

x0=x0-tianchong;
X0=X0-tianchong;
Y0=Y0-tianchong;
Z0=Z0-tianchong;
H0=H0-tianchong;
C0=C0-tianchong;
G0=G0-tianchong;
%disp([x0,X0,Y0,Z0,H0,C0,G0]);

% C0=(C0+tianchong*10^8)/2;
% G0=(G0+tianchong*10^8)/2;

%% 3.chen混沌
A=chen_output(X0,Y0,Z0,H0,r);   
X=A(:,1);
X=X(1502:length(X));        %去除前1501项，获得更好的随机性（求解陈氏系统的子函数多计算了1500点）
Y=A(:,2);
Y=Y(1502:length(Y));
Z=A(:,3);
Z=Z(1502:length(Z));
H=A(:,4);
H=H(1502:length(H));
P=(X+Y+Z+H)/4;
P=floor(P*10^4);
X=mod(floor(X*10^4),16)+1;
Y=mod(floor(Y*10^4),16)+1;
Z=mod(floor(Z*10^4),16)+1;
H=mod(floor(H*10^4),16)+1;
%disp(X);

%% 4.生成s盒
xx=0.999999999999;
[a,chuzhi1]=Sbox(x0);
%[a,chuzhi1]=Sbox((xx+x0)/2);
[b,chuzhi2]=Sbox(xx);
%初值精度10^-16
% if ~isequal(a,b)
%     disp(reshape(a,16,16));
%     disp(reshape(b,16,16));
% end
% figure1=figure(1);
% %plot(a,'x-r');
% h1=plot(a,'or');
% set(figure1,'name','不同初值对比','Numbertitle','off');
% hold on;
% %plot(b,'+-b');
% h2=plot(b,'+b');
% title('S盒（256）点阵');
% legend(sprintf('初始值x(1):%17.16f',chuzhi1),sprintf('初始值x(1):%17.16f',chuzhi2));
% grid on; %命令用于生成网格




%% 5.logistic2混沌、置乱

II=I;
%jilu=[0 0];%初始为两列的矩阵
temp=1;
%tep=1;
[C,G]=logistic2(C0,G0,SUM);
%figure;scatter(C,G,'o');
c=reshape(C(1,1:4096),64,64);
g=reshape(G(1,1:4096),64,64);
C=reshape(C(1,1001:length(C)),M,N);
G=reshape(G(1,1001:length(G)),M,N);

% for i=1:64
%     for j=1:64
%         ax=floor(c(i,j)*M)+1;
%         by=floor(g(i,j)*N)+1;
% %         temp=II(i,j);
% %         II(i,j)=II(ax,by);
% %         II(ax,by)=temp;
%         
%         temp=255-bitxor(mod(by,256),II(i,j));%同或
%         same=bitxor(mod(ax,256),II(ax,by));%异或
%         II(i,j)=same;
%         II(ax,by)=temp;
%     end
% end


for i=1:M
    for j=1:N
        ax=floor(C(i,j)*M)+1;
        by=floor(G(i,j)*N)+1;
        % 1.分散替换，2的优化，前几个点不命中，永不替换，对初值不敏感，易于攻破
%         temp=II(i,by);
%         II(i,by)=II(ax,j);
%         II(ax,j)=temp;

        % 2.普通的替换，二维logistic的局限，某些点永不替换，某些替换多次
%         temp=II(i,j);
%         II(i,j)=II(ax,by);
%         II(ax,by)=temp;
        
        % 3.1 1、4的优化，对于文字型图片裁剪后易于恢复，分散性较好，lena熵值较4降低0.0001
        %   1、2、3、4 MSE值大同小异的不高
        %temp=255-bitxor(mod(by,256),II(i,j));%同或
        %same=bitxor(mod(ax,256),II(ax,by));%异或
        
        % 3.2 3.1优化使用S盒
        temp=255-bitxor(a(1,mod(by,256)+1),II(i,j));%同或
        same=bitxor(a(1,mod(ax,256)+1),II(ax,by));%异或
        II(i,j)=same;
        II(ax,by)=temp;

        %4. 1、2的优化，熵值高，有2的缺点，搭配前64*64块替换，弥补2缺点，裁剪后分散性弱
%         temp=255-bitxor(mod(by,256),II(i,by));%同或
%         same=bitxor(mod(ax,256),II(ax,j));%异或
%         II(i,by)=same;
%         II(ax,j)=temp;
        
%         if II(i,by)<II(ax,j)
%             II(i,by)=II(ax,j);
%             II(ax,j)=II(ax,j)-temp;
%         else
%             II(i,by)=temp-II(ax,j);
%             II(ax,j)=temp;
%         end

%         if ~ismember(0,~ismember(jilu,[ax,by],'rows'))
%             %每一行视为一个实体,有则有0，无则全1
%             jilu(tep,1)=ax;
%             jilu(tep,2)=by;
%             tep=tep+1;
%         end
    end
    %tem=tem-1;
end


%% 6.扩散
e=N/t;  %e表示每一行可以分为多少块

[X(1),Y(1),Z(1),H(1)]=paixu(P(1),X(1),Y(1),Z(1),H(1));
%对x,y,z,h进行排序
[Q(1:t,1:t),S]=tihuan(reshape(a,16,16),fenkuai(t,II,1),X(1),Y(1),Z(1),H(1));
%块1经过挑选S盒4*4元素与块1异或

% num=ceil((X(1)+Y(1)+Z(1)+H(1))/4);
% num=dec2bin(num);
% num=str2num(num)*10^-4;
% num=sprintf('%5.4f',num);
% num=str2num(num(3:6));
% %num为原先kuo、zhan、yunsuan使用

Q(1:t,1:t)=kuosan(Q(1:t,1:t),S,a,X(1),Y(1),Z(1),H(1));

for i=2:r
    
    xrow=floor(i/e)+1;
    ycol=mod(i,e);
    if ycol==0
        xrow=xrow-1;
        ycol=e;
    end
    [X(i),Y(i),Z(i),H(i)]=paixu(P(i),X(i),Y(i),Z(i),H(i));
    %对x,y,z,h进行排序
    [Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t),S]=tihuan(reshape(a,16,16),fenkuai(t,II,i),X(i),Y(i),Z(i),H(i));
    %块i*经过挑选S盒4*4元素与块i*异或
    
%     num=ceil((X(i)+Y(i)+Z(i)+H(i))/4);
%     num=dec2bin(num);
%     num=str2num(num)*10^-4;
%     num=sprintf('%5.4f',num);
%     num=str2num(num(3:6));
    
    Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t)=kuosan(Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t),S,a,X(i),Y(i),Z(i),H(i));
end

Q=uint8(Q);

imwrite(Q,'mtest.png');  
figure;imshow(Q);title('加密后图像');
figure;imhist(Q);title('加密图像直方图');

time=toc;   %计时

disp('密钥:');
fprintf('x0=%18.17f\n',x0);
fprintf('X0=%18.17f\n',X0);
fprintf('Y0=%18.17f\n',Y0);
fprintf('Z0=%18.17f\n',Z0);
fprintf('H0=%18.17f\n',H0);
fprintf('C0=%18.17f\n',C0);
fprintf('G0=%18.17f\n',G0);

fprintf('用时：%f s\n',time);
fprintf('密钥：%s\n',h);


%% 7.信息熵
fprintf('原图信息熵：%5.4f\n',entropy(I));

fprintf('加密图信息熵：%5.4f\n',entropy(Q));

%% 局部信息熵

tem=1;
for i=1:10
    for j=1:3
        fv=Q(44*(i-1)+1:44*i,44*(j-1)+1:44*j);
        
        en(tem)=entropy(fv);
        tem=tem+1;
    end
end

fprintf('密图局部信息熵：%5.4f\n',sum(en)/30);

%% 8.相关系数
n=5000;



[ r_xy_I, X_I, Y_I ] = r_xy_near( I, n, 'Up' );
figure,  subplot(1,2,1),scatter( X_I, Y_I,25,'.');  
%title(['明文图像', num2str(n), '对相邻像素的灰度值分布']);
xlabel({'(x,y)的像素值';'(c) 明文垂直'});  ylabel('(x,y)的相邻像素值');
%ax = gca;ax.FontSize = 12;
set(gcf,'Position',[100 100 512 246]);%这句是设置绘图的大小，不需要到word里再调整大小
%set(ax,'position',[0.1,0.1,0.9,0.9]);
disp(['明文图像随机取', num2str(n), '对相邻像素计算得相关系数: ', num2str(r_xy_I)]);


[ r_xy_C, X_C, Y_C ] = r_xy_near( Q, n, 'Up' );
subplot(1,2,2),scatter( X_C, Y_C, 25 ,'.','r');  
%title(['密文图像', num2str(n), '对相邻像素的灰度值分布']);
xlabel({'(x,y)的像素值';'(d) 密文垂直'});  ylabel('(x,y)的相邻像素值');
%bx = gca;bx.FontSize = 12;
set(gcf,'Position',[100 100 556 246]);%这句是设置绘图的大小，不需要到word里再调整大小
disp(['密文图像随机取', num2str(n), '对相邻像素计算得相关系数: ', num2str(r_xy_C)]);
