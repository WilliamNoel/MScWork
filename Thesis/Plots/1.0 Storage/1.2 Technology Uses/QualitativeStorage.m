function QualitativeStorage
% QualitativeStorage - Plots qualitative ranges of storage technologies
% based on their application in power systems
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
% Data files required:
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% April 2021; Last revision: 07-Apr-2021
%------------- BEGIN CODE --------------

% Define patches for power quality, grid support, and bulk power management
pQualityx = [0 1 1 0]; pQualityy = [0 0 3 3]; pQualityc = [0.9 0.9 0.9];
gSupportx = [1 2 2 1]; gSupporty = [0 0 3 3]; gSupportc = [0.8 0.8 0.8];
bPManagex = [2 3 3 2]; bPManagey = [0 0 3 3]; bPManagec = [0.65 0.65 0.65];

% Plot patch ranges
patch(pQualityx,pQualityy,pQualityc);
patch(gSupportx,gSupporty,gSupportc);
patch(bPManagex,bPManagey,bPManagec);

% Define xticks and yticks
set(gca,'TickLabelInterpreter','Latex')
xticks(0:1:3); xticklabels({'1 kW' '100 kW' '10 MW' '1 GW'});
yticks(0:0.5:3); yticklabels({[] 'Seconds' 'Minutes' 'Hours' 'Days' 'Weeks' 'Months'});

% Add lables to each region
text(0.13,3.1,'\textbf{Power Quality}','Interpreter','Latex','FontSize',10.5);
text(1.145,3.1,'\textbf{Grid Support}','Interpreter','Latex','FontSize',10.5);
text(2.03,3.1,'\textbf{Power Management}','Interpreter','Latex','FontSize',10.5);

% Define patches and labels for each technology
batteryx = [0.5 2.5 2.5 0.5]; batteryy = [0.5 0.5 1.75 1.75];
patch(batteryx,batteryy,'w','FaceAlpha',0.8);
text(mean(batteryx),mean(batteryy),{'Battery'},'Interpreter','Latex','HorizontalAlignment','center');

hydrogenx = [1.5 2.5 2.5 1.5]; hydrogeny = [1.5 1.5 3 3];
patch(hydrogenx,hydrogeny,'w','FaceAlpha',0.8);
text(mean(hydrogenx),max(hydrogeny)-0.25,{'Hydrogen';'\& Fuel Cell'},'Interpreter','Latex','HorizontalAlignment','center');

flowBatx = [1 2.1 2.1 1]; flowBaty = [1.5 1.5 2.6 2.6];
patch(flowBatx,flowBaty,'w','FaceAlpha',0.8);
text(mean(flowBatx),mean(flowBaty),{'Flow Battery'},'Interpreter','Latex','HorizontalAlignment','center');

pumpedHydrox = [2.5 3 3 2.5]; pumpedHydroy = [2 2 2.5 2.5];
patch(pumpedHydrox,pumpedHydroy,'w','FaceAlpha',0.8);
text(mean(pumpedHydrox),mean(pumpedHydroy),{'Pumped';'Hydro'},'Interpreter','Latex','HorizontalAlignment','center');

compAirx = [2.25 2.76 2.76 2.25]; compAiry = [1.5 1.5 2 2];
patch(compAirx,compAiry,'w','FaceAlpha',0.8);
text(mean(compAirx),mean(compAiry),{'Compressed';'Air'},'Interpreter','Latex','HorizontalAlignment','center');

flywheelx = [0 2.05 2.05 0]; flywheely = [0.1 0.1 1 1]; 
patch(flywheelx,flywheely,'w','FaceAlpha',0.8);
text(mean(flywheelx),max(flywheely)-0.15,{'Flywheel'},'Interpreter','Latex','HorizontalAlignment','center');

magnetx = [1.5 2.175 2.175 1.5]; magnety = [0 0 0.75 0.75]; 
patch(magnetx,magnety,'w','FaceAlpha',0.8);
text(mean(magnetx),mean(magnety),{'Super';'Conducting';'Magnet'},'Interpreter','Latex','HorizontalAlignment','center');

capacitorx = [0.25 1.2 1.2 0.25]; capacitory = [0 0 0.75 0.75]; 
patch(capacitorx,capacitory,'w','FaceAlpha',0.8);
text(mean(capacitorx),mean(capacitory),{'Supercapacitor'},'Interpreter','Latex','HorizontalAlignment','center');





