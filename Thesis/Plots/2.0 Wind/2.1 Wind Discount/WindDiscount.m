function WindDiscount
% WindDiscount - Generates plot of average Alberta Electricity pool price
% at various levels of wind output
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
% Data files required: windAIL.csv
% Subfunctions: none
%
% See also: N/A
% Author: Will Noel
% email: wnoel@ualberta.ca
% Feb 2021; Last revision: 01-Feb-2021
%------------- BEGIN CODE --------------

% Read in .csv datafile and extract date values
data                   = readtable('windAIL.csv');
[data.Y,data.M,~]      = ymd(data.date);
data.H                 = data.he;

% Fix boolean read in values
data.onPeak  = strcmp(data.on_peak,'TRUE'); 
data.offPeak = strcmp(data.on_peak,'FALSE'); 

% Remove any instances of nan
data = rmmissing(data);

% Normalize wind by total AIL
data.Wind = data.hourlyWind./data.hourly_dispatch;

% Set up plotting matrix [year, month, hour, wind high, wind med, wind low]
yr   = 2016:2020;
mnth = 1:12;
hr   = 0:23;

% Empty matrix of proper size
plotmat = zeros(length(yr)*length(mnth)*length(hr),9);

% Loop to populate year column
temp1 = repmat(yr,[length(mnth)*length(hr),1]);
temp2 = temp1(:,1);
for i = 2:length(yr)
    temp2  = [temp2;temp1(:,i)];
end
plotmat(:,1) = temp2;
% Loop to populate month column
temp1 = repmat(mnth,[length(hr),1]);
temp2 = temp1(:,1);  
for i = 2:length(mnth)
    temp2  = [temp2;temp1(:,i)];
end
plotmat(:,2) = repmat(temp2,[length(yr),1]);   
% Populate hour column
plotmat(:,3) = repmat(hr,[1,length(yr)*length(mnth)])';

% Using year/month/hour to index pool price, populate remaining columns
MW = zeros(5,4);
for i = 1:length(yr)
        MW(i,:) = [min(data.Wind(data.Y==yr(i))),...
            quantile(data.Wind(data.Y==yr(i)),[0.25 0.75]),...
            max(data.Wind(data.Y==yr(i)))];
end

for i = 1:size(plotmat,1)
    for ii = 4:size(plotmat,2)
        if ii<7 % low, mid, high wind
            iii = ii-3;
            idx           = find(data.Y==plotmat(i,1)&...
                                data.M==plotmat(i,2)&...
                                data.Wind>=MW(yr==plotmat(i,1),iii)&...
                                data.Wind<MW(yr==plotmat(i,1),iii+1));
            plotmat(i,ii) = mean(data.pool_price(idx),'omitnan');
        elseif ii == 7 % mean
            idx           = find(data.Y==plotmat(i,1)&...
                                data.M==plotmat(i,2));
            plotmat(i,ii) = mean(data.pool_price(idx));
        elseif ii == 8 % on peak
            idx           = find(data.Y==plotmat(i,1)&...
                                data.M==plotmat(i,2)&...
                                data.onPeak == 1);
            plotmat(i,ii) = mean(data.pool_price(idx),'omitnan');
        elseif ii == 9 % off peak
            idx           = find(data.Y==plotmat(i,1)&...
                                data.M==plotmat(i,2)&...
                                data.offPeak == 1);
            plotmat(i,ii) = mean(data.pool_price(idx),'omitnan');
        end
    end
end

