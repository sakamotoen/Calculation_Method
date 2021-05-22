function [x2] = Gauss(A,b,n,m,p,q)
%% 高斯消去法


for k = 1:n-1
         if A(k,p+1) == 0
            disp('输入矩阵错误');                                           %设置跳出
            break
         else
             b_edge = n;                                                   %设置中间变量b_edge表示数据边缘位置
             
             if (k+p)<n
                 b_edge = k+p;
             end
             
             for i = k+1:b_edge
                 A(i,k+p-i+1) = A(i,k+p-i+1)/A(k,p+1);
                 for j = k+1:k+q
                     A(i,j+p-i+1) = A(i,j+p-i+1)-A(i,k+p-i+1)*A(k,j+p-k+1);%高斯消去法计算矩阵A
                 end
                 b(i) = b(i)-A(i,k+p-i+1)*b(k);
             end
         end
end
    
    %消去完成，开始回代
    
    x2 = [];
    x2(n) = b(n)/A(n,p+1);
    
    for k = n-1:-1:1
      S = b(k);
      
      if k+q<n
          b_edge = k+q;
      end
            
      for j = k+1:b_edge
            S = S-A(k,j+p-k+1)*x2(j);
        end
        
        x2(k) = S/A(k,p+1);
    end
