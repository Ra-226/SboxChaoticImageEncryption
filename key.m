function x0=key(K,shi,wei,av)
%KΪ�����������У�shi�����г�ʼλ�ã�wei��ĩβλ�ã�av��sum(wei-shi)ƽ��ֵ
x0=K(shi);
for i=shi+1:wei
    
    x0=bitxor(K(i),x0);
end
x0=(x0+av)/512;
%��ȡС��1��С�� 512=2*256