% Generate plot:
%    x-axis = month
%    y-axis = power price
%    color  = amount of wind
figure(1)
% Window size
set(gcf,'Units','inches','Position',[1 1 10 3]); % [xpos ypos width height]
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',8);
x    = 1:1:48;
xlbl = {'Jan' [] [] 'Apr' [] [] 'Jul' [] [] 'Oct' [] []};
plot16mean   = zeros(size(MW,2)-1,length(mnth));
plot17mean   = plot16mean; plot18mean = plot16mean; plot19mean = plot16mean; plot20mean = plot16mean; 
% Each row corresponds to a price for wind = high, med, low
for i = 1:length(mnth)
    for ii = 1:size(MW,2)-1
        plot16mean(ii,i) = mean(plotmat(plotmat(:,1)==2016&plotmat(:,2)==mnth(i),ii+3),'omitnan');
        plot17mean(ii,i) = mean(plotmat(plotmat(:,1)==2017&plotmat(:,2)==mnth(i),ii+3),'omitnan');
        plot18mean(ii,i) = mean(plotmat(plotmat(:,1)==2018&plotmat(:,2)==mnth(i),ii+3),'omitnan');
        plot19mean(ii,i) = mean(plotmat(plotmat(:,1)==2019&plotmat(:,2)==mnth(i),ii+3),'omitnan');
        plot20mean(ii,i) = mean(plotmat(plotmat(:,1)==2020&plotmat(:,2)==mnth(i),ii+3),'omitnan');
    end        
end
% Calculate difference for stacked bars
plot16s(1,:) = plot16mean(1,:) - plot16mean(2,:);
plot16s(2,:) = plot16mean(2,:) - plot16mean(3,:);
plot16s(3,:) = plot16mean(3,:);
plot16s([1 2 3],:) = plot16s([3 2 1],:);

plot17s(1,:) = plot17mean(1,:) - plot17mean(2,:);
plot17s(2,:) = plot17mean(2,:) - plot17mean(3,:);
plot17s(3,:) = plot17mean(3,:);
plot17s([1 2 3],:) = plot17s([3 2 1],:);

plot18s(1,:) = plot18mean(1,:) - plot18mean(2,:);
plot18s(2,:) = plot18mean(2,:) - plot18mean(3,:);
plot18s(3,:) = plot18mean(3,:);
plot18s([1 2 3],:) = plot18s([3 2 1],:);

plot19s(1,:) = plot19mean(1,:) - plot19mean(2,:);
plot19s(2,:) = plot19mean(2,:) - plot19mean(3,:);
plot19s(3,:) = plot19mean(3,:);
plot19s([1 2 3],:) = plot19s([3 2 1],:);

plot20s(1,:) = plot20mean(1,:) - plot20mean(2,:);
plot20s(2,:) = plot20mean(2,:) - plot20mean(3,:);
plot20s(3,:) = plot20mean(3,:);
plot20s([1 2 3],:) = plot20s([3 2 1],:);

% Average pool price/month/year (line plot)
plotmean    = zeros(length(yr),length(mnth));
plotonpeak  = plotmean;
plotoffpeak = plotmean;

for i = 1:length(yr)
    for ii = 1:length(mnth)
        plotmean(i,ii) = mean(plotmat(plotmat(:,1)==yr(i)&plotmat(:,2)==mnth(ii),7),'omitnan');
        plotonpeak(i,ii) = mean(plotmat(plotmat(:,1)==yr(i)&plotmat(:,2)==mnth(ii),8),'omitnan');
        plotoffpeak(i,ii) = mean(plotmat(plotmat(:,1)==yr(i)&plotmat(:,2)==mnth(ii),9),'omitnan');
    end
end

% Convert on and off peak to error bars
onpeakerr  = plotonpeak-plotmean;
offpeakerr = plotmean-plotoffpeak;

