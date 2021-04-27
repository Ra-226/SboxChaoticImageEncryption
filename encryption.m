clear;clc;
tic;%��ʱ
I=imread('$LSF){($YQCX_Y1}PJUO}`8.png');         %��ȡͼ����Ϣ
h=hashSHA(I,'SHA-512');
K=[];
for i = 1:2:length(h)
    %K(ceil(i/2))=str2double(dec2bin(hex2dec(h(1,i:i+1)),8));
    K(ceil(i/2))=hex2dec(h(1,i:i+1));
    %ÿ����ʮ������ֵתʮ���ƣ�K����64
end


if numel(size(I))>2
    I=rgb2gray(I);      %�Ҷȴ���
end
[M,N]=size(I);                      %��ͼ������и�ֵ��M,N
t=4;    %�ֿ��С
%disp([M,N]);
%I=Arnold(I);

figure;imhist(I);title('����ͼ��ֱ��ͼ');

%% 1.����
%��ͼ��������������ɿ��Ա�t����������tΪ�ֿ�Ĵ�С��
M1=mod(M,t);
N1=mod(N,t);
if M1~=0
    I(M+1:M+t-M1,:)=0;
end
if N1~=0
    I(:,N+1:N+t-N1)=0;
end
[M,N]=size(I);  %����������������
SUM=M*N;
%disp([M,N]);
r=(M/t)*(N/t);      %rΪ�ֿ����
%disp(r);

%% 2.���ɳ�ʼֵ

tianchong=sum(K(1,61:64))/(4*10^14);
%disp(tianchong);
%����ʼֵС���ĺ�13-16λ,��������
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

%% 3.chen����
A=chen_output(X0,Y0,Z0,H0,r);   
X=A(:,1);
X=X(1502:length(X));        %ȥ��ǰ1501���ø��õ�����ԣ�������ϵͳ���Ӻ����������1500�㣩
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

%% 4.����s��
xx=0.999999999999;
[a,chuzhi1]=Sbox(x0);
%[a,chuzhi1]=Sbox((xx+x0)/2);
[b,chuzhi2]=Sbox(xx);
%��ֵ����10^-16
% if ~isequal(a,b)
%     disp(reshape(a,16,16));
%     disp(reshape(b,16,16));
% end
% figure1=figure(1);
% %plot(a,'x-r');
% h1=plot(a,'or');
% set(figure1,'name','��ͬ��ֵ�Ա�','Numbertitle','off');
% hold on;
% %plot(b,'+-b');
% h2=plot(b,'+b');
% title('S�У�256������');
% legend(sprintf('��ʼֵx(1):%17.16f',chuzhi1),sprintf('��ʼֵx(1):%17.16f',chuzhi2));
% grid on; %����������������




%% 5.logistic2���硢����

II=I;
%jilu=[0 0];%��ʼΪ���еľ���
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
%         temp=255-bitxor(mod(by,256),II(i,j));%ͬ��
%         same=bitxor(mod(ax,256),II(ax,by));%���
%         II(i,j)=same;
%         II(ax,by)=temp;
%     end
% end


for i=1:M
    for j=1:N
        ax=floor(C(i,j)*M)+1;
        by=floor(G(i,j)*N)+1;
        % 1.��ɢ�滻��2���Ż���ǰ�����㲻���У������滻���Գ�ֵ�����У����ڹ���
%         temp=II(i,by);
%         II(i,by)=II(ax,j);
%         II(ax,j)=temp;

        % 2.��ͨ���滻����άlogistic�ľ��ޣ�ĳЩ�������滻��ĳЩ�滻���
%         temp=II(i,j);
%         II(i,j)=II(ax,by);
%         II(ax,by)=temp;
        
        % 3.1 1��4���Ż�������������ͼƬ�ü������ڻָ�����ɢ�ԽϺã�lena��ֵ��4����0.0001
        %   1��2��3��4 MSEֵ��ͬС��Ĳ���
        %temp=255-bitxor(mod(by,256),II(i,j));%ͬ��
        %same=bitxor(mod(ax,256),II(ax,by));%���
        
        % 3.2 3.1�Ż�ʹ��S��
        temp=255-bitxor(a(1,mod(by,256)+1),II(i,j));%ͬ��
        same=bitxor(a(1,mod(ax,256)+1),II(ax,by));%���
        II(i,j)=same;
        II(ax,by)=temp;

        %4. 1��2���Ż�����ֵ�ߣ���2��ȱ�㣬����ǰ64*64���滻���ֲ�2ȱ�㣬�ü����ɢ����
%         temp=255-bitxor(mod(by,256),II(i,by));%ͬ��
%         same=bitxor(mod(ax,256),II(ax,j));%���
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
%             %ÿһ����Ϊһ��ʵ��,������0������ȫ1
%             jilu(tep,1)=ax;
%             jilu(tep,2)=by;
%             tep=tep+1;
%         end
    end
    %tem=tem-1;
