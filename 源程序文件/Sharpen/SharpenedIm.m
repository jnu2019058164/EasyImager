%   锐化器，锐化函数接口
function SIm = SharpenedIm(img,Tspan,Opt)
    switch Opt
        case "Laplace"
            SIm = Lp_Sharpen(img,Tspan);
        case "Robert"
            SIm = Robert_Sharpen(img,Tspan);
        case "Sobel"
            SIm = Sbl_Sharpen(img,Tspan);
        case "Prewitt"
            SIm = PrWt_Sharpen(img,Tspan);
        otherwise
            return;
    end
    SIm = im2uint8(SIm);
end