% % Plot each year between 2016-2019
%     b = bar(x,[plot16s plot17s plot18s plot19s plot20s],'stacked','EdgeColor','w','LineWidth',0.5); hold on
%         b(1).FaceColor = 0.4*[1 1 1];
%         b(2).FaceColor = 0.6*[1 1 1];
%         b(3).FaceColor = 0.8*[1 1 1];
%     % Format plot
%     ax = gca;
%     ax.XAxis.FontSize = 9;
%     xlabel('Month (2016 - 2020)','FontSize',11);
%     ylabel('Pool Price (\$/MWh)','FontSize',11);
%     ylim([0 150]);
%     xticks(x);
%     xticklabels([xlbl xlbl xlbl xlbl xlbl]);
%     set(gca,'box','off');
%     ylim([0 150]);
%     
% % Replot instance in 2018 where price doesn't follow expected trend
% idx18 = find(plot18mean(1,:)<plot18mean(2,:));
% xidx  = 24+idx18;
% fix18 = sort(plot18mean(:,plot18mean(1,:)<plot18mean(2,:)),'descend');
% % Calculate new stack values
% fix18(1) = fix18(1) - fix18(2);
% fix18(2) = fix18(2) - fix18(3);
% fix18([1 2 3]) = fix18([3 2 1]);
% % Plot new stack at affected year
%     yyaxis right
%     bfix = bar(x(xidx),fix18,'stacked','EdgeColor','w','LineWidth',0.5);
%         bfix(1).FaceColor = 0.4*[1 1 1];
%         bfix(3).FaceColor = 0.6*[1 1 1];
%         bfix(2).FaceColor = 0.8*[1 1 1];
%     ylim([0 150]);
%     yticks(0:50:150);
%     yticklabels({});
%     ylabel([]);
%     set(gca,'YColor','k')
% 
%     err = errorbar(x,...
%                     [plotmean(1,:) plotmean(2,:) plotmean(3,:) plotmean(4,:) plotmean(5,:)],...
%                     [offpeakerr(1,:) offpeakerr(2,:) offpeakerr(3,:) offpeakerr(4,:) offpeakerr(5,:)],...
%                     [onpeakerr(1,:) onpeakerr(2,:) onpeakerr(3,:) onpeakerr(4,:) onpeakerr(5,:)]);
%         err.Marker = 'o'; 
%         err.MarkerSize = 3;
%         err.Color = 'k'; 
%         err.MarkerFaceColor = 'w';
%         err.LineStyle = 'none';
%         
%     leg1 = legend([b(3) b(2) b(1)],...
%         ['Low (',num2str(round((100*mean(MW(:,1))))),' - ',...
%                     num2str(round((100*mean(MW(:,2))))),'\%)'],...
%         ['Med (',num2str(round((100*mean(MW(:,2))))),' - ',...
%                     num2str(round((100*mean(MW(:,3))))),'\%)'],...
%         ['High (',num2str(round((100*mean(MW(:,3))))),' - ',...
%                     num2str(round((100*mean(MW(:,4))))),'\%)'],...
%         'Location','northwest','Interpreter','latex'); 
%         legend boxoff
%         title(leg1,'\textbf{Wind \% of AIL}','Interpreter','latex');
%     a = axes('position',get(gca,'position'),'visible','off');
%     leg2 = legend(a,err(1),...
%         ['On-Peak',newline,'Mean',newline,'Off-Peak'],...
%         'Interpreter','latex'); 
%         legend boxoff
%     leg2.Position = leg1.Position + [0.145 0 0 0];
%         title(leg2,'\textbf{Monthly Pool Price}','Interpreter','latex'); hold off
  
% Calculate difference between price and mean price for alternate plot
plot16m    = plot16mean - plotmean(1,:);
plot17m    = plot17mean - plotmean(2,:);
plot18m    = plot18mean - plotmean(3,:);
plot19m    = plot19mean - plotmean(4,:);
plot20m    = plot20mean - plotmean(5,:);

% Convert to stack plot (mean)
for i = 1:length(plot16m)
   if plot16m(2,i) < 0
       plot16m(3,i) = plot16m(3,i)-plot16m(2,i);
       
   else 
       plot16m(1,i) = plot16m(1,i)-plot16m(2,i);
   end
   if plot17mean(2,i) < 0
       plot17m(3,i) = plot17m(3,i)-plot17m(2,i);
       
   else % >0
       plot17m(1,i) = plot17m(1,i)-plot17m(2,i);
   end
   if plot18m(2,i) < 0
       plot18m(3,i) = plot18m(3,i)-plot18m(2,i);
   elseif plot18m(2,i) > plot18m(1,i) % only happens in march 2018
       plot18m(2,i) = plot18m(2,i)-plot18m(1,i);
       plot18m([2 1],i) = plot18m([1 2],i);
   else % >0
       plot18m(1,i) = plot18m(1,i)-plot18m(2,i);
   end
   if plot19m(2,i) < 0
       plot19m(3,i) = plot19m(3,i)-plot19m(2,i);
       
   else % >0
       plot19m(1,i) = plot19m(1,i)-plot19m(2,i);
   end
   if plot20m(2,i) < 0
       plot20m(3,i) = plot20m(3,i)-plot20m(2,i);
       
   else % >0
       plot20m(1,i) = plot20m(1,i)-plot20m(2,i);
   end
