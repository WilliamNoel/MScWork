function GlobalStorage
% GlobalStorage - Plots information pertaining to the global storage fleet
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
% Data files required: GESDB_Projects_11_17_2020.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% March 2021; Last revision: 03-Mar-2021
%------------- BEGIN CODE --------------

%% Data read in and clean up
% Read in .csv datafile and extract relevant data
data   = readtable('GESDB_Projects_11_17_2020.csv');
sTable = data(:,{'Technology_Broad_Category','Technology_Mid_Type',...
                 'Technology_Sub_Type','Status','Rated_Power_kW',...
                 'Latitude','Longitude','Country','Commissioned',});
clear data

% Clean up table
sTable = rmmissing(sTable); % Remove rows with missing data
sTable = sTable(string(sTable.Status) == 'Operational',:); % Only operational projects
sTable = sTable(sTable.Rated_Power_kW >0,:); % Plants with capacity > 0

% Define type of storage
% Pumped Hydro
sTable.PumpedHydro   = (contains(sTable.Technology_Broad_Category,'hydro','IgnoreCase',true)|...
                      contains(sTable.Technology_Mid_Type,'hydro','IgnoreCase',true)|...
                      contains(sTable.Technology_Sub_Type,'hydro','IgnoreCase',true));
% Compressed Air
sTable.CompressedAir = (contains(sTable.Technology_Broad_Category,'compressed air','IgnoreCase',true)|...
                      contains(sTable.Technology_Mid_Type,'compressed air','IgnoreCase',true)|...
                      contains(sTable.Technology_Sub_Type,'compressed air','IgnoreCase',true));
% Fly Wheel
sTable.FlyWheel      = (contains(sTable.Technology_Broad_Category,'fly','IgnoreCase',true)|...
                      contains(sTable.Technology_Mid_Type,'fly','IgnoreCase',true)|...
                      contains(sTable.Technology_Sub_Type,'fly','IgnoreCase',true));
% Thermal
sTable.Thermal       = (contains(sTable.Technology_Broad_Category,'thermal','IgnoreCase',true)|...
                      contains(sTable.Technology_Mid_Type,'thermal','IgnoreCase',true)|...
                      contains(sTable.Technology_Sub_Type,'thermal','IgnoreCase',true));

% Electrical (battery)
sTable.Battery       = ((contains(sTable.Technology_Broad_Category,'battery','IgnoreCase',true) & ...
                    ~contains(sTable.Technology_Broad_Category,'flow','IgnoreCase',true)) | ...
                    (contains(sTable.Technology_Mid_Type,'battery','IgnoreCase',true) & ...
                    ~contains(sTable.Technology_Mid_Type,'flow','IgnoreCase',true)) | ...
                    (contains(sTable.Technology_Sub_Type,'battery','IgnoreCase',true) & ...
                    ~contains(sTable.Technology_Sub_Type,'flow','IgnoreCase',true)));
% Other
sTable.Other         = (~sTable.PumpedHydro & ~sTable.CompressedAir & ...
                        ~sTable.FlyWheel    & ~sTable.Thermal       & ...
                        ~sTable.Battery);

% Define list of countries with storage projects & their max capacity
countries = array2table(unique(sTable.Country),'VariableNames',{'Country'});

for i = 1:height(countries)
    countries.CapacityGW(i) = sum(sTable.Rated_Power_kW(string(sTable.Country) == string(countries.Country(i))))/1000000;
end

% Define list of projects within canada
canada = sTable(contains(sTable.Country,'Canada','IgnoreCase',true),{'Rated_Power_kW','Latitude','Longitude','PumpedHydro','CompressedAir','FlyWheel','Thermal','Battery'});

% Define installed capacity of technologies by year
technologies = array2table(unique(year(sTable.Commissioned)),'VariableNames',{'Year'});

