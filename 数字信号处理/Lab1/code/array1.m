% 实指数序列 （0.5)^n
clc;
clear;
%% 生成序列
a = 0.5;length = 10;
n = [0:length-1];       
x_n = a.^n;             %序列 x(n)
x_w = fft(x_n, length); %序列进行FFT变换
%% 序列的实部、虚部、模、相角
figure(1);
subplot(4,1,1);stem([0:length-1],real(x_n),'filled');
title("实部");xlabel("n");ylabel("Re\{x(n)\}");

subplot(4,1,2);stem([0:length-1],imag(x_n),'filled');
title("虚部");xlabel("n");ylabel("Im\{x(n)\}");

subplot(4,1,3);stem([0:length-1],abs(x_n),'filled');
title("模");xlabel("n");ylabel("|x(n)|");

subplot(4,1,4);stem([0:length-1],angle(x_n),'filled');
title("相角");xlabel("n");ylabel("\Phi");
%% 序列经DFT变换后的幅度谱、频谱实部、虚部
figure(2);
subplot(3,1,1);stem([0:length-1],abs(x_w),'filled');
title("幅度谱");xlabel('k');ylabel('|x(k)|');

subplot(3,1,2);stem([0:length-1],real(x_w),'filled');
title("频谱实部");xlabel('k');ylabel('Re\{x(k)\}');

subplot(3,1,3);stem([0:length-1],imag(x_w),'filled');
title("频谱虚部");xlabel('k');ylabel('Im\{x(k)\}');
