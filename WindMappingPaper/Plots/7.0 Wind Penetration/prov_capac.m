function prov_capac
% prov_capac - Generates map of province wind capacities and their fraction
% out of total province generation
% 
% References:
%    N/A
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
% Data files required: provinces.dbf, provinces.prj, provinces.shp,
%                      provinces.shx, prov_capac.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% June 2020; Last revision: 19-June-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data   = readtable('prov_capac.csv');
prov   = data.Province;
tot19  = data.Total2019MW;
wind19 = data.Wind2019MW;
p_lat  = data.Lat;
p_lon  = data.Long;
clear data

% Define 2017 wind penetration
wpen19 = wind19./tot19;

% Load in Canada from worldmap, define coastlines and province boundaries
ax = worldmap('Canada');
provinces = shaperead('provinces','UseGeoCoords',true);
framem('off');
gridm('off');
mlabel('off');
plabel('off');

clr = [1 1 1];
% Define facecolors based off wind penetration
faceColor1 = makesymbolspec('Polygon',...
    {'PREABBR','B.C.','FaceColor',(1-wpen19(1))*clr},...
    {'PREABBR','Alta.','FaceColor',(1-wpen19(2))*clr},...
    {'PREABBR','Sask.','FaceColor',(1-wpen19(3))*clr},...
    {'PREABBR','Man.','FaceColor',(1-wpen19(4))*clr},...
    {'PREABBR','Ont.','FaceColor',(1-wpen19(5))*clr},...
    {'PREABBR','Que.','FaceColor',(1-wpen19(6))*clr},...
    {'PREABBR','N.B.','FaceColor',(1-wpen19(7))*clr},...
    {'PREABBR','N.S.','FaceColor',(1-wpen19(8))*clr},...
    {'PREABBR','P.E.I.','FaceColor',(1-wpen19(9))*clr},...
    {'PREABBR','N.L.','FaceColor',(1-wpen19(10))*clr},...
    {'PREABBR','Y.T.','FaceColor',(1-wpen19(11))*clr},...
    {'PREABBR','N.W.T.','FaceColor',(1-wpen19(12))*clr},...
    {'PREABBR','Nvt.','FaceColor',(1-wpen19(13))*clr});

geoshow(ax,provinces,'DisplayType','polygon','SymbolSpec',faceColor1);

% Generate province labels with current wind capacity
for i = 1:length(prov)
    wind      = addComma(wind19(i));
    tot       = addComma(tot19(i));
    lbl{i,:}  = sprintf('   %1s\n   %1s MW\n(%1s MW)',prov{i},wind,tot);
end

% Define lat/long of all provinces for labels
textm(p_lat,p_lon,lbl,'Interpreter','latex','FontSize',9.5,'HorizontalAlignment','Center');

% Add colour bar
clr = colorbar;
clr.Location = 'southoutside';
clr.Position = [0.35 0.1349 0.4 0.02]; % [xpos ypos width height]
clr.FontSize = 11;
clr.Label.Interpreter = 'latex';
clr.Label.String = 'Wind Intalled Capacity/Total System Capacity (\%)';
clr.Label.FontSize = 12;
clr.TickLabelInterpreter = 'latex';
clr.TickLabels = {0 10 20 30 40 50 60 70 80 90 100};
colormap(flipud(gray));

% Window size
set(gcf,'Units','inches','Position',[1 1 8.5 5]); % [xpos ypos width height]

% Function to add commas to numbers
function numOut = addComma(numIn)
   jf=java.text.DecimalFormat; % comma for thousands, three decimal places
   numOut= char(jf.format(numIn)); % omit "char" if you want a string out
end

end
