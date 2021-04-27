function [ r_xy, X, Y ] = r_xy_near( I, n, direction )
% ����˵��
% I -- �����ͼ��ҶȾ���
% n -- ��I�а���һ��Ҫ�������ȡ�����ص�ĸ���
% direction -- ��directionָ�������������Ϊ��������
%              Left: ˮƽ���������
%              Right: ˮƽ���ҵ�����
%              Down: ��ֱ���µ�����
%              Up; ��ֱ���ϵ�����
%              Left_Up: �Խ������Ͻǵ�����
%              Left_Down: �Խ������½ǵ�����
%              Right_Up: �Խ������Ͻǵ�����
%              Right_Down: �Խ������½ǵ�����
% r_xy -- ���ռ���õ�����������Ϊn������X��Y֮������ϵ��
% X -- �����ȡ�����ص�ĻҶ�ֵ��������
% Y -- �����ȡ�����ص�����ڵ�ĻҶ�ֵ��������

I = double(I);
[H, W] = size(I);

% ����direction����ȷ�����ȡ����ĺ������귶Χ
switch direction
    case 'Left'
        R = floor( unifrnd(1, H, [1, n]) );
        C = floor( unifrnd(2, W, [1, n]) );
        delta_r = 0; delta_c = -1;
    case 'Right'
        R = floor( unifrnd(1, H, [1, n]) );
        C = floor( unifrnd(1, W-1, [1, n]) );
        delta_r = 0; delta_c = 1;
    case 'Up'
        R = floor( unifrnd(2, H, [1, n]) );
        C = floor( unifrnd(1, W, [1, n]) );
        delta_r = -1; delta_c = 0;
    case 'Down'
        R = floor( unifrnd(1, H-1, [1, n]) );
        C = floor( unifrnd(1, W, [1, n]) );
        delta_r = 1; delta_c = 0;
    case 'Left_Up'
        R = floor( unifrnd(2, H, [1, n]) );
        C = floor( unifrnd(2, W, [1, n]) );
        delta_r = -1; delta_c = -1;
    case 'Left_Down'
        R = floor( unifrnd(1, H-1, [1, n]) );
        C = floor( unifrnd(2, W, [1, n]) );
        delta_r = 1; delta_c = -1;
    case 'Right_Up'
        R = floor( unifrnd(2, H, [1, n]) );
        C = floor( unifrnd(1, W-1, [1, n]) );
        delta_r = -1; delta_c = 1;
    case 'Right_Down'
        R = floor( unifrnd(1, H-1, [1, n]) );
        C = floor( unifrnd(1, W-1, [1, n]) );
        delta_r = 1; delta_c = 1;
end

X = []; Y = [];  % ��ʼ�����ȡ���㴦�ĻҶ�ֵ����
for i = 1 : n
    X(i) = I( R(i), C(i) );
    Y(i) = I( R(i) + delta_r, C(i) + delta_c );
end

% ��������X������Y�����ϵ��
mx = mean(X); my = mean(Y);
cov_xy = mean( (X - mx) .* (Y - my) );
cov_x = mean( (X - mx) .* (X - mx) );
cov_y = mean( (Y - my) .* (Y - my) );
r_xy = cov_xy / sqrt( cov_x * cov_y );

end
