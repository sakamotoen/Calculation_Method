clear;
close;
clc;

%% 程序开始，写入数据
AW = csvread('alltime_world.csv',1,0);                                     %将alltime_world数据读入AW中
m = AW(:,1);                                                               %序号
n = length(m);
date = AW(:,2);                                                            %日期
confirm = AW(:,3);                                                         %总确诊
dead = AW(:,4);                                                            %总死亡
heal = AW(:,5);                                                            %总存活
newAC = AW(:,6);                                                           %新增确诊
dr = AW(:,7);                                                              %死亡率
hr = AW(:,8);                                                              %存活率

%% 使用最小二乘近似
h = input('请输入多项式阶数：');
p = polyfit(m,confirm,h);                                                  %最小二乘法一次多项式
L = length(p);                                                             %取系数矩阵长度
y = 0;

for i = 1:L
    y = y+p(i) * m.^(L-i);                                                 %列出最终多项式
end

figure;
plot(m,confirm,'.g');                                                      %绘出数据点，用绿色“.”表示
hold on;
plot(m,y,'r');                                                             %绘出最小二乘法多项式用红线表示
xlabel('日期','fontsize',14);
ylabel('确诊人数','fontsize',14);
title('世界新冠疫情感染趋势','fontsize',14);
grid on;
dateaxis('x',1,'Jan.28');

% p2 = polyfit(m,confirm,2);                                                 %最小二乘法二次多项式
% y2 = p2(1)*m.^2+p2(2)*m+p2(3);
% figure;
% plot(m,confirm,'.g');                                                      %绘出数据点，用绿色“.”表示
% hold on;
% plot(m,y2,'b');                                                            %绘出最小二乘法二次多项式用蓝线表示
% xlabel('日期','fontsize',14);
% ylabel('确诊人数','fontsize',14);
% title('世界新冠疫情感染趋势','fontsize',14);
% grid on;
% dateaxis('x',1,'Jan.28');
% 
% p3 = polyfit(m,confirm,3);                                                 %最小二乘法三次多项式
% y3 = p3(1)*m.^3+p3(2)*m.^2+p3(3)*m+p3(4);
% figure;
% plot(m,confirm,'.g');                                                      %绘出数据点，用绿色“.”表示
% hold on;
% plot(m,y3,'k');                                                            %绘出最小二乘法三次多项式用黑线表示
% xlabel('日期','fontsize',14);
% ylabel('确诊人数','fontsize',14);
% title('世界新冠疫情感染趋势','fontsize',14);
% grid on;
% dateaxis('x',1,'Jan.28');
% 
% p4 = polyfit(m,confirm,4);                                                 %最小二乘法三次多项式
% y4 = p4(1)*m.^4+p4(2)*m.^3+p4(3)*m.^2+p4(4)*m+p4(5);
% figure;
% plot(m,confirm,'.g');                                                      %绘出数据点，用绿色“.”表示
% hold on;
% plot(m,y4,'m');                                                            %绘出最小二乘法三次多项式用黑线表示
% xlabel('日期','fontsize',14);
% ylabel('确诊人数','fontsize',14);
% title('世界新冠疫情感染趋势','fontsize',14);
% grid on;
% dateaxis('x',1,'Jan.28');