for i = 1:height(technologies)
    technologies.PumpedHydro(i)   = sum(sTable.Rated_Power_kW(sTable.PumpedHydro & year(sTable.Commissioned)==technologies.Year(i)))/1000;
    technologies.CompressedAir(i) = sum(sTable.Rated_Power_kW(sTable.CompressedAir & year(sTable.Commissioned)==technologies.Year(i)))/1000;
    technologies.FlyWheel(i)      = sum(sTable.Rated_Power_kW(sTable.FlyWheel & year(sTable.Commissioned)==technologies.Year(i)))/1000;
    technologies.Thermal(i)       = sum(sTable.Rated_Power_kW(sTable.Thermal & year(sTable.Commissioned)==technologies.Year(i)))/1000;
    technologies.Battery(i)       = sum(sTable.Rated_Power_kW(sTable.Battery & year(sTable.Commissioned)==technologies.Year(i)))/1000;
    technologies.Other(i)         = sum(sTable.Rated_Power_kW(sTable.Other & year(sTable.Commissioned)==technologies.Year(i)))/1000;
    technologies.All(i)           = sum(sTable.Rated_Power_kW(year(sTable.Commissioned)==technologies.Year(i)))/1000;
end

% Define cummulative capacity by technology
technologies.PumpedHydroSum   = cumsum(technologies.PumpedHydro);
technologies.CompressedAirSum = cumsum(technologies.CompressedAir);
technologies.FlyWheelSum      = cumsum(technologies.FlyWheel);
technologies.ThermalSum       = cumsum(technologies.Thermal);
technologies.BatterySum       = cumsum(technologies.Battery);
technologies.OtherSum         = cumsum(technologies.Other);

% Plot stacked area of storage capacity (top) and bar chart of total yearly
% capacity (bottom)

% Matrices for plotting
plotSum     = table2array(technologies(:,{'PumpedHydroSum','ThermalSum','BatterySum','FlyWheelSum','CompressedAirSum','OtherSum'}));
plotNoHydro = table2array(technologies(:,{'ThermalSum','BatterySum','FlyWheelSum','CompressedAirSum','OtherSum'}));
plotBar     = table2array(technologies(:,{'PumpedHydro','Thermal','Battery','FlyWheel','CompressedAir','Other'}));
plotBarNoHydro = table2array(technologies(:,{'Thermal','Battery','FlyWheel','CompressedAir','Other'}));

% Figure 1 - Capacity by technology/year
fig = figure(1);
set(gcf,'Units','inches','Position',[1 1 6.75 4]); % [xpos ypos width height]
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',10);
sub1 = subplot(2,1,1);
a1 = area(technologies.Year,plotSum./1000,'EdgeColor','none');
    a1(1).FaceColor = 0.9*[1 1 1];
    a1(2).FaceColor = 0.75*[1 1 1];
    a1(3).FaceColor = 0.6*[1 1 1];
    a1(4).FaceColor = 0.45*[1 1 1];
    a1(5).FaceColor = 0.3*[1 1 1];
    a1(6).FaceColor = 0*[1 1 1];
title('\textbf{Cumulative Capacity}','FontSize',10);
yticks(0:50:200);
yticklabels({0 [] 100 [] 200});
xlim([1900 2021]);
xticks(1920:20:2020);
leg1 = legend(fliplr(a1),'Other','Compressed Air','Fly Wheel','Battery','Thermal','Pumped Hydro','Location','EastOutside','Interpreter','Latex','FontSize',9);
leg1.Position(2) = 0.375;
box(leg1,'off');
savePos = sub1.Position; % Save subplot position with legend in place
axes('position',[0.175,0.675,0.25,0.19]);
a2 = area(technologies.Year,plotNoHydro./1000,'EdgeColor','none');
    a2(1).FaceColor = a1(2).FaceColor;
    a2(2).FaceColor = a1(3).FaceColor;
    a2(3).FaceColor = a1(4).FaceColor;
    a2(4).FaceColor = a1(5).FaceColor;
    a2(5).FaceColor = a1(6).FaceColor;
box(gca,'off')
xlim([1975 2021]);
ylim([0 6.5]);
yticks(2:2:6);
ttl = title('\textbf{Excluding Hydro}','FontSize',9);
ttl.Position(2) = ttl.Position(2) - 1;
ttl.Position(1) = ttl.Position(1) - 2;
sub2 = subplot(2,1,2);
b1 = bar(technologies.Year,plotBar./1000,1,'Stacked','EdgeColor','none');
    b1(1).FaceColor = a1(1).FaceColor;
    b1(2).FaceColor = a1(2).FaceColor;
    b1(3).FaceColor = a1(3).FaceColor;
    b1(4).FaceColor = a1(4).FaceColor;
    b1(5).FaceColor = a1(5).FaceColor;
    b1(6).FaceColor = a1(6).FaceColor;
