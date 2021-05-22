clear;
close all;
clc;

%% 程序开始，写入数据
AW = readmatrix('alltime_american.csv');                                   %将alltime_american数据读入AW中
m = AW(:,1);                                                               %序号
n = length(m);                                                             %样本个数
date = AW(:,2);                                                            %日期
total_confirm = AW(:,3);                                                   %总确诊
total_dead = AW(:,6);                                                      %总死亡
total_heal = AW(:,5);                                                      %总治愈
today_confirm = AW(:,9);                                                   %今日确诊
today_heal = AW(:,11);                                                     %今日治愈
today_dead = AW(:,12);                                                     %今日死亡

%% 生成矩阵G

h = input( '请输入多项式阶数：');                                           %用户输入设置阶数
%h = 3;
N = h+1;
G = [,];                                                                   %创建空G矩阵

for j = 1:N
    for i = 1:n
        G(i,j) = m(i).^(j-1);                                              %创建G矩阵
    end
end

G = [G,total_confirm];                                                     %将confirm的值添加到G的最后一列

%% 形成矩阵Q
w = zeros(1,n);
sigma = 0;                                                                 %设置中间变量
a = zeros(1,n);

for k = 1:N    
    sigma = -sign(G(k,k))*sqrt(sum(G(k:n,k).^2));                          %计算sigma
    w(k) = G(k,k)-sigma;
    
    for j = k+1:n
        w(j) = G(j,k);
    end
    
    B = sigma * w(k);                                                      %beta
    
    % 变换G(k-1)到G(k)
    
    G(k,k) = sigma;
    b = 0;
    
    for j = k+1:N+1
        
%         for i = k:n
%             b = b + w(i) * G(i,j);
%         end
%         t = b/B;
        t = sum(w(k:n)*G(k:n,j))/B;
        for i = k:n
            G(i,j) = G(i,j) + t*w(i);
        end
        
    end
    
end

%% 解三角方程
% c = 0;                                                                     
x(N) = G(N,N+1)/G(N,N);
for i = N-1:-1:1
%     for j = i+1:N
%         c = c +G(i,j).*x(j);
%     end
%     
%     x(i) = (G(i,N+1)-c)/G(i,i);
    x(i) = (G(i,N+1)-sum(G(i,i+1:N).*x(i+1:N)))/G(i,i);
end

%% 计算误差
P = sum(G(N+1:n,N+1).^2);
% P = 0;
% 
% for i = N+1:n
%     P = P+G(i,N+1)^2;
% end
% disp('误差为：');
% disp(P);
%% 计算最终最小二乘近似多项式
L = length(x);
Y = 0;

for i = 1:L
    Y = Y+x(i) * m.^(i-1);                                                 %利用循环写出h阶多项式
end

figure;
plot(m,total_confirm,'.g');                                                %绘出数据点，用绿色“.”表示
hold on;
plot(m,Y,'b');                                                             %绘出最小二乘法二次多项式用蓝线表示

xlabel('日期','fontsize',14);
ylabel('确诊人数','fontsize',14);
title('美国新冠疫情感染趋势','fontsize',14);
grid on;
dateaxis('x',1,'Jan.28');

%% 预测2021
X = 1:365;
Y1 = 0;

for i = 1:L
    Y1 = Y1+x(i) * X.^(i-1);                                               %利用循环写出h阶多项式
end

disp('2021年1月1日预计确诊人数为（2021.1.1约为图表第314个数据）:');
disp(Y1(314));

figure;
plot(m,total_confirm,'.g');                                                %绘出数据点，用绿色“.”表示
hold on;
plot(X,Y1,'r');                                                            %将预测曲线用红线表示

xlabel('日期','fontsize',14);
ylabel('确诊人数','fontsize',14);
title('美国新冠疫情感染趋势(含预测）','fontsize',14);
grid on;
dateaxis('x',1,'Jan.28');
