clear;clc;
tic;%��ʱ
I=imread('mtest.png');         %��ȡͼ����Ϣ
h='37509f2eddd5fa526965615a3df6b61992d0c833ffd0ea7f2b22ad2027d5a1ddf6da77b96a98c08286a92bef9304949b9d70cfb212982b7c56d14877f97bb2c3';
K=[];
for i = 1:2:length(h)
    %K(ceil(i/2))=str2double(dec2bin(hex2dec(h(1,i:i+1)),8));
    K(ceil(i/2))=hex2dec(h(1,i:i+1));
    %ÿ����ʮ������ֵתʮ���ƣ�K����64
end

if numel(size(I))>2
    I=rgb2gray(I);      %�Ҷȴ���
end

[M,N]=size(I);  %��ͼ��С
SUM=M*N;
t=4;    %�ֿ��С
r=(M/t)*(N/t);      %rΪ�ֿ����

%% ���ɳ�ʼֵ

tianchong=sum(K(1,61:64))/(4*10^14);
%����ʼֵС���ĺ�12-16λ

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
% C0=(C0+tianchong*10^8)/2;
% G0=(G0+tianchong*10^8)/2;

%fprintf('��Կ x0: %18.17f \n,X0: %18.17f ,Y0: %18.17f ,Z0: %18.17f ,H0: %18.17f \n,C0: %18.17f ,G0: %18.17f\n',[x0,X0,Y0,Z0,H0,C0,G0]);

% x0=0.56523437499851747;
% X0=0.66777343749851747;
% Y0=0.69999999999851747;
% Z0=0.34589843749851751;
% H0=0.21992187499851748;
% C0=0.22148437499851750;
% G0=0.23691406249851749;


%% chen����
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

%% ����s��
xx=0.999999999999;
[a,chuzhi1]=Sbox(x0);
[b,chuzhi2]=Sbox(xx);

%% ��ɢ
e=N/t;  %e��ʾÿһ�п��Է�Ϊ���ٿ�

[X(1),Y(1),Z(1),H(1)]=paixu(P(1),X(1),Y(1),Z(1),H(1));
%��x,y,z,h��������
[Q(1:t,1:t),S]=tihuan(reshape(a,16,16),fenkuai(t,I,1),X(1),Y(1),Z(1),H(1));
%��1������ѡS��4*4Ԫ�����1���

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
    [Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t),S]=tihuan(reshape(a,16,16),fenkuai(t,I,i),X(i),Y(i),Z(i),H(i));
    %��i*������ѡS��4*4Ԫ�����i*���
    
    
    Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t)=kuosan(Q((xrow-1)*t+1:xrow*t,(ycol-1)*t+1:ycol*t),S,a,X(i),Y(i),Z(i),H(i));
end

%% logistic2���硢����

%II=Q;
tem=0;
[C,G]=logistic2(C0,G0,SUM);
c=reshape(C(1,1:4096),64,64);
g=reshape(G(1,1:4096),64,64);
C=reshape(C(1,1001:length(C)),M,N);
G=reshape(G(1,1001:length(G)),M,N);

for i=M:-1:1
    for j=N:-1:1
        ax=floor(C(i,j)*M)+1;
        by=floor(G(i,j)*N)+1;
        
        %ԭ-ֻ�����滻
%         temp=Q(i,by);
%         Q(i,by)=Q(ax,j);
%         Q(ax,j)=temp;

%         temp=Q(i,j);
%         Q(i,j)=Q(ax,by);
%         Q(ax,by)=temp;

        % 3.1 1��4���Ż�������������ͼƬ�ü������ڻָ�����ɢ�ԽϺã�lena��ֵ��4����0.0001
        %temp=255-bitxor(mod(by,255),Q(ax,by));%ͬ��
        %same=bitxor(mod(ax,255),Q(i,j));%���
        
        % 3.2 3.1�Ż�ʹ��S��
        temp=255-bitxor(a(1,mod(by,256)+1),Q(ax,by));%ͬ��
        same=bitxor(a(1,mod(ax,256)+1),Q(i,j));%���
        Q(ax,by)=same;
        Q(i,j)=temp;
        
        
        %��-ͬ��-�������滻
%         temp=255-bitxor(mod(by,255),Q(ax,j));%ͬ��
%         same=bitxor(mod(ax,255),Q(i,by));%���
%         Q(ax,j)=same;
%         Q(i,by)=temp;
        
%         if Q(i,by)<Q(ax,j)
%             Q(i,by)=Q(ax,j);
%             Q(ax,j)=Q(ax,j)-temp;
%         else
%             Q(i,by)=temp-Q(ax,j);
%             Q(ax,j)=temp;
%         end

    end
    %tem=tem+1;
end

% for i=64:-1:1
%     for j=64:-1:1
%         ax=floor(c(i,j)*M)+1;
%         by=floor(g(i,j)*N)+1;
% %         temp=Q(i,j);
% %         Q(i,j)=Q(ax,by);
% %         Q(ax,by)=temp;
%         
%         temp=255-bitxor(mod(by,255),Q(ax,by));%ͬ��
%         same=bitxor(mod(ax,255),Q(i,j));%���
%         Q(ax,by)=same;
%         Q(i,j)=temp;
%     end
% end

Q=uint8(Q);
imwrite(Q,'����.png');  
figure;imshow(Q);title('���ܺ�ͼƬ');
figure;imhist(Q);title('����ͼƬֱ��ͼ');
fprintf('��Ϣ�أ�%5.4f\n',entropy(Q));
