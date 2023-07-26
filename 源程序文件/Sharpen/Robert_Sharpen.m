%   Robert算子求边缘
%   使用：罗伯特（图像，边缘淡化程度[就这么命名好了]）
%   边缘淡化程度越低细节保留越多
function R_Edge = Robert_Sharpen(img,T)
[m,n] = size(img);
imgr = zeros(m,n);
for i=2:m-1
    for j=2:n-1
        imgr(i,j)= abs(img(i,j)-img(i+1,j+1)) + abs(img(i+1,j)-img(i,j+1));
        if imgr(i,j)<T
            imgr(i,j) = 0;
        end
        if imgr(i,j)>255        %   防止越界
            imgr(i.j) = 255;
        end
    end
end
R_Edge = im2uint8(imgr);
end

