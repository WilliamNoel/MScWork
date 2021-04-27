function mfcr_builds
% bfcr_builds - Generates plot of wind turbine Capacity in Canada
% per manufacturer
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
% Data files required: mfcr_builds.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% May 2020; Last revision: 09-July-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data    = readtable('mfcr_builds.csv');
prov    = data.Province;
yr      = data.Year;
vestas  = data.Vestas;
ge      = data.GE;
siemens = data.Siemens;
enercon = data.Enercon;
senvion = data.Senvion;
other   = data.Other;
clear data

% Find indices for each province
AB_idx  = find(contains(prov,'AB'));
BC_idx  = find(contains(prov,'BC'));
ON_idx  = find(contains(prov,'ON'));
QC_idx  = find(contains(prov,'QC'));
AC_idx  = find(contains(prov,'AC'));
EP_idx  = find(contains(prov,'EP'));

% Generate stacks for plotting
vest_stack = [vestas(AC_idx) vestas(QC_idx) vestas(ON_idx) ...
    vestas(EP_idx) vestas(AB_idx) vestas(BC_idx)];

ge_stack   = [ge(AC_idx) ge(QC_idx) ge(ON_idx) ...
    ge(EP_idx) ge(AB_idx) ge(BC_idx)];

siem_stack = [siemens(AC_idx) siemens(QC_idx) siemens(ON_idx) ...
    siemens(EP_idx) siemens(AB_idx) siemens(BC_idx)];

ener_stack = [enercon(AC_idx) enercon(QC_idx) enercon(ON_idx) ...
    enercon(EP_idx) enercon(AB_idx) enercon(BC_idx)];

senv_stack = [senvion(AC_idx) senvion(QC_idx) senvion(ON_idx) ...
    senvion(EP_idx) senvion(AB_idx) senvion(BC_idx)];

% othr_stack = [other(AC_idx) other(QC_idx) other(ON_idx) ...
%     other(EP_idx) other(AB_idx) other(BC_idx)];

% Generate stacked area plot:
%    x-axis = year
%    y-axis = rating
%    color  = province

set(groot,'DefaultAxesTickLabelInterpreter','latex');

ax1 = subplot(3,2,1);
fig1 = area(yr(1:25),vest_stack,'EdgeColor','w','LineWidth',0.25);
set(ax1,'FontSize',11);
title('Vestas','Interpreter','latex','FontSize',12);
xlim([1998 2019]);
ylim([0 4000]);
xticks([1999 2004 2009 2014 2019]);
yticks([0 1000 2000 3000 4000]);
yticklabels({0 [] 2000 [] 4000})
ylabel('Installed Capacity (MW)','Interpreter','latex','FontSize',12);

ax2 = subplot(3,2,2);
fig2 = area(yr(1:25),ge_stack,'EdgeColor','w','LineWidth',0.25);
set(ax2,'FontSize',11);
title('GE','Interpreter','latex','FontSize',12);
xlim([1998 2019]);
ylim([0 4000]);
xticks([1999 2004 2009 2014 2019]);
yticks([0 1000 2000 3000 4000]);
yticklabels({0 [] 2000 [] 4000})

ax3 = subplot(3,2,3);
fig3 = area(yr(1:25),siem_stack,'EdgeColor','w','LineWidth',0.25);
set(ax3,'FontSize',11);
title('Siemens','Interpreter','latex','FontSize',12);
xlim([1998 2019]);
ylim([0 4000]);
xticks([1999 2004 2009 2014 2019]);
yticks([0 1000 2000 3000 4000]);
yticklabels({0 [] 2000 [] 4000})
ylabel('Installed Capacity (MW)','Interpreter','latex','FontSize',12);

ax4 = subplot(3,2,4);
fig4 = area(yr(1:25),ener_stack,'EdgeColor','w','LineWidth',0.25);
set(ax4,'FontSize',11);
title('ENERCON','Interpreter','latex','FontSize',12);
xlabel('Year','Interpreter','latex','FontSize',12);
xlim([1998 2019]);
ylim([0 4000]);
yticks([0 1000 2000 3000 4000]);
yticklabels({0 [] 2000 [] 4000})
xticks([1999 2004 2009 2014 2019]);

ax5 = subplot(3,2,5);
fig5 = area(yr(1:25),senv_stack,'EdgeColor','w','LineWidth',0.25);
set(ax5,'FontSize',11);
title('Senvion','Interpreter','latex','FontSize',12);
xlim([1998 2019]);
ylim([0 4000]);
xticks([1999 2004 2009 2014 2019]);
yticks([0 1000 2000 3000 4000]);
yticklabels({0 [] 2000 [] 4000})
xlabel('Year','Interpreter','latex','FontSize',12);
ylabel('Installed Capacity (MW)','Interpreter','latex','FontSize',12);
legend(fliplr(fig5),'BC','AB','SK+MB','ON','QC','ATL',...
    'Location','NorthWest','Interpreter','latex','FontSize',11,...
    'Position',[0.6383 0.1791 0.2033 0.086]);
legend boxoff;

% subplot(3,2,6);
% fig6 = area(yr(1:25),othr_stack,'Edgecolor','w','LineWidth',0.25);
% title('Other','Interpreter','latex','FontSize',12);
% xlim([1998 2019]);
% ylim([0 4000]);
% xticks([1999 2004 2009 2014 2019]);
% yticks([0 1000 2000 3000 4000]);
% yticklabels({0 [] 2000 [] 4000})
% xlabel('Year','Interpreter','latex','FontSize',12);

% Loop through and set colormap to greyscale
clr = [1 1 1];
for i = 1:6
    fig1(i).FaceColor = clr;
    fig2(i).FaceColor = clr;
    fig3(i).FaceColor = clr;
    fig4(i).FaceColor = clr;
    fig5(i).FaceColor = clr;
%   fig6(i).FaceColor = clr;
    clr = clr - 1/5;
end

fig5(1).EdgeColor = [0.5 0.5 0.5];

% Window size
set(gcf,'Units','inches','Position',[1 1 7.5 7]); % [xpos ypos width height]