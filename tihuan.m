function [fv,fy]=tihuan(Sbox,array,X,Y,Z,H)
fy=array;   %原4*4块矩阵，替换成s盒生成矩阵
fv=array;   %原4*4块矩阵，与s盒生成矩阵先替换后异或
%{
[
    XX XY XZ XH
    YX YY YZ YH
    ZX ZY ZZ ZH
    HX HY HZ HH
]
%}
t=[X Y Z H;X Y Z H;X Y Z H;X Y Z H;];
% [
%     X Y Z H
%     X Y Z H
%     X Y Z H
%     X Y Z H
% ]

for i=1:length(array(1,:))
    for j=1:length(array(:,1))
        %在s盒中选择替换值赋给fy
        fy(i,j)=Sbox(t(i,i),t(i,j));
        %选择的4*4各个异或像素
        %fy(i,j)=mod(fy(i,j)*fv(i,j),256)+1;
        fv(i,j)=bitxor(fv(i,j),fy(i,j));
         %yi=mod(Sbox(t(i,i),t(i,j)),8);
%         bin=dec2bin(fv(i,j));
%         bin=circshift(bin,[0,-4]);
%         fv(i,j)=bin2dec(bin);
    end
end

end