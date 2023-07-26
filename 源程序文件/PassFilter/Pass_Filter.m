function PF = Pass_Filter(im,D,n,L,mode)
    switch mode
        case "Ideal"
            PF = Ideal_Filter(im,D,L);
        case "Butter Worth"
            PF = ButWth_Filter(im,D,n,L);
        case "Gaussian"
            PF = Gos_Filter(im,D,L);
        otherwise
            return;
    end
end

