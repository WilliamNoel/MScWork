function average_sz
% average_sz - Generates areaplot of average wind farm size built in Canada
% per year
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
% Data files required: average_sz.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% June 2020; Last revision: 08-July-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data   = readtable('average_sz.csv');
yr1    = data.Year;
capac  = data.Capacity;
clear data

data   = readtable('turbine_data.csv');
yr2    = data.Year;
rating = data.Rating;
clear data

% Find max and min for each year
unique_yr   = unique(yr1);            % Years where new turbines built
n           = length(unique_yr);      % Number of unique years
capac_75    = ones(n,1);              % Initialize vector size
capac_25    = ones(n,1);
capac_md    = ones(n,1);
capac_mx    = ones(n,1);

for i = 1:1:n
    idx = find(yr1==unique_yr(i));
    % max/min/quartiles/median
    capac_75(i) = prctile(capac(idx),75);
    capac_25(i) = prctile(capac(idx),25);
    capac_md(i) = median(capac(idx));
    capac_mx(i) = max(capac(idx));
end

set(gcf,'DefaultAxesTickLabelInterpreter','latex');

% Create area plot
ax1 = subplot(2,1,1);
h1 = area(unique_yr(5:25),capac_75(5:25),'EdgeColor','none',...
    'FaceColor',[0.5 0.5 0.5]); hold on
area(unique_yr(5:25),capac_25(5:25),'EdgeColor','none','FaceColor','w');
h3 = plot(unique_yr(5:25),capac_md(5:25),'k-',...
    unique_yr(5:25),capac_mx(5:25),'kx'); hold off
set(ax1,'FontSize',11);
% Axis label/limits
xlim([1998 2020]);
ylim([0 400]);
xticks([1999 2004 2009 2014 2019]);
ylabel('Farm Capacity (MW)','Interpreter','latex','FontSize',12);
legend([h1 h3(1) h3(2)],'IQR','Median','Max','Interpreter','latex',...
    'FontSize',11,'Location','northwest');
legend boxoff

% Find capacity for each year
unique_year  = unique(yr2);            % Years where new turbines built
n            = length(unique_year);    % Number of unique years
inst_capac   = ones(n,1);              % Initialize vector size

for i = 1:1:n
    idx = find(yr2==unique_year(i));
    inst_capac(i) = sum(rating(idx));
end

%Plot total installed capacity
h2 = subplot(2,1,2);
bar(unique_year,inst_capac./1000,'FaceColor','w','EdgeColor','k');
set(h2,'FontSize',11);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);
ylim([0 2200]);
ylabel('National Installed Capacity (MW)','Interpreter','latex',...
    'FontSize',12);
xlabel('Year','Interpreter','latex','FontSize',12);

% Window size
set(gcf,'Units','inches','Position',[1 1 7.5 5]); % [xpos ypos width height]






