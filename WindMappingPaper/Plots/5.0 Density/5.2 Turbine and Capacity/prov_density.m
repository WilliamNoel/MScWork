function prov_density
% prov_density - Generates plot of the infrastructure density per province 
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
% Data files required: prov_density.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% May 2020; Last revision: 09-July-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data   = readtable('prov_density.csv');
capac  = data.CapacityDensity;
turbn  = data.TurbineDensity;
yr     = data.Year;
clear data

% Find max and min for each year
unique_yr    = unique(yr);            % Years where new turbines built
n            = length(unique_yr);     % Number of unique years
capac_75    = ones(n,1);              % Initialize vector size
capac_25    = ones(n,1);
capac_md    = ones(n,1);
capac_mx    = ones(n,1);
capac_mn    = ones(n,1);
turbn_75    = ones(n,1);
turbn_md    = ones(n,1);
turbn_25    = ones(n,1);
turbn_mx    = ones(n,1);
turbn_mn    = ones(n,1);

for i = 1:1:n
    idx = find(yr==unique_yr(i));
    % max/min/quartiles/median
    capac_75(i) = prctile(capac(idx),75);
    capac_25(i) = prctile(capac(idx),25);
    capac_md(i) = median(capac(idx));
    capac_mx(i) = max(capac(idx));
    capac_mn(i) = min(capac(idx));
    turbn_75(i) = prctile(turbn(idx),75);
    turbn_25(i) = prctile(turbn(idx),25);
    turbn_md(i) = median(turbn(idx));
    turbn_mx(i) = max(turbn(idx));
    turbn_mn(i) = min(turbn(idx));
end

set(gcf,'DefaultAxesTickLabelInterpreter','latex');

% Generate scatter plot:
%    x-axis = year
%    y-axis = density
%    size   = constant
%    shape  = province

ax1 = subplot(2,1,1);
area(unique_yr(2:21),capac_75(2:21),'EdgeColor','none','FaceColor',[0.5 0.5 0.5]); hold on
area(unique_yr(2:21),capac_25(2:21),'EdgeColor','none','FaceColor','w');
plot(unique_yr(2:21),capac_md(2:21),'k-',...
    unique_yr(2:21),capac_mx(2:21),'kx',...
    unique_yr(2:21),capac_mn(2:21),'k*'); hold off
set(ax1,'FontSize',11);
xlim([1998 2020]);
ylim([0 9]);
xticks([1999 2004 2009 2014 2019]);
ylabel('Capacity density (MW/km$^2$)','Interpreter','latex','FontSize',12);

ax2 = subplot(2,1,2);
h1 = area(unique_yr(2:21),turbn_75(2:21),'EdgeColor','none','FaceColor',[0.5 0.5 0.5]); hold on
area(unique_yr(2:21),turbn_25(2:21),'EdgeColor','none','FaceColor','w');
h3 = plot(unique_yr(2:21),turbn_md(2:21),'k-',...
    unique_yr(2:21),turbn_mx(2:21),'kx',...
    unique_yr(2:21),turbn_mn(2:21),'k*'); hold off
set(ax2,'FontSize',11);
legend([h1 h3(1) h3(2) h3(3)],'IQR','Median','Max','Min','Interpreter',...
    'latex','FontSize',11);
legend boxoff
xlim([1998 2020]);
ylim([0 8]);
xticks([1999 2004 2009 2014 2019]);
ylabel('Turbine density (turbine/km$^2$)','Interpreter','latex','FontSize',12);

set(gcf,'Units','inches','Position',[1 1 7.5 6]); % [xpos ypos width height]