end

% Rearrange row plotting order
plot16m([1 2 3],:) = plot16m([2 1 3],:);
plot17m([1 2 3],:) = plot17m([2 1 3],:);
plot18m([1 2 3],:) = plot18m([2 1 3],:);
plot19m([1 2 3],:) = plot19m([2 1 3],:);
plot20m([1 2 3],:) = plot20m([2 1 3],:);

fig = figure(2);
% Plot each year between 2017-2020
set(gcf,'Units','inches','Position',[1 1 6.75 3]); % [xpos ypos width height]
set(gcf,'DefaultTextInterpreter','latex');
set(gcf,'DefaultAxesTickLabelInterpreter','latex');
set(gca,'DefaultAxesTickLabelInterpreter','latex','FontSize',10);

b2 = bar(x,[plot17m plot18m plot19m plot20m],'stacked','EdgeColor','w','LineWidth',0.5); hold on
    b2(3).FaceColor = 0.4*[1 1 1];
    b2(2).FaceColor = 0.8*[1 1 1]; 
    b2(1).FaceColor = 0.6*[1 1 1];
    xticks(x);
    xticklabels([xlbl xlbl xlbl xlbl]);
    ylim([-100 200]);
    yticks(-100:50:200);
    %yticklabels({-100 [] -50 [] 0 [] 50 [] 100});
    ax = gca;
    ax.XAxis.FontSize = 9;
    xlabel('Month (2017 - 2020)','FontSize',11);
    ylabel({'Difference from';'Average Pool Price (\$/MWh)'},'FontSize',11);
    
% Add on/off peak prices
    yyaxis right
    onpk = area(x,[onpeakerr(2,:) onpeakerr(3,:) onpeakerr(4,:) onpeakerr(5,:)]);
        onpk.FaceColor = 'k';
        onpk.EdgeColor = 'w';
        onpk.FaceAlpha = 0.2;
    ofpk = area(x,-[offpeakerr(2,:) offpeakerr(3,:) offpeakerr(4,:) offpeakerr(5,:)]);
        ofpk.FaceColor = 'k';
        ofpk.EdgeColor = 'w';
        ofpk.FaceAlpha = 0.2;
    yticklabels({});
    yticks(-100:50:200);
    ax2 = gca;
    ax2.YTick = ax.YTick;
    ylabel([]);
    ylim([-100 200]);
    set(gca,'box','off');
    set(gca,'YColor','k');
    
% Add text arrow for Jan 2020
% annotation(fig,'textarrow',[0.754 0.730],...
%     [0.851 0.927],'String',{'\$191/MWh'},...
%     'Interpreter','latex',...
%     'HeadStyle','vback3',...
%     'HeadLength',5,...
%     'FontSize',10);

leg2 = legend([b2(2) b2(1) b2(3)],...
    ['Low (',num2str(round((100*min(MW(:,1))))),' - ',...
                num2str(round((100*mean(MW(:,2))))),'\%)'],...
    ['Med (',num2str(round((100*mean(MW(:,2))))),' - ',...
                num2str(round((100*mean(MW(:,3))))),'\%)'],...
    ['High (',num2str(round((100*mean(MW(:,3))))),' - ',...
                num2str(round((100*max(MW(:,4))))),'\%)'],...
    'Location','Northwest','Interpreter','latex','FontSize',10); 
    legend boxoff
    title(leg2,'\textbf{Wind \% of Dispatch (Bar)}','Interpreter','latex','FontSize',10);
    leg2.Position(1) = leg2.Position(1) - 0.01;
    leg2.Position(2) = leg2.Position(2) + 0.025;
    
a = axes('position',get(gca,'position'),'visible','off');
leg3 = legend(a,onpk,'On \& Off Peak','Location','SouthWest','Interpreter','latex','FontSize',10);
    legend box off
    title(leg3,'\textbf{Price Range (Area)}','Interpreter','latex','FontSize',10);