function [x0] = Gauss(A,b,n)
%% 高斯消去法


for k = 1:n-1
         if A(k,k) == 0
            disp('输入矩阵错误');                                           %设置跳出
            break
         else
             
             for i = k+1:n
                 A(i,k) = A(i,k)/A(k,k);
                 for j = k+1:n
                     A(i,j) = A(i,j)-A(i,k)*A(k,j);                        %高斯消去法计算矩阵A
                 end
                 b(i) = b(i)-A(i,k)*b(k);
             end
         end
end
    
    %消去完成，开始回代
    
    x0 = [];
    x0(n) = b(n)/A(n,n);
    
    for k = n-1:-1:1
      S = b(k);
            
      for j = k+1:n
            S = S-A(k,j)*x0(j);
        end
        
        x0(k) = S/A(k,k);
    end
