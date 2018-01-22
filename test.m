[filename,pathname] = uigetfile('*.txt','Select file(s) to analyse','multiselect','on');
            if iscell(filename)
                for i=1:length(filename)
                    s.Data(i).rawData = dlmread(strcat(pathname,filename{i}),'\t');
                    s.Data(i).name = {filename{i}};
                end
                updatelist
            elseif ischar(filename)
                s.Data.rawData = dlmread(strcat(pathname,filename),'\t');
                s.Data.name = filename;
            else
                disp('Nothing has been selected. Programme Quit')
                return
            end