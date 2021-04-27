function LCOS(year)
% LCOS - Plots relative LCOS of technologies given their frequency and 
% depth of discharge
% 
% References:
%    https://www.sciencedirect.com/science/article/pii/S254243511830583X
%
% Syntax:
%    N/A
%
% Inputs:
%    N/A
%
% Outputs:
%    N/A
%
% Example: 
%    N/A
%
% Other m-files required: none
% Data files required: LCOS2015.CSV (for example)
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% April 2021; Last revision: 08-Apr-2021
%------------- BEGIN CODE --------------

% Read in data
data = readtable(['LCOS' num2str(year) '.csv']);

% Find the index of the 2 smallest LCOS for each observation
[B,I] = mink(data{:,3:end},2,2);

% Find the % difference between two minimum LCOS for each observation
B(:,3) = (B(:,2)-B(:,1))./B(:,2);

% Find the technology name (label) for the minimums LCOS
minLCOS = data(:,3:end).Properties.VariableNames(I(:,1))';

% Create a new table which gives only the cheapest tech and % increase per
% observation
newData = [data(:,1:2),...
           array2table(minLCOS,'VariableNames',{'Technology'}),...
           array2table(B(:,[1,3]),'VariableNames',{'LCOS','PercentDiff'})];
       
% Sort table by cycles, duration
newData = sortrows(newData,{'Cycles','Duration'},{'ascend','ascend'});

% Find index for when each technology has min LCOS
iPHES           = string(newData.Technology) == 'PHES';
iCAES           = string(newData.Technology) == 'CAES';
iFlywheel       = string(newData.Technology) == 'Flywheel';
iLi             = string(newData.Technology) == 'Li';
iNaS            = string(newData.Technology) == 'NaS';
iLead           = string(newData.Technology) == 'Lead';
iVRFB           = string(newData.Technology) == 'VRFB';
iH2             = string(newData.Technology) == 'H2';
iSupercapacitor = string(newData.Technology) == 'Supercapacitor';

% Use colors to generate a color map
cPHES           = [0 0 1;0.2 0.5 1; 0.8 0.9 1];
cCAES           = [0.1 0.7 0.1;0.2 0.8 0.2; 0.75 1 0.75];
cFlywheel       = [1 0.5 0;1 0.6 0;1 0.7 0];
cLi             = [1 0 0;1 0.5 0.5;1 0.75 0.75];
cNaS            = [1 0.9 0;1 0.9 0.4; 1 0.9 0.7];
cLead           = [1 0.1 1;1 0.3 1;1 0.5 1];
cVRFB           = [0.5 0 1;0.7 0.2 1;0.9 0.5 1];
cH2             = [0.2 0.2 0.2;0.5 0.5 0.5; 0.7 0.7 0.7];
cSupercapacitor = [0.7 0.5 0.2;0.8 0.6 0.3; 0.9 0.7 0.4];


mPHES           = customcolormap([0 0.5 1],cPHES);           % Blue
mCAES           = customcolormap([0 0.5 1],cCAES);           % Green
mFlywheel       = customcolormap([0 0.5 1],cFlywheel);       % Orange
mLi             = customcolormap([0 0.5 1],cLi);             % Red
mNaS            = customcolormap([0 0.5 1],cNaS);            % Yellow
mLead           = customcolormap([0 0.5 1],cLead);           % Pink
mVRFB           = customcolormap([0 0.5 1],cVRFB);           % Purple
mH2             = customcolormap([0 0.5 1],cH2);             % Black
mSupercapacitor = customcolormap([0 0.5 1],cSupercapacitor); % Brown

% Grids for contour plot
cycles     = unique(newData.Cycles);
duration   = unique(newData.Duration);
[X,Y]      = ndgrid(cycles,duration);

% Contour values for each technology
zPHES           = griddata(newData.Cycles(iPHES),newData.Duration(iPHES),...
                 newData.PercentDiff(iPHES),X,Y);
