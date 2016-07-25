function plotIDxVxSpeed_v1a(inData, mynumID)
% Example Call:
%
% Plots of Theory (V, Speed) given r (position), for mynumID.
% INPUT:
% - inData: input Data set, AFTER FilledData.
% - mynumID: ID for Data to use.
% ASSUMPTIONS:
% 0) inIDData: Data (from filledData) for a single ID.
% 1) Initial (x, y, z) = (0,0,0) and Initial t=0. This should be the case
% after processing through fillData.
% => So xTheory, yTheory, zTheory represent the difference between position
% at time=t and time=0.
% 2) DeltaTime = Fixed. 
%     e.g.) DeltaTime =  IDData{(j),'TimeSecFromBegin'} - tmpIDData{(j-1),'TimeSecFromBegin'};

    %1. Initialize
    %1.1. First store Data for given mynumID
    inIDData = inData((inData.numID==mynumID),:);
    sizeIDData = size(inIDData);
    totRows = sizeIDData(1);
    TimeArray = inData{inData.numID==mynumID,'TimeSecFromBegin'};
    %1.2. Initialize

    % 2.0. Obtain smoothed, Theoretical Vx, etc.:
    smoothVxTheory = inData{inData.numID==mynumID,'smoothVxTheory'};
    smoothVyTheory = inData{inData.numID==mynumID,'smoothVyTheory'};
    smoothVzTheory = inData{inData.numID==mynumID,'smoothVzTheory'};
    smoothSpeedxyTheory = inData{inData.numID==mynumID,'smoothSpeedxyTheory'};
    smoothSpeedTotTheory = inData{inData.numID==mynumID,'smoothSpeedTotTheory'};

 
    % 4.0. Plots
    % 4.1. Plot parameters
    subplotcols = 3;
    subplotrows = 4;
    myMarkerType = '.';
    dataColorType = 'r';
    figureTitle = strcat('V and A Plots from Position Data, for numID=',num2str(mynumID), ' (Data: ', dataColorType,')');
    scrsz = get(groot,'ScreenSize');
    %figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
    figure('Name', figureTitle,'NumberTitle','off','Position',[1 1 scrsz(3)/1.5 scrsz(4)/1.5]);
%    figure(mynumID);
%    curticks = get(gca, 'YTick');
%    set( gca, 'YTickLabel', cellstr( num2str(curticks(:), '%.2f') ) );

%size(xTimeArray)
%size(inIDData{:,'xLongFromBegin'})

    % 4.2. Plot "original" data
    subplot(subplotrows,subplotcols,1);
    scatter(TimeArray, inIDData{:,'smoothLongitude'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Longitude(deg)');
    subplot(subplotrows,subplotcols,2);
    scatter(TimeArray, inIDData{:,'smoothLatitude'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Latitude(deg)');
    subplot(subplotrows,subplotcols,3);
    scatter(TimeArray, inIDData{:,'smoothElevation'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Elevation(m)');

    % 4.3. Plot positions
    subplot(subplotrows,subplotcols,4);
    scatter(TimeArray, inIDData{:,'xLongFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('x(m)');
    subplot(subplotrows,subplotcols,5);
    scatter(TimeArray, inIDData{:,'yLatFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('y(m)');
    subplot(subplotrows,subplotcols,6);
    scatter(TimeArray, inIDData{:,'zElevFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('z(m)');

    % 4.4. Plot Velocity
    subplot(subplotrows,subplotcols,7);
    scatter(TimeArray, smoothVxTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('smooth Vx(m/s)');
    subplot(subplotrows,subplotcols,8);
    scatter(TimeArray, smoothVyTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('smooth Vy(m/s)');
    subplot(subplotrows,subplotcols,9);
    scatter(TimeArray, smoothVzTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('smooth Vz(m/s)');

    % 4.6. Plot Speed(s)
    subplot(subplotrows,subplotcols,10);
    scatter(TimeArray, smoothSpeedxyTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('smooth Speed-x-y(m/s)');
    subplot(subplotrows,subplotcols,11);
    scatter(TimeArray, smoothSpeedTotTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('smooth Speed-total(m/s)');


    % Close All Figures
%   close all;
    
end % end function
