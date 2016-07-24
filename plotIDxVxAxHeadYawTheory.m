function plotIDxVxAxHeadYawTheory(inData, mynumID)
% Example Call:
%
% Plots of Theory (V, A, Yaw Rate) given r (position) and Heading, for mynumID.
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

    % 2.0. Calculate Theoretical Hypotheses:
    % 2.1. Obtain Theoretical Vx, Ax, etc.:
    VxTheory = inData{inData.numID==mynumID,'VxTheory'};
    VyTheory = inData{inData.numID==mynumID,'VyTheory'};
    VzTheory = inData{inData.numID==mynumID,'VzTheory'};
    AxTheory = inData{inData.numID==mynumID,'AxTheory'};
    AyTheory = inData{inData.numID==mynumID,'AyTheory'};
    AzTheory = inData{inData.numID==mynumID,'AzTheory'};
    SpeedxyTheory = inData{inData.numID==mynumID,'SpeedxyTheory'};
    SpeedTotTheory = inData{inData.numID==mynumID,'SpeedTotTheory'};
%    YawrateTheory = inData{inData.numID==mynumID,'YawrateTheory'};

 
    % 4.0. Plots
    % 4.1. Plot parameters
    subplotcols = 3;
    subplotrows = 5;
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
    scatter(TimeArray, VxTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Vx(m/s)');
    subplot(subplotrows,subplotcols,8);
    scatter(TimeArray, VyTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Vy(m/s)');
    subplot(subplotrows,subplotcols,9);
    scatter(TimeArray, VzTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Vz(m/s)');

    % 4.5. Plot Acceleration Inputs
    subplot(subplotrows,subplotcols,10);
    scatter(TimeArray, AxTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Ax'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Ax(m/s^2)');
    subplot(subplotrows,subplotcols,11);
    scatter(TimeArray, AyTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Ay'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Ay(m/s^2)');
    ax = gca; ax.YAxis.TickLabelFormat = '%,.2f';
    subplot(subplotrows,subplotcols,12);
    scatter(TimeArray, AzTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Az'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Az(m/s^2)');
    ax = gca; ax.YAxis.TickLabelFormat = '%,.2f';
    
    % 4.6. Plot Speed(s)
    subplot(subplotrows,subplotcols,13);
%     scatter(TimeArray, SpeedxyTheory, myMarkerType);
% %     hold on;
% %     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
%     xlabel('time(s)'); ylabel('Speed-x-y(m/s)');
%     subplot(subplotrows,subplotcols,14);
    scatter(TimeArray, SpeedTotTheory, myMarkerType);
%     hold on;
%     scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Speed-total(m/s)');

%     % 4.7. Plot Heading
%     subplot(subplotrows,subplotcols,14);
%     scatter(TimeArray, inIDData{:,'smoothHeading'}, myMarkerType, dataColorType); % From Data
%     xlabel('time(s)'); ylabel('Heading(deg)');
% 
%     % 4.8. Plot Yawrate
%     subplot(subplotrows,subplotcols,15);
%     scatter(TimeArray, YawrateTheory, myMarkerType);
%     hold on;
% %    scatter(TimeArray, inIDData{:,'YawRate'}, myMarkerType, dataColorType); % From Data
%     scatter(TimeArray, inIDData{:,'smoothYawrate'}, myMarkerType, dataColorType); % From Data
%     xlabel('time(s)'); ylabel('YawRate(deg/s)');

    % Close All Figures
%   close all;
    
end % end function
