function[x1] = Gausspp(A,b,n)
%% 列主元高斯消去法
for k = 1:n-1
    u = k;
    for i = k+1:n
        if abs(A(i,k))>abs(A(u,k))                                         %寻找列中最大项
            u = i;
        end
    end
    
    if A(u,k) == 0 
        disp('矩阵错误！');                                                 %设置跳出
        return
    end

    for j = 1:n
        T = A(k,j);
        A(k,j) = A(u,j);                                                   %交换行
        A(u,j) = T;
%      T = b(m);
%     b(m) = b(k);
%     b(k) = T;       
    end
    
    T = b(u);
    b(u) = b(k);                                                           %一同交换
    b(k) = T;
    
    for i = k+1:n
        A(i,k) = A(i,k)/A(k,k);
        
        for j = k+1:n
            A(i,j) = A(i,j)-A(i,k)*A(k,j);                                 %用高斯消去法计算
        end
        b(i) = b(i)-A(i,k)*b(k);
        
    end

    
    %% 回代
    
    x1(n) = b(n)/A(n,n);
    
    for k = n-1:-1:1
        x1(k) = (b(k)-sum(A(k,k+1:n)*x1(k+1:n)'))/A(k,k);
    end
end