function build_per_province
% build_per_province - Generates plot of cumulative capacity of wind power
% built in Canada over time, split by province
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
% Data files required: build_per_province.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% May 2020; Last revision: 08-May-2020
%------------- BEGIN CODE --------------

% Read in .csv datafile, extract data, close table
data   = readtable('build_per_province.csv');
yr     = data.Year;
ab     = data.AB;
bc     = data.BC;
mb     = data.MB;
nb     = data.NB;
nl     = data.NL;
ns     = data.NS;
on     = data.ON;
pei    = data.PEI;
qc     = data.QC;
sk     = data.SK;
clear data

% Sort all data by date
[yr,idx]   = sort(yr);
ab         = ab(idx,:);
bc         = bc(idx,:);
mb         = mb(idx,:);
nb         = nb(idx,:);
nl         = nl(idx,:);
ns         = ns(idx,:);
on         = on(idx,:);
pei        = pei(idx,:);
qc         = qc(idx,:);
sk         = sk(idx,:);

% Combine provinces for brevity
ac    = nl+nb+pei+ns;   % Atlantic Canada (maritimes)
ep    = sk+mb;          % Eastern Praries

% Generate matrix for stacked area plotting
stack = [ac qc on ep ab bc];

% Define tile of set size for plotting
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 4 3.5]; % [xpos ypos width height]
nexttile;

% Generate stacked area plot:
%    x-axis = year
%    y-axis = rating
%    color  = province
fig1 = area(yr,stack/1000,'EdgeColor',[1 1 1]);
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',11);
xlabel('Year','FontSize',12);
ylabel('Installed Capacity (GW)','FontSize',12);
%title('Cumulative Installed Wind Capacity');
l = legend(fliplr(fig1),'BC','AB','SK+MB','ON','QC','ATL',...
    'location','northwest','FontSize',11);
legend boxoff;
set(l,'Interpreter','latex');
xlim([1998 2019]);
xticks([1999 2004 2009 2014 2019]);
xticklabels({1999 2004 2009 2014 2019});

% Loop through and set colormap to greyscale
clr = [1 1 1];
for i = 1:6
    fig1(i).FaceColor = clr;
    clr = clr - [1/5 1/5 1/5];
end

% Add border to white
fig1(1).EdgeColor = [0.5 0.5 0.5];