classdef SourceCode < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        ImageAxes                     matlab.ui.control.UIAxes
        LoadButton                    matlab.ui.control.Button
        recreateimageButton           matlab.ui.control.Button
        cropimageButton               matlab.ui.control.Button
        ToGrayButton                  matlab.ui.control.Button
        TabGroup                      matlab.ui.container.TabGroup
        BrightnessoptTab              matlab.ui.container.Tab
        SliderLabel                   matlab.ui.control.Label
        BOpSlider                     matlab.ui.control.Slider
        Label                         matlab.ui.control.Label
        BOpSpinner                    matlab.ui.control.Spinner
        BOpButton                     matlab.ui.control.Button
        ShapenTab                     matlab.ui.container.Tab
        OperatorDropDownLabel         matlab.ui.control.Label
        OperatorDropDown              matlab.ui.control.DropDown
        EdgeDimSpinnerLabel           matlab.ui.control.Label
        EdgeDimSpinner                matlab.ui.control.Spinner
        SharpentheimageButton         matlab.ui.control.Button
        PassFilterTab                 matlab.ui.container.Tab
        FilterDropDownLabel           matlab.ui.control.Label
        FilterDropDown                matlab.ui.control.DropDown
        PassModeButtonGroup           matlab.ui.container.ButtonGroup
        HighPassButton                matlab.ui.control.RadioButton
        LowPassButton                 matlab.ui.control.RadioButton
        RadiusAllowedSpinnerLabel     matlab.ui.control.Label
        RadiusAllowedSpinner          matlab.ui.control.Spinner
        FilterImageButton             matlab.ui.control.Button
        PowerforButterWorthSpinner_2Label  matlab.ui.control.Label
        PowerforButterWorthSpinner_2  matlab.ui.control.Spinner
        TextArea                      matlab.ui.control.TextArea
        HistOptTab                    matlab.ui.container.Tab
        HistagramEquatingButton       matlab.ui.control.Button
        HistagramShowButton           matlab.ui.control.Button
        EasyWeinerFilterTab           matlab.ui.container.Tab
        EstimatedNoiseDropDownLabel   matlab.ui.control.Label
        EstimatedNoiseDropDown        matlab.ui.control.DropDown
        WindowhightSpinnerLabel       matlab.ui.control.Label
        WindowhightSpinner            matlab.ui.control.Spinner
        WindowwidthSpinnerLabel       matlab.ui.control.Label
        WindowwidthSpinner            matlab.ui.control.Spinner
        WFButton                      matlab.ui.control.Button
        BetterGaussFilterTab          matlab.ui.container.Tab
        EpsilonSliderLabel            matlab.ui.control.Label
        EpsilonSlider                 matlab.ui.control.Slider
        EpsilonSpinnerLabel           matlab.ui.control.Label
        EpsilonSpinner                matlab.ui.control.Spinner
        GaussfilteringSwitchLabel     matlab.ui.control.Label
        GaussfilteringSwitch          matlab.ui.control.Switch
        zoominfor1xButton             matlab.ui.control.Button
        zoomoutfor1xButton            matlab.ui.control.Button
    end


    
    properties (Access = public)
        im uint8
        p_im uint8
        im_sz double
        background uint8
        im_gray logical
        p_im_gray logical
    end
    
    
    methods (Access = private)
        
        function updateimage(app,imagefile)
            % For corn.tif, read the second image in the file
            if strcmp(imagefile,'corn.tif')
                app.im = imread('corn.tif', 2);
            else
                try
                    app.im = imread(imagefile);
                catch ME
                    % If problem reading image, display error message
                    uialert(app.UIFigure, ME.message, 'Image Error');
                    return;
                end            
            end 
            
            %   ÿÿÿÿÿÿ
            app.im_sz = size(app.im);
            
            %   ÿÿÿÿÿÿÿÿÿÿÿ
            app.p_im = app.im;
            
            %   ÿÿÿÿ(ÿÿÿÿ)
            app.background = app.im;
            app.background(:,:) = 255;
            
            
            
            % Create histograms based on number of color channels
            switch size(app.im,3)
                case 1
                    % Display the grayscale image
                    imagesc(app.ImageAxes,app.im);                    
                    %   ÿÿÿÿÿ   
                    app.im_gray = true;
                    app.p_im_gray = app.im_gray;
                case 3
                    % Display the truecolor image
                    imagesc(app.ImageAxes,app.im);                   
                    %   ÿÿÿÿÿ
                    app.im_gray = false;
                    app.p_im_gray = app.im_gray;
                    
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end        
        end
    end    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %   ÿÿÿÿÿÿÿÿÿÿ
            addpath("Sharpen");
            addpath("PassFilter");
            % Configure image axes
            app.ImageAxes.Visible = 'off';
            app.ImageAxes.Colormap = gray(256);
            axis(app.ImageAxes, 'image');            
            % Update the image and histograms
            updateimage(app, 'peppers.png');
        end

        % Callback function
        function DropDownValueChanged(app, event)
            
            % Update the image and histograms
            updateimage(app, app.FilterDropDown.Value);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
               
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateimage(app, fname);
            end
        end

        % Button pushed function: zoominfor1xButton
        function Zoom_In(app, event)
            r = app.im_sz(1)/2;
            c = app.im_sz(2)/2;
            app.p_im = imresize(app.p_im,[r,c]);
            bk = app.background;
            %   ÿÿÿÿÿÿÿÿÿÿÿÿÿ
            if(app.p_im_gray)
                bk = rgb2gray(bk);
                bk(r/2:3*r/2-1,c/2:3*c/2-1) = app.p_im;
            else
                bk(r/2:3*r/2-1,c/2:3*c/2-1,:) = app.p_im;
            end
            app.p_im = bk;
            imagesc(app.ImageAxes,app.p_im);
        end

        % Button pushed function: zoomoutfor1xButton
        function Zoom_Out(app, event)
            r = app.im_sz(1)/2;
            c = app.im_sz(2)/2;
            %   ÿÿÿÿÿÿÿÿÿÿÿÿÿ
            if(app.p_im_gray)
                bk = app.p_im(r/2:3*r/2-1,c/2:3*c/2-1);
            else
                bk = app.p_im(r/2:3*r/2-1,c/2:3*c/2-1,:);
            end
            app.p_im = imresize(bk,[app.im_sz(1),app.im_sz(2)]);
            imagesc(app.ImageAxes,app.p_im);
        end

        % Button pushed function: recreateimageButton
        function Recreation(app, event)
            app.p_im = app.im;
            app.p_im_gray = app.im_gray;
            imagesc(app.ImageAxes,app.im);
        end

        % Button pushed function: cropimageButton
        function Im_Crop(app, event)
            %   ÿÿÿÿÿÿÿÿ
            app.p_im = imcrop(app.p_im);
            imagesc(app.ImageAxes,app.p_im);
        end

        % Callback function: EpsilonSlider, EpsilonSlider
        function Eps_Slide(app, event)
            app.EpsilonSpinner.Value = app.EpsilonSlider.Value;
        end

        % Value changed function: EpsilonSpinner
        function Eps_Spinner(app, event)
            app.EpsilonSlider.Value = app.EpsilonSpinner.Value;            
        end

        % Value changed function: GaussfilteringSwitch
        function Gauss_filter(app, event)
            if(app.GaussfilteringSwitch.Value == "On" && app.EpsilonSpinner.Value > 0)
                tmp = imgaussfilt(app.p_im,app.EpsilonSpinner.Value);
                imagesc(app.ImageAxes,tmp);
            else
                imagesc(app.ImageAxes,app.p_im);
            end            
        end

        % Button pushed function: ToGrayButton
        function Im2Gray(app, event)
            %   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
            if(app.p_im_gray || app.im_gray)
                            
            else
                app.p_im = rgb2gray(app.p_im);
                imagesc(app.ImageAxes,app.p_im);
                app.p_im_gray = true;
            end
        end

        % Button pushed function: HistagramEquatingButton
        function HistEq(app, event)
            %   ÿÿÿÿÿÿ
            app.p_im = histeq(app.p_im);
            imagesc(app.ImageAxes,app.p_im);
        end

        % Button pushed function: HistagramShowButton
        function HistShow(app, event)
            %   ÿÿÿÿÿ
            imhist(app.p_im);
        end

        % Button pushed function: SharpentheimageButton
        function Im_Sharpen(app, event)
            Tspan = app.EdgeDimSpinner.Value;   %   ÿÿÿÿÿÿ
            if Tspan < 0
                Tspan = 0;
            end
            %   ÿÿÿÿÿÿÿÿÿÿÿÿÿ
            if(app.p_im_gray)
                app.p_im = app.p_im + SharpenedIm(app.p_im,Tspan,app.OperatorDropDown.Value);
            else
                for i=1:3
                    app.p_im(:,:,i) = app.p_im(:,:,i) + SharpenedIm(app.p_im(:,:,i),Tspan,app.OperatorDropDown.Value);
                end
            end
            %   ÿÿÿÿ
            imagesc(app.ImageAxes,app.p_im);
        end

        % Button pushed function: FilterImageButton
        function ImPassFilter(app, event)
            %   ÿÿÿÿ
            D = app.RadiusAllowedSpinner.Value;
            n = app.PowerforButterWorthSpinner_2.Value;
            L = app.LowPassButton.Value;
            H = app.HighPassButton.Value;
            mode = app.FilterDropDown.Value;
            
            %   ÿÿÿÿÿÿÿÿÿÿÿÿÿ
            %   ÿÿL  Hÿÿÿÿÿÿÿÿ
            if(app.p_im_gray)
                if(L)
                    app.p_im = Pass_Filter(app.p_im,D,n,true,mode);
                elseif(H)
                    app.p_im = Pass_Filter(app.p_im,D,n,false,mode);
                else
                    return;
                end
            else
                if(L)
                     for i=1:3
                        app.p_im(:,:,i) = Pass_Filter(app.p_im(:,:,i),D,n,true,mode);
                     end
                elseif(H)
                     for i=1:3
                        app.p_im(:,:,i) = Pass_Filter(app.p_im(:,:,i),D,n,false,mode);
                     end
                else
                    return;
                end
               
            end
            %   ÿÿÿÿ
            imagesc(app.ImageAxes,app.p_im);            
        end

        % Value changed function: BOpSpinner
        function BOpSpin(app, event)
            %   ÿÿÿÿÿÿÿÿ
            app.BOpSlider.Value = app.BOpSpinner.Value;    
        end

        % Value changed function: BOpSlider
        function BOpSlide(app, event)
            %   ÿÿÿÿÿÿÿÿ
            app.BOpSpinner.Value = app.BOpSlider.Value;            
        end

        % Button pushed function: BOpButton
        function BOp(app, event)
       %   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
            Bvalue = app.BOpSlider.Value;   %   ÿÿÿÿÿÿÿÿÿÿ
                if(Bvalue == 0)
                    return;                         %   0ÿÿÿÿÿÿ
                elseif(Bvalue>0)
                    app.p_im = imadd(app.p_im,Bvalue);     %   ÿÿ0ÿÿÿ
                elseif(Bvalue<0)
                    Bvalue = abs(Bvalue);
                    app.p_im = imsubtract(app.p_im,Bvalue);      %   ÿÿ0ÿÿÿ
                end
                 %   ÿÿÿÿ
                imagesc(app.ImageAxes,app.p_im);  
        end

        % Button pushed function: WFButton
        function WnF(app, event)
            %   ÿÿÿÿÿÿ
            %   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
            r = app.WindowhightSpinner.Value;
            c = app.WindowwidthSpinner.Value;
            %   ÿÿÿÿÿÿÿÿÿÿÿÿ
            if(r<=0 || c<=0)
                return;
            end
            f = app.EstimatedNoiseDropDown.Value;
            psf = fspecial(f,r,c);
            
            %   ÿÿMATLABÿÿÿÿÿÿÿÿ
            app.p_im = deconvwnr(app.p_im,psf);
            %   ÿÿÿÿ
            imagesc(app.ImageAxes,app.p_im);  
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 702 528];
            app.UIFigure.Name = 'Image Histograms';
            app.UIFigure.Resize = 'off';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Position = [43 181 357 305];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [78 149 137 22];
            app.LoadButton.Text = 'Load Image';

            % Create recreateimageButton
            app.recreateimageButton = uibutton(app.UIFigure, 'push');
            app.recreateimageButton.ButtonPushedFcn = createCallbackFcn(app, @Recreation, true);
            app.recreateimageButton.Position = [245 149 100 22];
            app.recreateimageButton.Text = {'recreate image'; ''};

            % Create cropimageButton
            app.cropimageButton = uibutton(app.UIFigure, 'push');
            app.cropimageButton.ButtonPushedFcn = createCallbackFcn(app, @Im_Crop, true);
            app.cropimageButton.Position = [245 105 100 22];
            app.cropimageButton.Text = {'crop image'; ''};

            % Create ToGrayButton
            app.ToGrayButton = uibutton(app.UIFigure, 'push');
            app.ToGrayButton.ButtonPushedFcn = createCallbackFcn(app, @Im2Gray, true);
            app.ToGrayButton.Position = [97 105 100 22];
            app.ToGrayButton.Text = {'To Gray'; ''};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.AutoResizeChildren = 'off';
            app.TabGroup.Position = [419 224 260 262];

            % Create BrightnessoptTab
            app.BrightnessoptTab = uitab(app.TabGroup);
            app.BrightnessoptTab.Title = 'Brightness opt';

            % Create SliderLabel
            app.SliderLabel = uilabel(app.BrightnessoptTab);
            app.SliderLabel.HorizontalAlignment = 'right';
            app.SliderLabel.Position = [10 18 25 22];
            app.SliderLabel.Text = '';

            % Create BOpSlider
            app.BOpSlider = uislider(app.BrightnessoptTab);
            app.BOpSlider.Limits = [-255 255];
            app.BOpSlider.Orientation = 'vertical';
            app.BOpSlider.ValueChangedFcn = createCallbackFcn(app, @BOpSlide, true);
            app.BOpSlider.Position = [56 27 3 189];

            % Create Label
            app.Label = uilabel(app.BrightnessoptTab);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [145 184 25 22];
            app.Label.Text = '';

            % Create BOpSpinner
            app.BOpSpinner = uispinner(app.BrightnessoptTab);
            app.BOpSpinner.ValueChangedFcn = createCallbackFcn(app, @BOpSpin, true);
            app.BOpSpinner.Position = [185 184 56 22];

            % Create BOpButton
            app.BOpButton = uibutton(app.BrightnessoptTab, 'push');
            app.BOpButton.ButtonPushedFcn = createCallbackFcn(app, @BOp, true);
            app.BOpButton.Position = [137 55 111 71];
            app.BOpButton.Text = {'Push to lighten'; ' or darken'};

            % Create ShapenTab
            app.ShapenTab = uitab(app.TabGroup);
            app.ShapenTab.Title = 'Shapen';

            % Create OperatorDropDownLabel
            app.OperatorDropDownLabel = uilabel(app.ShapenTab);
            app.OperatorDropDownLabel.HorizontalAlignment = 'right';
            app.OperatorDropDownLabel.Position = [50 196 53 22];
            app.OperatorDropDownLabel.Text = 'Operator';

            % Create OperatorDropDown
            app.OperatorDropDown = uidropdown(app.ShapenTab);
            app.OperatorDropDown.Items = {'Laplace', 'Robert', 'Sobel', 'Prewitt'};
            app.OperatorDropDown.Position = [118 196 105 22];
            app.OperatorDropDown.Value = 'Laplace';

            % Create EdgeDimSpinnerLabel
            app.EdgeDimSpinnerLabel = uilabel(app.ShapenTab);
            app.EdgeDimSpinnerLabel.HorizontalAlignment = 'right';
            app.EdgeDimSpinnerLabel.Position = [50 156 58 22];
            app.EdgeDimSpinnerLabel.Text = 'Edge Dim';

            % Create EdgeDimSpinner
            app.EdgeDimSpinner = uispinner(app.ShapenTab);
            app.EdgeDimSpinner.Position = [123 156 100 22];

            % Create SharpentheimageButton
            app.SharpentheimageButton = uibutton(app.ShapenTab, 'push');
            app.SharpentheimageButton.ButtonPushedFcn = createCallbackFcn(app, @Im_Sharpen, true);
            app.SharpentheimageButton.Position = [59 90 165 39];
            app.SharpentheimageButton.Text = 'Sharpen the image';

            % Create PassFilterTab
            app.PassFilterTab = uitab(app.TabGroup);
            app.PassFilterTab.Title = 'Pass Filter';

            % Create FilterDropDownLabel
            app.FilterDropDownLabel = uilabel(app.PassFilterTab);
            app.FilterDropDownLabel.HorizontalAlignment = 'right';
            app.FilterDropDownLabel.Position = [59 200 32 22];
            app.FilterDropDownLabel.Text = 'Filter';

            % Create FilterDropDown
            app.FilterDropDown = uidropdown(app.PassFilterTab);
            app.FilterDropDown.Items = {'Butter Worth', 'Gaussian', 'Ideal'};
            app.FilterDropDown.Position = [106 200 100 22];
            app.FilterDropDown.Value = 'Ideal';

            % Create PassModeButtonGroup
            app.PassModeButtonGroup = uibuttongroup(app.PassFilterTab);
            app.PassModeButtonGroup.Title = 'Pass Mode';
            app.PassModeButtonGroup.Position = [17 124 102 67];

            % Create HighPassButton
            app.HighPassButton = uiradiobutton(app.PassModeButtonGroup);
            app.HighPassButton.Text = 'High Pass';
            app.HighPassButton.Position = [11 21 77 22];
            app.HighPassButton.Value = true;

            % Create LowPassButton
            app.LowPassButton = uiradiobutton(app.PassModeButtonGroup);
            app.LowPassButton.Text = 'Low Pass';
            app.LowPassButton.Position = [11 -1 74 22];

            % Create RadiusAllowedSpinnerLabel
            app.RadiusAllowedSpinnerLabel = uilabel(app.PassFilterTab);
            app.RadiusAllowedSpinnerLabel.HorizontalAlignment = 'right';
            app.RadiusAllowedSpinnerLabel.Position = [71 86 88 22];
            app.RadiusAllowedSpinnerLabel.Text = 'Radius Allowed';

            % Create RadiusAllowedSpinner
            app.RadiusAllowedSpinner = uispinner(app.PassFilterTab);
            app.RadiusAllowedSpinner.Position = [174 86 52 22];

            % Create FilterImageButton
            app.FilterImageButton = uibutton(app.PassFilterTab, 'push');
            app.FilterImageButton.ButtonPushedFcn = createCallbackFcn(app, @ImPassFilter, true);
            app.FilterImageButton.Position = [139 129 100 62];
            app.FilterImageButton.Text = 'Filter Image';

            % Create PowerforButterWorthSpinner_2Label
            app.PowerforButterWorthSpinner_2Label = uilabel(app.PassFilterTab);
            app.PowerforButterWorthSpinner_2Label.HorizontalAlignment = 'right';
            app.PowerforButterWorthSpinner_2Label.Position = [17 55 140 22];
            app.PowerforButterWorthSpinner_2Label.Text = 'Power ÿfor ButterWorth)';

            % Create PowerforButterWorthSpinner_2
            app.PowerforButterWorthSpinner_2 = uispinner(app.PassFilterTab);
            app.PowerforButterWorthSpinner_2.Position = [172 55 52 22];

            % Create TextArea
            app.TextArea = uitextarea(app.PassFilterTab);
            app.TextArea.Editable = 'off';
            app.TextArea.Enable = 'off';
            app.TextArea.Position = [1 1 258 43];
            app.TextArea.Value = {'ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ'};

            % Create HistOptTab
            app.HistOptTab = uitab(app.TabGroup);
            app.HistOptTab.Title = 'Hist Opt';

            % Create HistagramEquatingButton
            app.HistagramEquatingButton = uibutton(app.HistOptTab, 'push');
            app.HistagramEquatingButton.ButtonPushedFcn = createCallbackFcn(app, @HistEq, true);
            app.HistagramEquatingButton.FontSize = 16;
            app.HistagramEquatingButton.Position = [49 137 157 58];
            app.HistagramEquatingButton.Text = 'Histagram Equating';

            % Create HistagramShowButton
            app.HistagramShowButton = uibutton(app.HistOptTab, 'push');
            app.HistagramShowButton.ButtonPushedFcn = createCallbackFcn(app, @HistShow, true);
            app.HistagramShowButton.FontSize = 16;
            app.HistagramShowButton.Position = [49 53 162 55];
            app.HistagramShowButton.Text = 'Histagram Show';

            % Create EasyWeinerFilterTab
            app.EasyWeinerFilterTab = uitab(app.TabGroup);
            app.EasyWeinerFilterTab.Title = 'Easy Weiner Filter';

            % Create EstimatedNoiseDropDownLabel
            app.EstimatedNoiseDropDownLabel = uilabel(app.EasyWeinerFilterTab);
            app.EstimatedNoiseDropDownLabel.HorizontalAlignment = 'right';
            app.EstimatedNoiseDropDownLabel.Position = [16 184 93 22];
            app.EstimatedNoiseDropDownLabel.Text = 'Estimated Noise';

            % Create EstimatedNoiseDropDown
            app.EstimatedNoiseDropDown = uidropdown(app.EasyWeinerFilterTab);
            app.EstimatedNoiseDropDown.Items = {'gaussian', 'motion'};
            app.EstimatedNoiseDropDown.Position = [124 184 100 22];
            app.EstimatedNoiseDropDown.Value = 'gaussian';

            % Create WindowhightSpinnerLabel
            app.WindowhightSpinnerLabel = uilabel(app.EasyWeinerFilterTab);
            app.WindowhightSpinnerLabel.HorizontalAlignment = 'right';
            app.WindowhightSpinnerLabel.Position = [29 119 78 22];
            app.WindowhightSpinnerLabel.Text = 'Window hight';

            % Create WindowhightSpinner
            app.WindowhightSpinner = uispinner(app.EasyWeinerFilterTab);
            app.WindowhightSpinner.Position = [122 119 100 22];

            % Create WindowwidthSpinnerLabel
            app.WindowwidthSpinnerLabel = uilabel(app.EasyWeinerFilterTab);
            app.WindowwidthSpinnerLabel.HorizontalAlignment = 'right';
            app.WindowwidthSpinnerLabel.Position = [29 145 80 22];
            app.WindowwidthSpinnerLabel.Text = 'Window width';

            % Create WindowwidthSpinner
            app.WindowwidthSpinner = uispinner(app.EasyWeinerFilterTab);
            app.WindowwidthSpinner.Position = [124 145 98 22];

            % Create WFButton
            app.WFButton = uibutton(app.EasyWeinerFilterTab, 'push');
            app.WFButton.ButtonPushedFcn = createCallbackFcn(app, @WnF, true);
            app.WFButton.Position = [46 43 180 44];
            app.WFButton.Text = 'On';

            % Create BetterGaussFilterTab
            app.BetterGaussFilterTab = uitab(app.TabGroup);
            app.BetterGaussFilterTab.AutoResizeChildren = 'off';
            app.BetterGaussFilterTab.Title = 'Better Gauss Filter';

            % Create EpsilonSliderLabel
            app.EpsilonSliderLabel = uilabel(app.BetterGaussFilterTab);
            app.EpsilonSliderLabel.HorizontalAlignment = 'right';
            app.EpsilonSliderLabel.Position = [19 128 45 22];
            app.EpsilonSliderLabel.Text = 'Epsilon';

            % Create EpsilonSlider
            app.EpsilonSlider = uislider(app.BetterGaussFilterTab);
            app.EpsilonSlider.ValueChangedFcn = createCallbackFcn(app, @Eps_Slide, true);
            app.EpsilonSlider.ValueChangingFcn = createCallbackFcn(app, @Eps_Slide, true);
            app.EpsilonSlider.Position = [85 137 150 3];

            % Create EpsilonSpinnerLabel
            app.EpsilonSpinnerLabel = uilabel(app.BetterGaussFilterTab);
            app.EpsilonSpinnerLabel.HorizontalAlignment = 'right';
            app.EpsilonSpinnerLabel.Position = [19 184 45 22];
            app.EpsilonSpinnerLabel.Text = 'Epsilon';

            % Create EpsilonSpinner
            app.EpsilonSpinner = uispinner(app.BetterGaussFilterTab);
            app.EpsilonSpinner.ValueChangedFcn = createCallbackFcn(app, @Eps_Spinner, true);
            app.EpsilonSpinner.Position = [79 184 67 22];

            % Create GaussfilteringSwitchLabel
            app.GaussfilteringSwitchLabel = uilabel(app.BetterGaussFilterTab);
            app.GaussfilteringSwitchLabel.HorizontalAlignment = 'center';
            app.GaussfilteringSwitchLabel.Position = [162 149 82 22];
            app.GaussfilteringSwitchLabel.Text = 'Gauss filtering';

            % Create GaussfilteringSwitch
            app.GaussfilteringSwitch = uiswitch(app.BetterGaussFilterTab, 'slider');
            app.GaussfilteringSwitch.ValueChangedFcn = createCallbackFcn(app, @Gauss_filter, true);
            app.GaussfilteringSwitch.Position = [179 186 45 20];

            % Create zoominfor1xButton
            app.zoominfor1xButton = uibutton(app.UIFigure, 'push');
            app.zoominfor1xButton.ButtonPushedFcn = createCallbackFcn(app, @Zoom_In, true);
            app.zoominfor1xButton.Position = [379 150 100 20];
            app.zoominfor1xButton.Text = 'zoom in for 1x';

            % Create zoomoutfor1xButton
            app.zoomoutfor1xButton = uibutton(app.UIFigure, 'push');
            app.zoomoutfor1xButton.ButtonPushedFcn = createCallbackFcn(app, @Zoom_Out, true);
            app.zoomoutfor1xButton.Position = [379 104 100 24];
            app.zoomoutfor1xButton.Text = 'zoom out for 1x';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SourceCode

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end