title('\textbf{New Capacity}','FontSize',10);
yticks(0:2.5:10);
yticklabels({0 [] 5 [] 10});
xlim([1900 2021]);
xticks(1920:20:2020);
xlabel('Year','FontSize',11);
leg2 = legend('New Capacity','Location','EastOutside','Interpreter','Latex','FontSize',9);
set(leg2,'Visible','off');
axes('position',[0.175,0.22,0.25,0.19]);
b2 = bar(technologies.Year,plotBarNoHydro./1000,1,'Stacked','EdgeColor','none');
    b2(1).FaceColor = a1(2).FaceColor;
    b2(2).FaceColor = a1(3).FaceColor;
    b2(3).FaceColor = a1(4).FaceColor;
    b2(4).FaceColor = a1(5).FaceColor;
    b2(5).FaceColor = a1(6).FaceColor;
box(gca,'off')
xlim([1975 2021]);
ylim([0 1.05]);
yticks(0:0.25:1);
yticklabels({0 [] 0.5 [] 1});
ttl2 = title('\textbf{Excluding Hydro}','FontSize',9);
ttl2.Position(2) = ttl2.Position(2)-0.2;
ttl2.Position(1) = ttl2.Position(1)-2;

% Give common xlabel, ylabel to figure
han=axes(fig,'visible','off'); 
han.YLabel.Visible='on';
ylabel(han,'Installed Capacity (GW)','FontSize',11);

% Fix subplot positions
sub1.Position    = savePos;
sub2.Position(3) = sub1.Position(3);

% Find country with maximum capacity to normalize colour scale
maxStorage = max(countries.CapacityGW);
clr        = [1 1 1];

% Figure 2 - capacity by country
figure(2)
set(gcf,'Units','inches','Position',[1.875,3,6.75,5.65]); % [xpos ypos width height]
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',10);
% Plot all countries with light grey outline
bordersm('countries','color',[0.8 0.8 0.8]); hold on
% Plot countries with storage, fill colour based on amount
for i = 1:height(countries)
    try
        bordersm(string(countries.Country(i)),'facecolor',(1-countries.CapacityGW(i)/maxStorage).*clr);
    catch
        continue
    end
end
mlabel off; plabel off; gridm off

% Dummy plots for legend entry
dummy1 = plot(0,0,'k-');
dummy2 = plot(0,0,'-','color',[0.8 0.8 0.8]);
hold off

% Add colour bar
clr = colorbar;
clr.Location = 'southoutside';
clr.Position = clr.Position + [0.4 -0.0665 -0.5 -0.0125]; % [xpos ypos width height]
clr.FontSize = 10;
clr.Label.Interpreter = 'latex';
clr.Label.String = '\textbf{National Installed Storage Capacity (GW)}';
clr.Label.FontSize = 10;
clr.Label.Position(2) = clr.Position(2)+ 2;
clr.TickLabelInterpreter = 'latex';
clr.Ticks = 0:0.25:1;
clr.TickLabels = [0 round(0.25*maxStorage,0) round(0.5*maxStorage,0) round(0.75*maxStorage,0) ceil(maxStorage)];
colormap(flipud(gray));
leg = legend([dummy1 dummy2],'True','False','Location','SouthOutside','Interpreter','Latex','FontSize',10);
title(leg,'\textbf{Existing Storage Projects}','Interpreter','Latex','FontSize',10);
legend box off
leg.Position = leg.Position + [-0.175 -0.05 0 0];

% Figure 3 - canada's storage fleet
figure(3)
set(gcf,'Units','inches','Position',[1.875,3,6.75,5.65]); % [xpos ypos width height]
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',10);

% Load in map of canada and remove lat long label
subplot(2,3,[1 2 4 5]);
bordersm('canada','edgecolor','k','facecolor','w'); hold on
mlabel off; plabel off; gridm off; framem off;

