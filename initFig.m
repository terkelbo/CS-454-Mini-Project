function [out_args] = initFig(f)
fontsize = f;
boundingbox = [45 3 501 501];
boundingboxlarge = [45 3 547 547];
viewport = [78 78 390 390];
% if nargin<1
%     flag_large = false;
% end
% if flag_large
%     boundingbox = boundingboxlarge;
% end
paperposition = [0 0 boundingbox(3:4)];

figure(1);
set(0,'DefaultFigureColor','w')  % White background in bounding box
set(gcf,'color','w')
set(0,'DefaultAxesColor','w') % Transparent inside viewport
set(0,'DefaultLegendBox','off')
set(0,'DefaultLegendInterpreter','latex')
set(0,'DefaultLineMarkerSize',15)
set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultAxesTickLabelInterpreter','latex')
set(0,'DefaultTextFontsize',fontsize);
set(0,'DefaultAxesFontsize',fontsize);
set(0,'DefaultAxesLineWidth',3.);
set(0,'DefaultLineLineWidth',4.);
set(0,'DefaultErrorBarLineWidth',2.);
% set(0,'DefaultTextFontName','Calibri');
% set(0,'DefaultLegendFontName','Calibri');
% set(0,'defaulttitlefontname','Calibri');
% set(0,'DefaultAxesFontName','Calibri');
% set(0,'DefaultFigureUnits','points');
% set(0,'DefaultFigurePosition',boundingbox);
% set(0,'DefaultFigureResize','off');
% set(0,'DefaultAxesActivePositionProperty','Position')
% set(0,'DefaultAxesUnits','points');
% set(0,'DefaultAxesPosition',viewport);
delete(1);
end