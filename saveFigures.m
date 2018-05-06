function [ output_args ] = saveFigures( handle, fileName,saveDefault,openscale)
% saveFigure 
%   Saves figure specified by `handle` as `fileName` in fullscreen
%   as to get around the stupid behavior.
if nargin < 3
    saveDefault = true;
end
if nargin < 4
    openscale = 1;
if openscale 
    screen_size = get(0, 'ScreenSize');
    origSize = get(handle, 'Position'); % grab original on screen size
    temp = cd;
    if strcmp(temp(end-10:end),'\EgetMATLAB') && saveDefault == true
        fname = [cd '\FilesToLatex'];
    else
        fname = [cd '\img'];
    end
    set(handle, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
    set(handle,'PaperPositionMode','auto') %set paper pos for printing
    saveas(handle, fullfile(fname, fileName),'epsc') % save figure
    saveas(handle, fullfile(fname, fileName),'png')
%     saveas(handle, fullfile(fname, fileName),'tiff')
    set(handle,'Position', origSize) %set back to original dimensions
else
    temp = cd;
    if strcmp(temp(end-10:end),'\EgetMATLAB') && saveDefault == true
        fname = [cd '\FilesToLatex'];
    else
        fname = [cd '\img'];
    end
    saveas(handle, fullfile(fname, fileName),'epsc') % save figure
    saveas(handle, fullfile(fname, fileName),'png')
%     saveas(handle, fullfile(fname, fileName),'tiff')
end
end