end


%% 6.��ɢ
e=N/t;  %e��ʾÿһ�п��Է�Ϊ���ٿ�

[X(1),Y(1),Z(1),H(1)]=paixu(P(1),X(1),Y(1),Z(1),H(1));
%��x,y,z,h��������
[Q(1:t,1:t),S]=tihuan(reshape(a,16,16),fenkuai(t,II,1),X(1),Y(1),Z(1),H(1));
%��1������ѡS��4*4Ԫ�����1���

% num=ceil((X(1)+Y(1)+Z(1)+H(1))/4);
% num=dec2bin(num);
% num=str2num(num)*10^-4;
% num=sprintf('%5.4f',num);
% num=str2num(num(3:6));
% %numΪԭ��kuo��zhan��yunsuanʹ��

Q(1:t,1:t)=kuosan(Q(1:t,1:t),S,a,X(1),Y(1),Z(1),H(1));

for i=2:r
    
    xrow=floor(i/e)+1;
    ycol=mod(i,e);
    if ycol==0
        xrow=xrow-1;
        ycol=e;
    end
    [X(i),Y(i),Z(i),H(i)]=paixu(P(i),X(i),Y(i),Z(i),H(i));
    %��x,y,z,h��������
    [Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t),S]=tihuan(reshape(a,16,16),fenkuai(t,II,i),X(i),Y(i),Z(i),H(i));
    %��i*������ѡS��4*4Ԫ�����i*���
    
%     num=ceil((X(i)+Y(i)+Z(i)+H(i))/4);
%     num=dec2bin(num);
%     num=str2num(num)*10^-4;
%     num=sprintf('%5.4f',num);
%     num=str2num(num(3:6));
    
    Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t)=kuosan(Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t),S,a,X(i),Y(i),Z(i),H(i));
end

Q=uint8(Q);

imwrite(Q,'mtest.png');  
figure;imshow(Q);title('���ܺ�ͼ��');
figure;imhist(Q);title('����ͼ��ֱ��ͼ');

time=toc;   %��ʱ

disp('��Կ:');
fprintf('x0=%18.17f\n',x0);
fprintf('X0=%18.17f\n',X0);
fprintf('Y0=%18.17f\n',Y0);
fprintf('Z0=%18.17f\n',Z0);
fprintf('H0=%18.17f\n',H0);
fprintf('C0=%18.17f\n',C0);
fprintf('G0=%18.17f\n',G0);

fprintf('��ʱ��%f s\n',time);
fprintf('��Կ��%s\n',h);


%% 7.��Ϣ��
fprintf('ԭͼ��Ϣ�أ�%5.4f\n',entropy(I));

fprintf('����ͼ��Ϣ�أ�%5.4f\n',entropy(Q));

%% �ֲ���Ϣ��

tem=1;
for i=1:10
    for j=1:3
        fv=Q(44*(i-1)+1:44*i,44*(j-1)+1:44*j);
        
        en(tem)=entropy(fv);
        tem=tem+1;
    end
end

fprintf('��ͼ�ֲ���Ϣ�أ�%5.4f\n',sum(en)/30);

%% 8.���ϵ��
n=5000;



[ r_xy_I, X_I, Y_I ] = r_xy_near( I, n, 'Up' );
figure,  subplot(1,2,1),scatter( X_I, Y_I,25,'.');  
%title(['����ͼ��', num2str(n), '���������صĻҶ�ֵ�ֲ�']);
xlabel({'(x,y)������ֵ';'(c) ���Ĵ�ֱ'});  ylabel('(x,y)����������ֵ');
%ax = gca;ax.FontSize = 12;
set(gcf,'Position',[100 100 512 246]);%��������û�ͼ�Ĵ�С������Ҫ��word���ٵ�����С
%set(ax,'position',[0.1,0.1,0.9,0.9]);
disp(['����ͼ�����ȡ', num2str(n), '���������ؼ�������ϵ��: ', num2str(r_xy_I)]);


[ r_xy_C, X_C, Y_C ] = r_xy_near( Q, n, 'Up' );
subplot(1,2,2),scatter( X_C, Y_C, 25 ,'.','r');  
%title(['����ͼ��', num2str(n), '���������صĻҶ�ֵ�ֲ�']);
xlabel({'(x,y)������ֵ';'(d) ���Ĵ�ֱ'});  ylabel('(x,y)����������ֵ');
%bx = gca;bx.FontSize = 12;
set(gcf,'Position',[100 100 556 246]);%��������û�ͼ�Ĵ�С������Ҫ��word���ٵ�����С
disp(['����ͼ�����ȡ', num2str(n), '���������ؼ�������ϵ��: ', num2str(r_xy_C)]);