% Plot storage projects by technology (symbol) and capacity (color/size)
for i = 1:height(canada)
    temp = geoshow(canada.Latitude(i),canada.Longitude(i),'DisplayType','Point','MarkerEdgeColor','k');
    if canada.Rated_Power_kW(i) < 1000
        temp.MarkerFaceColor = [0.8 0.8 0.8];
        temp.MarkerSize = 4;
    elseif canada.Rated_Power_kW(i) < 2000
        temp.MarkerFaceColor = [0.6 0.6 0.6];
        temp.MarkerSize = 4;
    elseif canada.Rated_Power_kW(i) < 5000
        temp.MarkerFaceColor = [0.4 0.4 0.4];
        temp.MarkerSize = 4;
    else % >= 5000
        temp.MarkerFaceColor = [0 0 0];
        temp.MarkerSize = 4;
    end   
    if canada.PumpedHydro(i) > 0
        temp.Marker = 'o';
    elseif canada.Thermal(i) > 0
        temp.Marker = 's';
    elseif canada.Battery(i) > 0
        temp.Marker = 'd';
    elseif canada.FlyWheel(i) > 0
        temp.Marker = '>';
    else % Compressed Air
        temp.Marker = 'p';
    end    
end
% Add cicle around cluttered ontario region
geoshow(43.151,-81.057,'DisplayType','Point','Marker','o','MarkerEdgeColor','k','MarkerSize',60);

% Dummy plots for legend
p1 = plot(0,0,'o','MarkerFaceColor','w','Color','k');
p2 = plot(0,0,'s','MarkerFaceColor','w','Color','k');
p3 = plot(0,0,'d','MarkerFaceColor','w','Color','k');
p4 = plot(0,0,'>','MarkerFaceColor','w','Color','k');
p5 = plot(0,0,'p','MarkerFaceColor','w','Color','k');
b1 = bar(0,0,'FaceColor',[0.8 0.8 0.8]);
b2 = bar(0,0,'FaceColor',[0.6 0.6 0.6]);
b3 = bar(0,0,'FaceColor',[0.4 0.4 0.4]);
b4 = bar(0,0,'FaceColor',[0 0 0]);
b1.BaseLine.Visible = 'off';
axis off
leg1 = legend([p1 p2 p3 p4 p5 b1 b2 b3 b4],'Pumped Hydro','Thermal','Battery','Fly Wheel','Compressed Air','$<$1 MW','$<$2 MW','$<$5 MW','$\geq$5 MW','Location','NorthEast','NumColumns',2,'Interpreter','Latex');
box(leg1,'off');

% Plot ontario on it's own to show crowded area
subplot(2,3,[3 6])
% Load in Canada from worldmap, define coastlines and province boundaries
ax = worldmap('Canada');
provinces = shaperead('provinces','UseGeoCoords',true);
ontario = provinces([3,end],:);
framem('off');
gridm('off');
mlabel('off');
plabel('off');
% Define facecolors
geoshow(ax,ontario,'DisplayType','polygon','FaceColor','w');

% Add same circle to ontario plot
geoshow(43.151,-81.057,'DisplayType','Point','Marker','o','MarkerEdgeColor','k','MarkerSize',150);
% Plot storage projects by technology (symbol) and capacity (color/size)
for i = 1:height(canada)
    temp = geoshow(canada.Latitude(i),canada.Longitude(i),'DisplayType','Point','MarkerEdgeColor','k');
    if canada.Rated_Power_kW(i) < 1000
        temp.MarkerFaceColor = [0.8 0.8 0.8];
        temp.MarkerSize = 4;
    elseif canada.Rated_Power_kW(i) < 2000
        temp.MarkerFaceColor = [0.6 0.6 0.6];
        temp.MarkerSize = 4;
    elseif canada.Rated_Power_kW(i) < 5000
        temp.MarkerFaceColor = [0.4 0.4 0.4];
        temp.MarkerSize = 4;
    else % >= 5000
        temp.MarkerFaceColor = [0 0 0];
        temp.MarkerSize = 4;
    end   
    if canada.PumpedHydro(i) > 0
        temp.Marker = 'o';
    elseif canada.Thermal(i) > 0
        temp.Marker = 's';
    elseif canada.Battery(i) > 0
        temp.Marker = 'd';
    elseif canada.FlyWheel(i) > 0
        temp.Marker = '>';
    else % Compressed Air
        temp.Marker = 'p';
    end    
end