zCAES           = griddata(newData.Cycles(iCAES),newData.Duration(iCAES),...
                 newData.PercentDiff(iCAES), X,Y);
zFlywheel       = griddata(newData.Cycles(iFlywheel),newData.Duration(iFlywheel),...
                 newData.PercentDiff(iFlywheel),X,Y);
zLi             = griddata(newData.Cycles(iLi),newData.Duration(iLi),...
                 newData.PercentDiff(iLi),X,Y);
zNaS            = griddata(newData.Cycles(iNaS),newData.Duration(iNaS),...
                  newData.PercentDiff(iNaS),X,Y);             
zLead           = griddata(newData.Cycles(iLead),newData.Duration(iLead),...
                 newData.PercentDiff(iLead),X,Y);
zVRFB           = griddata(newData.Cycles(iVRFB),newData.Duration(iVRFB),...
                 newData.PercentDiff(iVRFB),X,Y);
zH2             = griddata(newData.Cycles(iH2),newData.Duration(iH2),...
                 newData.PercentDiff(iH2),X,Y); 
zSupercapacitor = griddata(newData.Cycles(iSupercapacitor),newData.Duration(iSupercapacitor),...
                 newData.PercentDiff(iSupercapacitor),X,Y);
             
% Contour for LCOS for cheapest technology
zLCOS           = griddata(newData.Cycles,newData.Duration,newData.LCOS,X,Y);

listlevel       = log10([100 200 500 1000 2000 5000 10000 20000 50000]);

% Plot contour for LCOS
figure(1)
contourf(X,Y,log10(zLCOS),15,'linecolor',[0.5 0.5 0.5],'linewidth',0.5,'levellist',listlevel);
curax = gca;
curax.XScale = 'log';
curax.YScale = 'log';
curax.ColorScale = 'log';
set(curax,'TickLabelInterpreter','Latex');
curax.XTick       = [1 10 100 1000 10000];
curax.XTickLabels = curax.XTick;
curax.YTick       = [[] 1 4 16 64 256 1024];
curax.YTickLabels = curax.YTick;
xlabel(curax,'Frequency of Discharge (cycles/year)','Interpreter','Latex');
ylabel(curax,'Depth of Discharge (hours/cycle)','Interpreter','Latex');
title(curax,['\textbf{' num2str(year) '}'],'Interpreter','Latex');

colormap(curax,gray);
clrbar = colorbar(curax);
clrbar.Limits = [2 4.7];
clrbar.Ticks = log10([100 200 500 1000 2000 5000 10000 20000 50000]);
clrbar.TickLabels = {'100' '200' '500' '1,000' '2,000' '5,000' '10,000' '20,000' '$>$50,000'};
clrbar.TickLabelInterpreter = 'Latex';
clrbar.Location = 'West';
clrbar.Position = [0.86 0.46 0.03 0.387];
clrbar.YAxisLocation = 'Left';
ttl = title(clrbar,'\textbf{LCOS (\$/MWh)}','Interpreter','Latex');
ttl.Position = [-24.75,129.25,0];


% Add patch to block imaginary contour points
xMax = max(newData.Cycles);
xMin = max(newData.Cycles(newData.Duration==max(newData.Duration)));
yMax = max(newData.Duration);
yMin = max(newData.Duration(newData.Cycles==max(newData.Cycles)));
patch(curax,[xMax xMax xMin xMax],[yMin yMax yMax yMin],[1 1 1],'EdgeColor','none');


% Plot contour per technology
fig2 = figure(2);

try 
    ax(1) = axes;
    subplot(1,4,4,ax(1));
    contourf(X,Y,zPHES,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(1),mPHES);
catch
end

try
    ax(2) = axes;
    subplot(1,4,4,ax(2));
    contourf(X,Y,zCAES,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(2),mCAES);
catch
end

