%   Sobel算子求边缘
%   使用：普雷微（图像，边缘淡化程度）
function Pw = PrWt_Sharpen(img,T)
[m,n] = size(img);  
imgp = zeros(m,n);
for i=2:m-1     %   网上抄的prewitt算子
    for j=2:n-1
        imgp(i,j)= abs(img(i-1,j+1)+img(i,j+1)+img(i+1,j+1)-img(i-1,j-1)-img(i,j-1)-img(i+1,j-1)) + abs(img(i+1,j-1)+img(i+1,j)+img(i+1,j+1)-img(i-1,j-1)-img(i-1,j)-img(i-1,j+1));
        if imgp(i,j)<T
            imgp(i,j) = 0;
        end
        if imgp(i,j)>255        %   防止越界
            imgp(i.j) = 255;
        end
    end
end
Pw = imgp;
end

