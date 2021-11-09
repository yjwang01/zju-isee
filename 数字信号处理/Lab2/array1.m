% f = 50Hz,T = 0.000625s,N = 32
clear;clc;
%% 参数设定
f = 50; T = 0.000625; N = 32;
%% 生成序列
n = [0:N-1];
t = [0:T/100:T*N];
x_t = sin(2*pi*f*t);
x_n = sin(2*pi*f*T*n);
X_k = fft(x_n,N);
%% 绘图
% 时域
figure(1);
subplot(2,1,1);
plot(t,x_t);
title('原始序列');xlabel('t(s)');ylabel('x(t)');
axis([0 T*N -1 1]);
subplot(2,1,2);
stem(n,x_n,'filled');
axis([0 N -1 1]);
title('抽样序列(时域)');xlabel('n');ylabel('x(n)');

figure(2);
% 幅度谱
delta_f = 1/(N*T);              %频谱分辨率
k = [0:delta_f:delta_f*(N-1)];
subplot(3,1,1);
stem(k,abs(X_k),'filled');
title('幅度谱');xlabel('k(Hz)');ylabel('X(k)');
% 频谱实部
subplot(3,1,2);
stem(k,real(X_k),'filled');
title('频谱实部');xlabel('k(Hz)');ylabel('Re\{X(k)\}');
% 频谱虚部
subplot(3,1,3);
stem(k,imag(X_k),'filled');
title('频谱虚部');xlabel('k(Hz)');ylabel('Im\{X(k)\}');
