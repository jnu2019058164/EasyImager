%   Laplace算子求边缘
%   使用：拉普拉斯（图像，边缘淡化程度）
function Lp = Lp_Sharpen(img,T)
[m,n] = size(img);  
imgl = zeros(m,n);
for i=2:m-1         %   套公式,就数值计算那个求导的
    for j=2:n-1
        imgl(i,j)= abs(img(i+1,j)+img(i-1,j)+img(i,j+1)+img(i,j-1)-4*img(i,j));
        if imgl(i,j)<T
            imgl(i,j) = 0;
        end
        if imgl(i,j)>255    %   防止越界
            imgl(i.j) = 255;
        end
    end
end
Lp = imgl;
end