try
    ax(3) = axes;
    subplot(1,4,4,ax(3));
    contourf(X,Y,zFlywheel,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(3),mFlywheel);
catch
end

try
    ax(4) = axes;
    subplot(1,4,4,ax(4));
    contourf(X,Y,zLi,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(4),mLi);
catch
end
try
    ax(5) = axes;
    subplot(1,4,4,ax(5));
    contourf(X,Y,zNaS,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(5),mNaS);
catch
end
try
    ax(6) = axes;
    subplot(1,4,4,ax(6));
    contourf(X,Y,zLead,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(6),mLead);
catch
end
try
    ax(7) = axes;
    subplot(1,4,4,ax(7));
    contourf(X,Y,zVRFB,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(7),mVRFB);
catch
end

try
    ax(8) = axes;
    subplot(1,4,4,ax(8));
    contourf(X,Y,zH2,'linecolor','none'); hold on
    curax = gca;
    colormap(ax(8),mH2);
catch
end

try
    ax(9) = axes;
    subplot(1,4,4,ax(9));
    contourf(X,Y,zSupercapacitor,'linecolor','none');
    curax = gca;
    colormap(ax(9),mSupercapacitor);

catch
end

for i = 1:9
    ax(i).XScale = 'log';
    ax(i).YScale = 'log';
    ax(i).Color  = 'none';
    ax(i).XTickLabels = [];
    ax(i).XTick       = [];
    ax(i).YTickLabels = [];
    ax(i).YTick       = [];
end

% Add patch to block imaginary contour points
xMax = max(newData.Cycles);
xMin = max(newData.Cycles(newData.Duration==max(newData.Duration)));
yMax = max(newData.Duration);
yMin = max(newData.Duration(newData.Cycles==max(newData.Cycles)));
patch(curax,[xMax xMax xMin xMax],[yMin yMax yMax yMin],[1 1 1],'EdgeColor','none');

% Display only 'top' axis
set(curax,'TickLabelInterpreter','Latex');
curax.XTick       = [1 10 100 1000 10000];
curax.XTickLabels = curax.XTick;
curax.YTick       = [[] 1 4 16 64 256 1024];
curax.YTickLabels = curax.YTick;
xlabel(curax,'Frequency of Discharge (cycles/year)','Interpreter','Latex');
ylabel(curax,'Depth of Discharge (hours/cycle)','Interpreter','Latex');
title(curax,['\textbf{' num2str(year) '}'],'Interpreter','Latex');

% Dummy plots for legend
hPHES           = area(curax,NaN,'FaceColor',cPHES(1,:));
hCAES           = area(curax,NaN,'FaceColor',cCAES(1,:));
hFlywheel       = area(curax,NaN,'FaceColor',cFlywheel(1,:));
hLi             = area(curax,NaN,'FaceColor',cLi(1,:));
hNaS            = area(curax,NaN,'FaceColor',cNaS(1,:));
hLead           = area(curax,NaN,'FaceColor',cLead(1,:));
hVRFB           = area(curax,NaN,'FaceColor',cVRFB(1,:));
hH2             = area(curax,NaN,'FaceColor',cH2(1,:));
hSupercapacitor = area(curax,NaN,'FaceColor',cSupercapacitor(1,:));

axis off

% Legend
leg = legend([hPHES hCAES hFlywheel hLi hNaS hLead hVRFB hH2 hSupercapacitor],...
    'Pumped Hydro','Compressed Air','Flywheel','Li-Battery','NaS-Battery','Lead-Battery','Flow Battery','H2 Fuel Cell','Supercapacitor',...
    'location','NorthEast','Interpreter','Latex');
box(leg,'off');



% Annotation
% Create textbox
annotation(fig2,'textbox',...
    [0.46 0.69 0.18 0.2],...
    'String',{'Shading indicates cost advantage over second best technology'},...
    'Interpreter','latex',...
    'FitBoxToText','off',...
    'EdgeColor','none');