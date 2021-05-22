clear;                                                                     %清除数据空间
clc;                                                                       %清除窗口命令
%% 系统开始
x = 0:100:5000;                                                            %创建探测点位置
X = 0:1:5000;                                                              %将插值点存储在X中
y = [341.96,311.10,315.74,324.49,321.14,333.09,318.68,338.88,325.66...
    ,309.84,328.62,321.80,320.74,308.30,328.45,312.62,317.83,327.40...
    ,323.75,313.48,316.66,340.19,332.40,319.20,334.64,311.43,328.92...
    ,314.11,319.84,321.28,333.84,319.68,321.20,320.89,325.90,335.28...
    ,332.00,324.47,313.36,330.60,322.32,315.10,319.89,316.75,321.92...
    ,327.64,320.40,329.88,332.00,344.35,348.41];                           %深度数据
n = length(x);                                                             %数据点个数
N = length(X);                                                             %待求插值点值的个数
M = y;

for k = 2:3   
    for i = n:-1:k
        M(i) = (M(i)-M(i-1))/(x(i)-x(i-k+1));   
    end
end

h(1) = x(2) - x(1);

for i = 2:n-1
    h(i) = x(i)-x(i-1);
    c(i) = h(i)/(h(i)+h(i-1));                                             %Lamda_i
    a(i) = 1-c(i);                                                         %mu_i
    b(i) = 2;                                                              %对角线值
    d(i) = M(i+1)*6;
end

M(1) = 0;                                                                  %边界条件
M(n) = 0;
c(1) = 0;
a(1) = 0;
d(1) = 0;
d(n) = 0;
b(1) = 2;

U(1) = b(1);                                                               %进行LU分解设置
Y(1) = d(1);

%% LU分解
for k = 2:n-1
    l(k) = a(k)/U(k-1);
    U(k) = b(k)-l(k)*c(k-1);
    Y(k) = d(k)-l(k)*Y(k-1);
end

M(n) = Y(n-1)/U(n-1);

for k = n-1:-1:1
    M(k) = (Y(k)-c(k)*M(k+1))/U(k);                                        %追赶法求样条参数
end

%% 插值多项式计算
s = zeros(1,N);                                                            %为s定义一个行向量

for m = 1:N
    k = 1;                                                                 %判断插值点是否大于下一数据点
    for i = 2:n-1
        if X(m) <= x(i)
            k = i-1;
            break;
        else
            k = i;
        end 
    end
    
    H = x(k+1)-x(k);                                                       %求两数据点区间长度
    x1 = x(k+1)-X(m);                                                      %后向数据点与该插值点区间长
    x2 = X(m)-x(k);                                                        %前向插值点与该插值点区间长
    s(m) = (M(k)*(x1^3)/(H*6)+M(k+1)*(x2^3)/(6*H)+(y(k)...
        -(M(k)*(H^2)/6))*x1/H+(y(k+1)-(M(k+1)*(...
        H^2)/6))*x2/H);                                                    %利用插值公式计算每个插值点的值

end

%% 绘图及长度计算
L = 0;                                                                     %创建一个变量

for i = 2:N
    L = L+sqrt((X(i)-X(i-1))^2+(s(i)-s(i-1))^2);                           %计算两个插值点之间的长度(勾股定理)
end

disp('所需光缆长度为L=');                                                   %在命令窗口显示一行字
disp(L);                                                                   %在命令行窗口给出L答案
figure
plot(x,y,'*',X,s,'.');                                                     %"*"为数据点，"."为插值点
xlabel('分点位置','fontsize',16);
ylabel('测点深度/m','fontsize',16);
title('铺设光缆的插值曲线图','fontsize',16);
grid on;