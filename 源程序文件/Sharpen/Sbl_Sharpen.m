%   Sobel算子求边缘
%   使用：苏泊尔（图像，边缘淡化程度）
function Sbl = Sbl_Sharpen(img,T)
[m,n] = size(img);  
imgs = zeros(m,n);
for i=2:m-1     %   网上抄的Sobel
    for j=2:n-1     
        imgs(i,j)= abs(img(i-1,j+1)+2*img(i,j+1)+img(i+1,j+1)-img(i-1,j-1)-2*img(i,j-1)-img(i+1,j-1)) + abs(img(i+1,j-1)+2*img(i+1,j)+img(i+1,j+1)-img(i-1,j-1)-2*img(i-1,j)-img(i-1,j+1));
        if imgs(i,j)<T
            imgs(i,j) = 0;
        end
        if imgs(i,j)>255        %   防止越界
            imgs(i.j) = 255;
        end
    end
end
Sbl = imgs;
end

