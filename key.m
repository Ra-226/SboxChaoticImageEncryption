function x0=key(K,shi,wei,av)
%K为待分区的序列，shi是序列初始位置，wei是末尾位置，av是sum(wei-shi)平均值
x0=K(shi);
for i=shi+1:wei
    
    x0=bitxor(K(i),x0);
end
x0=(x0+av)/512;
%获取小于1的小数 512=2*256