function [fv,fy]=tihuan(Sbox,array,X,Y,Z,H)
fy=array;   %ԭ4*4������滻��s�����ɾ���
fv=array;   %ԭ4*4�������s�����ɾ������滻�����
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
        %��s����ѡ���滻ֵ����fy
        fy(i,j)=Sbox(t(i,i),t(i,j));
        %ѡ���4*4�����������
        %fy(i,j)=mod(fy(i,j)*fv(i,j),256)+1;
        fv(i,j)=bitxor(fv(i,j),fy(i,j));
         %yi=mod(Sbox(t(i,i),t(i,j)),8);
%         bin=dec2bin(fv(i,j));
%         bin=circshift(bin,[0,-4]);
%         fv(i,j)=bin2dec(bin);
    end
end

end