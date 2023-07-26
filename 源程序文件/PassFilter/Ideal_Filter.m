%   高斯滤波(图像，频谱中心半径[单位px]，是否低通）
%   仅支持单色变换
function Id = Ideal_Filter(im,D,L)
     %打开进度条,滤波真的很慢
      H=waitbar(0,'请稍等.......'); 
     set(H,'doublebuffer','on');

    if ~isa(im,'double')    %浮点数处理
        im1 = double(im)/255;
    else
        return;
    end
    im2 = fft2(im1);    % 傅里叶变换加偏转幅度
    im3 = fftshift(im2);

    [N1, N2] = size(im3);       %四舍五入以下行列信息
    n1 = fix(N1 / 2);
    n2 = fix(N2 / 2);
    result = im1;
    if(L)                  %   根据L位选择高低通滤波
        for i = 1:N1
            for j = 2:N2
                d = sqrt((i-n1)^2+(j-n2)^2);        %计算频率域中点与频率矩形中心的距离
                %   根据半径确定通过频率
                h = double(d<=D);
                result(i,j) = h * im3(i,j);                 %用滤波器做滤波
            end
            waitbar(i/N1,H,num2str(i)+"/"+num2str(N1));
        end
    else
        for i = 1:N1
            for j = 2:N2
                d = sqrt((i-n1)^2+(j-n2)^2);        %计算频率域中点与频率矩形中心的距离
                %   根据半径确定通过频率
                h = double(D<=d);
                result(i,j) = h * im3(i,j);                 %用滤波器做滤波
            end
            waitbar(i/N1,H,num2str(i)+"/"+num2str(N1));
        end
    end
    
    close(H);   %关闭进度条
    
    result = ifftshift(result);                    % 逆傅里叶变换还原图像
    im4 = ifft2(result);                           
    Id = im2uint8(real(im4)); 
end



