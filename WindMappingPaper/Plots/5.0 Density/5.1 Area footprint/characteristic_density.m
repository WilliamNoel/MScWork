function characteristic_density
% characteristic_density - Generates plot of the capacity density versus 
% a characteristic density based on farm area and distance btwn turbines
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
% Data files required: characteristic_density.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% May 2020; Last revision: 09-July-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data   = readtable('characteristic_density.csv');
prov   = data.Province;
capc   = data.Capacity;
yr     = data.Year;
foot   = data.Area;
clear data

% Split into Provincial data

% Alberta
AB_idx = find(contains(prov,'AB'));
AB_cap = capc(AB_idx);
AB_yr  = yr(AB_idx);
AB_ftp = foot(AB_idx);

% British Columbia
BC_idx = find(contains(prov,'BC'));
BC_cap = capc(BC_idx);
BC_yr  = yr(BC_idx);
BC_ftp = foot(BC_idx);

% Manitoba
MB_idx = find(contains(prov,'MB'));
MB_cap = capc(MB_idx);
MB_yr  = yr(MB_idx);
MB_ftp = foot(MB_idx);

% New Brunswick
NB_idx = find(contains(prov,'NB'));
NB_cap = capc(NB_idx);
NB_yr  = yr(NB_idx);
NB_ftp = foot(NB_idx);

% Newfoundland
NL_idx = find(contains(prov,'NL'));
NL_cap = capc(NL_idx);
NL_yr  = yr(NL_idx);
NL_ftp = foot(NL_idx);

% Nova scotia
NS_idx = find(contains(prov,'NS'));
NS_cap = capc(NS_idx);
NS_yr  = yr(NS_idx);
NS_ftp = foot(NS_idx);

% Ontario
ON_idx = find(contains(prov,'ON'));
ON_cap = capc(ON_idx);
ON_yr  = yr(ON_idx);
ON_ftp = foot(ON_idx);

% Prince Edward Island
PEI_idx = find(contains(prov,'PEI'));
PEI_cap = capc(PEI_idx);
PEI_yr  = yr(PEI_idx);
PEI_ftp = foot(PEI_idx);

% Quebec
QC_idx = find(contains(prov,'QC'));
QC_cap = capc(QC_idx);
QC_yr  = yr(QC_idx);
QC_ftp = foot(QC_idx);

% Saskatchewan
SK_idx = find(contains(prov,'SK'));
SK_cap = capc(SK_idx);
SK_yr  = yr(SK_idx);
SK_ftp = foot(SK_idx);

% Combine eastern praries and atlantic canada

% Eastern Praries
EP_cap = [MB_cap;SK_cap];
EP_yr  = [MB_yr;SK_yr];
EP_ftp = [MB_ftp;SK_ftp];

% Atlantic Canada
AC_cap = [NB_cap;NL_cap;NS_cap;PEI_cap];
AC_yr  = [NB_yr;NL_yr;NS_yr;PEI_yr];
AC_ftp = [NB_ftp;NL_ftp;NS_ftp;PEI_ftp];

% Generate plot:
%    x-axis = year
%    y-axis = area
%    size   = capacity

ax1 = subplot(3,2,1);
scatter(BC_yr,BC_ftp,BC_cap,'MarkerEdgeColor','k');
set(ax1,'FontSize',11);
title('BC','Interpreter','latex','FontSize',12);
ylabel('Area Footprint (km$^2$)','Interpreter','latex','FontSize',12);
ylim([0 300]);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);

ax2 = subplot(3,2,2);
scatter(AB_yr,AB_ftp,AB_cap,'MarkerEdgeColor','k');
set(ax2,'FontSize',11);
title('AB','Interpreter','latex','FontSize',12);
ylim([0 300]);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);

ax3 = subplot(3,2,3); 
scatter(EP_yr,EP_ftp,EP_cap,'MarkerEdgeColor','k');
set(ax3,'FontSize',11);
title('SK+MB','Interpreter','latex','FontSize',12);
ylabel('Area Footprint (km$^2$)','Interpreter','latex','FontSize',12)
ylim([0 300]);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);

ax4 = subplot(3,2,4);
scatter(ON_yr,ON_ftp,ON_cap,'MarkerEdgeColor','k');
set(ax4,'FontSize',11);
title('ON','Interpreter','latex','FontSize',12);
ylim([0 300]);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);

ax5 = subplot(3,2,5);
scatter(QC_yr,QC_ftp,QC_cap,'MarkerEdgeColor','k');
set(ax5,'FontSize',11);
title('QC','Interpreter','latex','FontSize',12);
ylabel('Area Footprint (km$^2$)','Interpreter','latex','FontSize',12)
xlabel('Year','Interpreter','latex','FontSize',12);
ylim([0 300]);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);

ax6 = subplot(3,2,6);
scatter(AC_yr,AC_ftp,AC_cap,'MarkerEdgeColor','k');
set(ax6,'FontSize',11);
title('ATL','Interpreter','latex','FontSize',12);
xlabel('Year','Interpreter','latex','FontSize',12);
ylim([0 300]);
xlim([1998 2020]);
xticks([1999 2004 2009 2014 2019]);

% Window size
set(gcf,'Units','inches','Position',[1 1 7.5 6]); % [xpos ypos width height]

% Add text labels to provide scale
set(gcf,'DefaultTextInterpreter','latex');
lbl_1 = sprintf('%3.0f MW\n',AB_cap(2));
lbl_2 = sprintf('%3.0f MW\n',AB_cap(22));
subplot(3,2,2);
text(AB_yr(2),AB_ftp(2)+30,lbl_1,'HorizontalAlignment','center');
text(AB_yr(22),AB_ftp(22)+40,[lbl_2 '$\downarrow$'],'HorizontalAlignment','center');
