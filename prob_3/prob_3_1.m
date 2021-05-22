clear;
close;
clc;                                                                       %清除工作区、命令区、关闭所有figure

%% 程序开始，数据读入
[f,p] = uigetfile('*.dat','选择数据文件');                                  %让用户选择文件，获得其文件路径及文件名分别存储在f,p中
num = 6;                                                                   %由数据结构得头文件长度为6
file = strcat(p,f);                                                        %读入dat
fid = fopen(file);                                                         %读入文件数组
head = fread(fid,num,'uint');                                              %读取头文件

disp('文件名：'); 
disp(f);                                                                   %打印文件名

n = head(4);                                                               %获数组长度
disp('该方程的阶数为：');                                           
disp(n);                                                                   %打印方程阶数

ver = dec2hex(head(2));                                                    %获取文件版本并转换成10进制
disp('文件版本号为：');
disp(ver);                                                                 %打印文件版本

q = head(5);                                                               %获取上带宽
disp('该方程的上带宽为：');
disp(q);                                                                   %打印上带宽

p = head(6);                                                               %获取下带宽
disp('该方程的下带宽为：');
disp(p);                                                                   %打印下带宽

data = fread(fid,inf,'float');                                             %获取系数向量

%% 形成稀疏矩阵A与向量b
%L = length(data);
if ver == '102'                                                            %若文件为非压缩格式
    A = zeros(n,n);                                                        %创建矩阵A
    %     for j = 1:n
    %         for i = 1:n
    %             A(i,j) = data((j-1)*n+i);
    %         end
    %     end
    for i = 1:n
        for j = 1:n
            A(i,j) = data((i-1)*n+j);                                      %将data向量转化成A矩阵
        end
    end
    
    b = zeros(n,1);                                                        %创建b向量
    
    for i = 1:n
        b(i) = data(n*n+i);                                                %循环将data里面的y数组读出为向量
    end
    
    % 解非压缩格式
    x0 = Gauss(A,b,n);                                                     %高斯消去法，封装函数为Gauss.m
    x1 = Gausspp(A,b,n);                                                   %列主元高斯消去法，函数封装为Gausspp.m

end
                    
%% 形成压缩格式矩阵A与b

if ver == '202'                                                            %若文件为压缩格式
    m = p+q+1;                                                             %求出矩阵的列数
    A = zeros(n,m);                                                        %创建n*m矩阵
    
    for i = 1:n
        for j = 1:m
            A(i,j) = data((i-1)*m+j);                                      %循环将data里面的数据组成为矩阵A
        end
    end
    
    b = zeros(n,1);                                                        %创建空向量b
    
    for i = 1:n
        b(i) = data(n*m+i);                                                %循环将data里面的y组成为向量b
    end
    
    %解压缩格式
    
    x2 = Gauss_C(A,b,n,m,p,q);                                             %高斯消去法，封装为Gauss_C.m
end
    