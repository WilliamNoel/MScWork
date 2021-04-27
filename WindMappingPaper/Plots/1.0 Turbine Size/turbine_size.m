function turbine_size
% turbine_size - Generates plot of the size of Canadian wind turbines over
% time
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
% Data files required: turbine_data.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% May 2020; Last revision: 09-July-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data   = readtable('turbine_data.csv');
year   = data.Year;
height = data.Height;
diamtr = data.Diameter;
rating = data.Rating;
clear data

% Find average height and diamtr for each year
unique_year = unique(year);            % Years where new turbines built
n            = length(unique_year);    % Number of unique years
avg_height   = ones(n,1);              % Initialize vector size
avg_diamtr   = ones(n,1);
avg_capac    = ones(n,1);

for i = 1:1:n
    idx = find(year==unique_year(i));
    % Averages
    avg_height(i) = mean(height(idx));
    avg_diamtr(i) = mean(diamtr(idx));
    avg_capac(i)  = mean(rating(idx));
end

% Flip vectors so smaller bubbles aren't hidden by larger ones
unique_year = flipud(unique_year);
avg_height  = flipud(avg_height);
avg_diamtr  = flipud(avg_diamtr);
avg_capac   = flipud(avg_capac);

% Generate scatter plot:
%    x-axis = year
%    y-axis = height
%    size   = diameter
%    color  = rating
h = scatter(unique_year,avg_height,1,avg_capac./1000,'Filled',...
    'MarkerEdgeColor','k');
box on;
% Axes labels and limits
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',11);
ylabel('Annual Average Hub Height (m)','Interpreter','latex','FontSize',12);
xlabel('Year','Interpreter','latex','FontSize',12);
xlim([1990 2027]);
ylim([0 200]);
xticks([1994 1999 2004 2009 2014 2019]);
% Window size
set(gcf,'Units','inches','Position',[1 1 7.5 3.5]); % [xpos ypos width height]
% Colorbar
clr = colorbar;
clr.Location = 'South';
clr.FontSize = 11;
clr.Label.Interpreter = 'latex';
clr.TickLabelInterpreter = 'latex';
clr.Position = [0.175 0.8 0.33 0.02]; % [xpos ypos width height] 
clr.Label.String = 'Average Turbine Capacity (MW)';
set(clr, 'YAxisLocation','bottom') % tick labels to bottom
clr.Label.Position = [1.8 3.25 0];
colormap(gray);
caxis([0 4]);

% Obtain the axes units to scale bubble size
currentunits = get(gca,'Units');
set(gca, 'Units', 'Points');
axpos = get(gca,'Position');
set(gca, 'Units', currentunits);
markerWidth = avg_diamtr./diff(ylim)*axpos(4);
set(h,'SizeData', 0.25.*pi.*markerWidth.^2);

% Label two of the bubbles for scale
lbl_1 = sprintf('%2.0f m,\n h = %2.0f m',avg_diamtr(n-1),avg_height(n-1));
lbl_n = sprintf('%3.0f m,\n h = %2.0f m',avg_diamtr(1),avg_height(1));
text(unique_year(n-1),avg_height(n-1)+avg_diamtr(n-1)/1.4,...
    ['$\oslash$ ' lbl_1],'FontSize',11,'HorizontalAlignment','center');
text(unique_year(1),avg_height(1)+avg_diamtr(1)/1.8,...
    ['$\oslash$ ',lbl_n],'FontSize',11,'HorizontalAlignment','center');
