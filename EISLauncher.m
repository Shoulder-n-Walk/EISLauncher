function EISLauncher

    MainUI = dialog('units','normalized','Position',[0.2 0.4 0.3 0.3],'Name','EIS Launcher','windowstyle','normal');
    BPanel = uipanel('parent',MainUI,'units','normalized','Position',[0 0 1 1]);
    MPanel = uipanel('parent',MainUI,'units','normalized','Position',[0 0 1 1]);
    PPanel = uipanel('parent',MainUI,'units','normalized','Position',[0 0 1 1]);
    
    s = [];
    o.Grph = 1;
    o.ActivModel = 'Nothing Active';
    o.Models(1).name = 'Default';
    o.Models(1).build = 12345;
    
    Title = uicontrol('Parent',BPanel,...
                'Style','text',...
                'FontSize',20,...
                'units','normalized',...
                'String','EIS Analyser',...
                'HorizontalAlignment','left',...
                'Position',[0.04 0.48 0.3 0.5]);%#ok
            
    Caption1 = uicontrol('Parent',BPanel,...
                'Style','text',...
                'FontSize',14,...
                'units','normalized',...
                'String','(1)',...
                'Position',[0.02 0.7 0.08 0.1]);%#ok
            
    Caption2 = uicontrol('Parent',BPanel,...
                'Style','text',...
                'FontSize',14,...
                'units','normalized',...
                'String','(2)',...
                'Position',[0.02 0.5 0.08 0.1]);%#ok
            
    Caption3 = uicontrol('Parent',BPanel,...
                'Style','text',...
                'FontSize',14,...
                'units','normalized',...
                'String','(3)',...
                'Position',[0.02 0.3 0.08 0.1]);%#ok
                
    Import = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','pushbutton',...
                'Position',[0.12 0.7 0.3 0.1],...
                'FontSize',13,...
                'String','Import',...
                'Callback',@getdata);%#ok
            
    AddData = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','pushbutton',...
                'Position',[0.44 0.7 0.1 0.1],...
                'FontSize',13,...
                'String','Add',...
                'Callback',@adddata);%#ok
            
    DeleteData = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','pushbutton',...
                'Position',[0.55 0.7 0.1 0.1],...
                'FontSize',13,...
                'String','Del',...
                'Callback',@deletedata);%#ok
            
    ViewData = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','popupmenu',...
                'FontSize',13,...
                'Position',[0.68 0.7 0.3 0.1],...
                'string','Select/View');
            
    Model = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','pushbutton',...
                'Position',[0.12 0.5 0.3 0.1],...
                'FontSize',13,...
                'String','Select Model',...
                'Callback',@selectmodel);%#ok
            
    ActivModel = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','edit',...
                'Position',[0.44 0.5 0.21 0.1],...
                'FontSize',13,...
                'string','Nothing Active',...
                'enable','inactive');
            
    Plotter = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','pushbutton',...
                'Position',[0.68 0.5 0.3 0.1],...
                'FontSize',13,...
                'String','Plotter',...
                'Callback',@plotter);%#ok        
            
    FitCurve = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Style','pushbutton',...
                'Position',[0.12 0.3 0.3 0.1],...
                'FontSize',13,...
                'String','Fit Curve',...
                'Callback',@getdata);%#ok
            
    Export = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Position',[0.12 0.07 0.15 0.1],...
                'FontSize',13,...
                'String','Export',...
                'Callback',@export);%#ok  
    
    Reset = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Position',[0.27 0.07 0.15 0.1],...
                'FontSize',13,...
                'String','Reset',...
                'Callback',@reset);%#ok
           
    Close = uicontrol('Parent',BPanel,...
                'units','normalized',...
                'Position',[0.8 0.07 0.15 0.1],...
                'FontSize',13,...
                'String','Close',...
                'Callback','delete(gcf)');%#ok
            
    %Final step of initialisation...set panel states
    set(BPanel,'visible','on');
    set(MPanel,'visible','off');
    set(PPanel,'visible','off');
    
    function plotter(~,~)
        %Code to check if anything has been imported
        if isempty(s)
            disp('No data imported')
            return
        end
        
        %This is panel 1
        set(BPanel,'visible','off');
        set(MainUI,'position',[0.2 0.2 0.5 0.7]);
        set(PPanel,'visible','on');
        
        PTitle = uicontrol('Parent',PPanel,...
                'Style','text',...
                'FontSize',20,...
                'units','normalized',...
                'string','Plotter',...
                'HorizontalAlignment','left',...
                'Position',[0.01 0.95 0.11 0.05]);%#ok
            
        PIdentifier =  uicontrol('Parent',PPanel,...
                'Style','text',...
                'FontSize',12,...
                'units','normalized',...
                'HorizontalAlignment','left',...
                'Position',[0.095 0.955 0.07 0.03]);   
        
        Return = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Position',[0.905 0.085 0.09 0.061],...
                'FontSize',13,...
                'String','Return',...
                'Callback',@callback);%#ok
        
        Export_P = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Position',[0.905 0.02 0.09 0.061],...
                'FontSize',13,...
                'String','Export',...
                'Callback',@exportplotter);%#ok
            
        PViewData = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Style','popupmenu',...
                'FontSize',13,...
                'Position',[0.2 0.905 0.505 0.09],...
                'string','Select data to view');
            
        PAddData = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Position',[0.711 0.952 0.09 0.045],...
                'FontSize',13,...
                'String','Plot',...
                'Callback',@adddata);%#ok
            
        PAddAllData = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Position',[0.806 0.952 0.09 0.045],...
                'FontSize',13,...
                'String','Plot All',...
                'Callback',@addalldata);%#ok
            
        PClearGraph = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Position',[0.901 0.952 0.09 0.045],...
                'FontSize',13,...
                'String','Clear',...
                'Callback',@cleargraph);%#ok
            
        PChangeGraph = uicontrol('Parent',PPanel,...
                'units','normalized',...
                'Position',[0.01 0.02 0.14 0.126],...
                'FontSize',13,...
                'String','Bode/Nyquist',...
                'Callback',@changegraph);%#ok
            
        %Code to populate the scroll list
        mainlist = {s.Data.name};
        mainlist = sortrows(mainlist);
        mainlist(2:end+1) = mainlist;
        mainlist{1,1} = 'Select data to view';
        set(PViewData,'string',mainlist);

        %Create panels for the x and y axis controls
        P1Panel = uipanel('parent',PPanel,'units','normalized','Position',...
                    [0.16 0.02 0.24 0.14],'Title','X-axis','FontSize',12);
        P2Panel = uipanel('parent',PPanel,'units','normalized','Position',...
                    [0.41 0.02 0.24 0.14],'Title','Y-axis top','FontSize',12);
        P3Panel = uipanel('parent',PPanel,'units','normalized','Position',...
                    [0.66 0.02 0.24 0.14],'Title','Y-axis bottom','FontSize',12,'visible','off');
        
        %Setup graph axis control for each panel
        P1Min = uicontrol('Parent',P1Panel,'units','normalized','Style','text',...
                'FontSize',13,'Position',[0 0.02 0.2 0.4],'string','Min');%#ok
        P1Max = uicontrol('Parent',P1Panel,'units','normalized','Style','text',...
                'FontSize',13,'Position',[0 0.48 0.2 0.4],'string','Max');%#ok
        P2Min = uicontrol('Parent',P2Panel,'units','normalized','Style','text',...
                'FontSize',13,'Position',[0 0.02 0.2 0.4],'string','Min');%#ok
        P2Max = uicontrol('Parent',P2Panel,'units','normalized','Style','text',...
                'FontSize',13,'Position',[0 0.48 0.2 0.4],'string','Max');%#ok
        P3Min = uicontrol('Parent',P3Panel,'units','normalized','Style','text',...
                'FontSize',13,'Position',[0 0.02 0.2 0.4],'string','Min');%#ok
        P3Max = uicontrol('Parent',P3Panel,'units','normalized','Style','text',...
                'FontSize',13,'Position',[0 0.48 0.2 0.4],'string','Max');%#ok
        P1MinVal = uicontrol('Parent',P1Panel,'units','normalized','Style','edit',...
                'FontSize',13,'Position',[0.2 0.05 0.36 0.4],'KeyPressFcn',@xchange);
        P1MaxVal = uicontrol('Parent',P1Panel,'units','normalized','Style','edit',...
                'FontSize',13,'Position',[0.2 0.55 0.36 0.4],'KeyPressFcn',@xchange);
        P2MinVal = uicontrol('Parent',P2Panel,'units','normalized','Style','edit',...
                'FontSize',13,'Position',[0.2 0.05 0.36 0.4],'KeyPressFcn',@y1change);
        P2MaxVal = uicontrol('Parent',P2Panel,'units','normalized','Style','edit',...
                'FontSize',13,'Position',[0.2 0.55 0.36 0.4],'KeyPressFcn',@y1change);
        P3MinVal = uicontrol('Parent',P3Panel,'units','normalized','Style','edit',...
                'FontSize',13,'Position',[0.2 0.05 0.36 0.4],'KeyPressFcn',@y2change);
        P3MaxVal = uicontrol('Parent',P3Panel,'units','normalized','Style','edit',...
                'FontSize',13,'Position',[0.2 0.55 0.36 0.4],'KeyPressFcn',@y2change);
        
        %Scale change options for x axis    
        xbg = uibuttongroup(P1Panel,'units','normalized','Position',[0.6 0 0.4 1],...
                'Title','Scale','BorderType','beveledin','SelectionChangedFcn',@xselection);
        xlog = uicontrol(xbg,'Style','radiobutton','String','Logarithmic','units','normalized',...
                'Position',[0.02 0.5 1 0.5],'HandleVisibility','off','Tag','log');  
        xlin = uicontrol(xbg,'Style','radiobutton','String','Linear','units','normalized',...
                'Position',[0.02 0 1 0.5],'HandleVisibility','off','Tag','lin');
        
        %Scale change options for y axis top graph    
        ytbg = uibuttongroup(P2Panel,'units','normalized','Position',[0.6 0 0.4 1],...
                'Title','Scale','BorderType','beveledin','SelectionChangedFcn',@ytselection);
        ytlog = uicontrol(ytbg,'Style','radiobutton','String','Logarithmic','units','normalized',...
                'Position',[0.02 0.5 1 0.5],'HandleVisibility','off','Tag','log');    
        ytlin = uicontrol(ytbg,'Style','radiobutton','String','Linear','units','normalized',...
                'Position',[0.02 0 1 0.5],'HandleVisibility','off','Tag','lin');
            
        %Scale change options for y axis bottom graph     
        ybbg = uibuttongroup(P3Panel,'units','normalized','Position',[0.6 0 0.4 1],...
                'Title','Scale','BorderType','beveledin','SelectionChangedFcn',@ybselection);
        yblog = uicontrol(ybbg,'Style','radiobutton','String','Logarithmic','units','normalized',...
                'Position',[0.02 0.5 1 0.5],'HandleVisibility','off','Tag','log');%#ok    
        yblin = uicontrol(ybbg,'Style','radiobutton','String','Linear','units','normalized',...
                'Position',[0.02 0 1 0.5],'HandleVisibility','off','Tag','lin');
            
        %Initial Graph setup 
        PGrh11 = axes('parent',PPanel,'Units','normalized','Position',[0.06 0.23 0.91 0.71],'visible','off');
        PGrh21 = axes('parent',PPanel,'Units','normalized','Position',[0.06 0.59 0.91 0.34],'visible','off');
        PGrh22 = axes('parent',PPanel,'Units','normalized','Position',[0.06 0.23 0.91 0.34],'visible','off');
        
        %Refill the axis control fields
        updatefields
        
        %Setup the graph details/controls
        setupgraphs

        %Code to change the y axis limits(Nyquist & Bode top)
        function y1change(~,~)
            if o.Grph == 1
                %Gather as-is and to-be values
                currentyaxis = ylim(PGrh11);
                requestmin = str2double(get(P2MinVal,'string'));
                requestmax = str2double(get(P2MaxVal,'string'));

                %Check if values makes sense and update
                if (requestmin < currentyaxis(2)) && (requestmax > currentyaxis(1)) 
                    PGrh11.YLim = [requestmin requestmax];
                else
                    disp('Please enter suitable values')
                end
                
            elseif o.Grph == 2
                %Gather as-is and to-be values
                currentyaxis = ylim(PGrh21);
                requestmin = str2double(get(P2MinVal,'string'));
                requestmax = str2double(get(P2MaxVal,'string'));

                %Check if values makes sense and update
                if (requestmin < currentyaxis(2)) && (requestmax > currentyaxis(1)) 
                    PGrh21.YLim = [requestmin requestmax];
                else
                    disp('Please enter suitable values')
                end
            end           
        end
        
        %Code to change the bottom yaxis limits
        function y2change(~,~)
            %Gather as-is and to-be values
            currentyaxis = ylim(PGrh22);
            requestmin = str2double(get(P3MinVal,'string'));
            requestmax = str2double(get(P3MaxVal,'string'));

            %Check if values makes sense and update
            if (requestmin < currentyaxis(2)) && (requestmax > currentyaxis(1)) 
                PGrh22.YLim = [requestmin requestmax];
            else
                disp('Please enter suitable values')
            end            
        end
        
        %Code to change the x axis limits
        function xchange(~,~)
            if o.Grph == 1
                %Gather as-is and to-be values
                currentxaxis = xlim(PGrh11);
                requestmin = str2double(get(P1MinVal,'string'));
                requestmax = str2double(get(P1MaxVal,'string'));
                
                %Check if values makes sense and update
                if (requestmin < currentxaxis(2)) && (requestmax > currentxaxis(1)) 
                    PGrh11.XLim = [requestmin requestmax];
                else
                    disp('Please enter suitable values')
                end
                
            elseif o.Grph == 2
                %Gather as-is and to-be values
                currentxaxis = xlim(PGrh21);
                requestmin = str2double(get(P1MinVal,'string'));
                requestmax = str2double(get(P1MaxVal,'string'));
                
                %Check if values makes sense and update
                if (requestmin < currentxaxis(2)) && (requestmax > currentxaxis(1)) 
                    PGrh21.XLim = [requestmin requestmax];
                    PGrh22.XLim = [requestmin requestmax];
                else
                    disp('Please enter suitable values')
                end                
            end
        end
        
        %Code to change y axis scale(Nyquist & Bode top)
        function ytselection(~,~)
            if o.Grph == 1
                switch get(get(ytbg,'SelectedObject'),'Tag')
                    case 'log'
                    PGrh11.YScale = 'log';
                    case 'lin'
                    PGrh11.YScale = 'linear';
                end
            elseif o.Grph == 2
                switch get(get(ytbg,'SelectedObject'),'Tag')
                    case 'log'
                    PGrh21.YScale = 'log';
                    case 'lin' 
                    PGrh21.YScale = 'linear';
                end
            end
            updatefields
        end
        
        %Code to change bottom y axis scale
        function ybselection(~,~)
            switch get(get(ybbg,'SelectedObject'),'Tag')
                case 'log', PGrh22.YScale = 'log';
                case 'lin', PGrh22.YScale = 'linear';
            end
            updatefields
            
        end
        
        %Code to change the x axis scale
        function xselection(~,~)
            if o.Grph == 1
                switch get(get(xbg,'SelectedObject'),'Tag')
                    case 'log'
                    PGrh11.XScale = 'log';
                    case 'lin'
                    PGrh11.XScale = 'linear';
                end
            elseif o.Grph == 2
                switch get(get(xbg,'SelectedObject'),'Tag')
                    case 'log'
                    PGrh21.XScale = 'log';
                    PGrh22.XScale = 'log';
                    case 'lin' 
                    PGrh21.XScale = 'linear';
                    PGrh22.XScale = 'linear';
                end
            end
            updatefields
        end

        %Function to add data to graphs
        function adddata(~,~)
            if get(PViewData,'value') == 1
                disp('Please select a data file to add')
                return
            else
                selection = mainlist(get(PViewData,'value'));
                avail = {s.Data.name}';
                dataloc = find(strcmp(selection,avail));
                data = s.Data(dataloc).rawData;%#ok
                
                freq = data(:,1);
                real = data(:,2);
                imag = -data(:,3);
                
                %Code to check data length
                if length(real) == length(imag)
                else
                    warndlg('Data length mismatch. Please check raw data')
                    return
                end
                
                %Code to convert real/img to gain and phase
                for i=1:length(real)
                    data(i,4) = sqrt((real(i))^2 + (imag(i))^2);
                    data(i,5) = atan(imag(i)/ real(i));
                end

                mag = data(:,4);
                phase = data(:,5);
                
                if o.Grph == 1
                   hold(PGrh11,'on')
                   plot(PGrh11,real,imag)
                   xselection;
                   ytselection;
                   hold(PGrh11,'on')
                elseif o.Grph == 2
                   hold(PGrh21,'on')
                   hold(PGrh22,'on')
                   plot(PGrh21,freq,mag)
                   plot(PGrh22,freq,phase)
                   xselection;
                   ytselection;
                   ybselection;
                   hold(PGrh21,'on')
                   hold(PGrh22,'on')
                end
                updatefields
            end 
        end
        
        %Function to add all data points
        function addalldata(~,~)
            for j=1:length(s.Data)
               data = s.Data(j).rawData;
                
                freq = data(:,1);
                real = data(:,2);
                imag = -data(:,3);
                
                %Code to check data length
                if length(real) == length(imag)
                else
                    warndlg('Data length mismatch. Please check raw data')
                    return
                end
                
                %Code to convert real/img to gain and phase
                for i=1:length(real)
                    data(i,4) = sqrt((real(i))^2 + (imag(i))^2);
                    data(i,5) = atan(imag(i)/ real(i));
                end

                mag = data(:,4);
                phase = data(:,5);
                
                if o.Grph == 1
                   hold(PGrh11,'on')
                   plot(PGrh11,real,imag)
                   xselection;
                   ytselection;
                   hold(PGrh11,'on')
                elseif o.Grph == 2
                   hold(PGrh21,'on')
                   hold(PGrh22,'on')
                   plot(PGrh21,freq,mag)
                   plot(PGrh22,freq,phase)
                   xselection;
                   ytselection;
                   ybselection;
                   hold(PGrh21,'on')
                   hold(PGrh22,'on')
                end
                updatefields 
            end
        end
        
        %Function to clear graph data
        function cleargraph(~,~)
            %Check active graph and clear it
            if o.Grph == 1
                cla(PGrh11)
            elseif o.Grph == 2
                cla(PGrh21)
                cla(PGrh22)
            end
            disp('Graphs cleared')
        end
        
        %Code to change the graph type
        function changegraph(~,~)
            %Clear plotted graph data
            cleargraph
            
            %Hide existing graphs
            if o.Grph == 1
                set(PGrh11,'visible','off')
            elseif o.Grph == 2
                set(PGrh21,'visible','off')
                set(PGrh22,'visible','off')
            end
            
            % Construct a question dialog
            choice = questdlg('Nyquist or Bode Plot?',...
            'Switch Graph','Nyquist','Bode','Nyquist');
        
            % Handle response
            switch choice
            case 'Nyquist'
                disp([choice ' coming right up.'])
                o.Grph = 1;

            case 'Bode'
                disp([choice ' coming right up.'])
                o.Grph = 2;
            end
            
            %Call Graph setup function  
            setupgraphs
            
            %Call field update function
            updatefields
        end
        
        %Setup the graphs
        function setupgraphs
            if o.Grph == 1
                set(PIdentifier,'string','- Nyquist')
                set(P3Panel,'visible','off')
                set(P2Panel,'Title','Y-axis')
                set(PGrh11,'visible','on')
                PGrh11.XLabel.String = 'Zre (ohm)';
                PGrh11.XLabel.FontSize = 12;
                PGrh11.YLabel.String = '-Zim (ohm)';
                PGrh11.YLabel.FontSize = 12;
                PGrh11.XScale = 'linear';
                PGrh11.YScale = 'linear';
                PGrh11.XGrid = 'on';
                PGrh11.YGrid = 'on';
                
                %Set default x and y scales as linear    
                set(xbg,'SelectedObject',xlin);  
                set(ytbg,'SelectedObject',ytlin);
                
            elseif o.Grph == 2
                set(PIdentifier,'string','- Bode')
                set(P3Panel,'visible','on')
                set(P2Panel,'Title','Y-axis top')
                set(P3Panel,'Title','Y-axis bottom')
                set(PGrh21,'visible','on')
                set(PGrh22,'visible','on')
                PGrh22.XLabel.String = 'Frequency(Hz)';
                PGrh21.XLabel.FontSize = 12;
                PGrh21.XColor = 'none';
                PGrh21.YLabel.String = 'Gain(dB)';
                PGrh21.YLabel.FontSize = 12;
                PGrh22.YLabel.String = 'Phase(\Theta)';
                PGrh22.YLabel.FontSize = 12;
                PGrh21.XScale = 'log';
                PGrh21.YScale = 'log';
                PGrh22.XScale = 'log';
                PGrh22.YScale = 'linear';
                PGrh21.XGrid = 'on';
                PGrh21.YGrid = 'on';
                PGrh22.XGrid = 'on';
                PGrh22.YGrid = 'on';
                
                %Set default x and y scales    
                set(xbg,'SelectedObject',xlog);
                set(ytbg,'SelectedObject',ytlog);
                set(ybbg,'SelectedObject',yblin);
            end
        end
        
        %Update all the fields
        function updatefields
            if o.Grph == 1
                currentxaxis = xlim(PGrh11);
                set(P1MinVal,'string',num2str(currentxaxis(1)));
                set(P1MaxVal,'string',num2str(currentxaxis(2)));

                currentyaxis = ylim(PGrh11);
                set(P2MinVal,'string',num2str(currentyaxis(1)));
                set(P2MaxVal,'string',num2str(currentyaxis(2)));
            elseif o.Grph == 2
                currentxaxis = xlim(PGrh21);
                set(P1MinVal,'string',num2str(currentxaxis(1)));
                set(P1MaxVal,'string',num2str(currentxaxis(2)));

                currentytaxis = ylim(PGrh21);
                set(P2MinVal,'string',num2str(currentytaxis(1)));
                set(P2MaxVal,'string',num2str(currentytaxis(2)));
                
                currentybaxis = ylim(PGrh22);
                set(P3MinVal,'string',num2str(currentybaxis(1)));
                set(P3MaxVal,'string',num2str(currentybaxis(2)));                
            end                
        end
        
        %Function for plotter to return to main
        function callback(~,~)
            %Delete existing graphs
            if o.Grph == 1
                delete(PGrh11)
                delete(P1Panel)
            elseif o.Grph == 2
                delete(PGrh21)
                delete(PGrh22)
                delete(P2Panel)
                delete(P3Panel)
            end
            
            goback(1);
        end 
        
        %Function to export the current plotted data
        function exportplotter(~,~) 
            if o.Grph == 1
            elseif o.Grph == 2
            end
            disp('Export under development!')
        end
    end
            
    function selectmodel(~,~)
        
        %This is panel 2
        set(BPanel,'visible','off');
        set(MainUI,'position',[0.2 0.2 0.5 0.7]);
        set(MPanel,'visible','on');
        
        MTitle = uicontrol('Parent',MPanel,...
                'Style','text',...
                'FontSize',20,...
                'units','normalized',...
                'HorizontalAlignment','left',...
                'String','Equivalent Circuits',...
                'Position',[0.01 0.95 0.3 0.05]);%#ok
        
        Return = uicontrol('Parent',MPanel,...
                'units','normalized',...
                'Position',[0.905 0.085 0.09 0.061],...
                'FontSize',13,...
                'String','Return',...
                'Callback',@callback);%#ok
        
        Close_M = uicontrol('Parent',MPanel,...
                'units','normalized',...
                'Position',[0.905 0.02 0.09 0.061],...
                'FontSize',13,...
                'String','Close',...
                'Callback','delete(gcf)');%#ok
            
       MViewModel = uicontrol('Parent',MPanel,...
                'units','normalized',...
                'Style','popupmenu',...
                'FontSize',13,...
                'Position',[0.28 0.905 0.53 0.09],...
                'string','Select model');
            
       MSelModel = uicontrol('Parent',MPanel,...
                'units','normalized',...
                'Position',[0.815 0.952 0.09 0.045],...
                'FontSize',13,...
                'String','Select',...
                'Callback',@selectmodel);%#ok
            
       MNewModel = uicontrol('Parent',MPanel,...
                'units','normalized',...
                'Position',[0.91 0.952 0.09 0.045],...
                'FontSize',13,...
                'String','New',...
                'Callback',@newmodel);%#ok
            
       MSaveModel = uicontrol('Parent',MPanel,...
                'units','normalized',...
                'Position',[0.815 0.02 0.09 0.061],...
                'FontSize',13,...
                'String','Save',...
                'Callback',@savemodel);%#ok
            
            
            
        updatescrolllist;
        
        %Function to delete models
        %Function to edit models
        %Function to save models - ask name popup

        function savemodel(~,~)
           %Include code to ignore repeats 
        end
        
        function selectmodel(~,~)
            %Code to set it as active model in main prog.
            disp('Select model function. Please add code')
        end
        
        function newmodel(~,~)
            disp('New model function. Please add code')
        end
        
        function updatescrolllist
           %Code to populate the scroll list
            modellist = {o.Models.name};
            modellist = sortrows(modellist);
            modellist(2:end+1) = modellist;
            modellist{1,1} = 'Select model';
            set(MViewModel,'string',modellist); 
        end
        
        function callback(~,~)
            goback(2);
        end    
    end

    function goback(panel)
        if panel == 1
            set(PPanel,'visible','off');
            set(MainUI,'position',[0.2 0.4 0.3 0.3]);
            set(BPanel,'visible','on');
        elseif panel == 2
            set(MPanel,'visible','off');
            set(MainUI,'position',[0.2 0.4 0.3 0.3]);
            set(BPanel,'visible','on');
        end        
    end

    function updatemodel(~,~)
        set(ActivModel,'string',o.ActivModel);
    end
            
    function updatelist
        %Code for pop up menu
        mainlist = {s.Data.name}';
        mainlist = sortrows(mainlist);
        mainlist(2:end+1) = mainlist;
        mainlist{1,1} = 'Select/View';
        
        %Populate the popupmenu list
        set(ViewData,'string',mainlist);
    end
   
    function getdata(~,~)
        if isempty(s)
            [filename,pathname] = uigetfile('*.txt','Select file(s) to analyse','multiselect','on');
            if iscell(filename)
                for i=1:length(filename)
                    s.Data(i).rawData = dlmread(strcat(pathname,filename{i}),'\t');
                    s.Data(i).name = filename{i};
                end
                updatelist
            elseif ischar(filename)
                s.Data.rawData = dlmread(strcat(pathname,filename),'\t');
                s.Data.name = filename;
                updatelist
            else
                disp('Nothing has been selected. Programme Quit')
                return
            end
        else
            disp('Some data has already been imported. Use ''+'' or Reset.')
        end
    end

    function adddata(~,~)
        if isempty(s)
            disp('Please use ''Import'' button first')
        else
            [filename,pathname] = uigetfile('*.txt','Select file(s) to analyse','multiselect','on');
            if iscell(filename)
                for i=1:length(filename)
                    loc = length(s.Data);
                    s.Data(loc+1).rawData = dlmread(strcat(pathname,filename{i}),'\t');
                    s.Data(loc+1).name = filename{i};
                end
                updatelist
            elseif ischar(filename)
                loc = length(s.Data);
                s.Data(loc+1).rawData = dlmread(strcat(pathname,filename),'\t');
                s.Data(loc+1).name = filename;
                updatelist
            else
                disp('Nothing has been selected. Programme Quit')
                return
            end
        end
  
    end

    function deletedata(~,~)
        if isempty(s)
            disp('Nothing imported')
        else
            s = [];
            set(ViewData,'value',1);
            set(ViewData,'string','Select/View');
            disp('Deleted')
        end
    end

    function export(~,~)
        
    end

    function reset(~,~)
        s = [];
        set(ViewData,'value',1);
        set(ViewData,'string','Select/View');
        disp('Reset!') 
    end
end