function plotIDxVxAxTheory(inData, mynumID, Ax, Ay, Az)
% Example Call:
% plotIDxVxAxTheory(filledDataTrain(filledDataTrain.numID==mynumID,:), mynumID, filledDataTrain(filledDataTrain.numID==mynumID,'Ax'), filledDataTrain(filledDataTrain.numID==mynumID,'Ay'), filledDataTrain(filledDataTrain.numID==mynumID,'Az'));
%
% Plots of Theory (r, V) given A, for mynumID.
% INPUT:
% - inData: input Data set, AFTER FilledData.
% - mynumID: ID for Data to use.
% - Ax, Ay, Az: Acceleration input.  These determine x, Vx in theory by integration.
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
    %   Calculate: x(t) = x(0) + Vx(0)*t + Int((Int(Ax(t''),t''=0,t''=t'),t'=0,t'=t)
    % 2.1. Prepare for inputs: V
    %selectedRow1 = (filledDataTrain.numID==1 & filledDataTrain.TimeSecFromBegin==0);
    %selectedRow2 = (filledDataTrain.numID==1 & abs(filledDataTrain.TimeSecFromBegin-TimeSecSeparation)<(0.1*TimeSecSeparation));
% Generates ERRORs because some have time=0 for multiple rows!
%    selectedRow1 = (inIDData.TimeSecFromBegin==0);
%    selectedRow2 = (abs(inIDData.TimeSecFromBegin-DeltaTime)<(0.1*DeltaTime));
    selectedRow1 = 1;
    selectedRow2 = 2;
    DeltaTime = TimeArray(selectedRow2) - TimeArray(selectedRow1);
    if (DeltaTime ==0)
        Vx0 = 0
        Vy0 = 0
        Vz0 = 0 
    else
        Vx0 = ( inIDData{selectedRow2,'xLongFromBegin'} - inIDData{selectedRow1,'xLongFromBegin'} ) / DeltaTime
        Vy0 = ( inIDData{selectedRow2,'yLatFromBegin'} - inIDData{selectedRow1,'yLatFromBegin'} ) / DeltaTime
        Vz0 = ( inIDData{selectedRow2,'zElevFromBegin'} - inIDData{selectedRow1,'zElevFromBegin'} ) / DeltaTime
    end
    % 2.2. Obtain Theoretical x, Vx, etc.:
    [xTheory, VxTheory] = xVxTheory(TimeArray, inIDData{:,'Ax'}, Vx0);
    [yTheory, VyTheory] = xVxTheory(TimeArray, inIDData{:,'Ay'}, Vy0);
    [zTheory, VzTheory] = xVxTheory(TimeArray, inIDData{:,'Az'}, Vz0);

    % 3.0. Calculate Derived Values
    % 3.1. Calculate Speed.
    speedxy = sqrt(VxTheory.^2 + VyTheory.^2);
    speedTot = sqrt(VxTheory.^2 + VyTheory.^2 + VzTheory.^2);

    % 4.0. Plots
    % 4.1. Plot parameters
    subplotcols = 3;
    subplotrows = 4;
    myMarkerType = '.';
    dataColorType = 'r';
    figureTitle = strcat('Position, V Plots from A, for numID=',num2str(mynumID), ' (Data: ', dataColorType,')');
    scrsz = get(groot,'ScreenSize');
    %figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
    figure('Name', figureTitle,'NumberTitle','off','Position',[1 1 scrsz(3)/1.5 scrsz(4)/1.5]);
%    figure(mynumID);
%    curticks = get(gca, 'YTick');
%    set( gca, 'YTickLabel', cellstr( num2str(curticks(:), '%.2f') ) );

%size(xTimeArray)
%size(inIDData{:,'xLongFromBegin'})

    % 4.2. Plot positions
    subplot(subplotrows,subplotcols,1);
    scatter(TimeArray, xTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'xLongFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('x(m)');
    subplot(subplotrows,subplotcols,2);
    scatter(TimeArray, yTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'yLatFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('y(m)');
    subplot(subplotrows,subplotcols,3);
    scatter(TimeArray, zTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'zElevFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('z(m)');

    % 4.2. Plot Velocity
    subplot(subplotrows,subplotcols,4);
    scatter(TimeArray, VxTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Vx(m/s)');
    subplot(subplotrows,subplotcols,5);
    scatter(TimeArray, VyTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Vy(m/s)');
    subplot(subplotrows,subplotcols,6);
    scatter(TimeArray, VzTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Vz(m/s)');

    % 4.3. Plot Acceleration Inputs
    subplot(subplotrows,subplotcols,7);
    scatter(TimeArray, Ax{:,1}, myMarkerType, dataColorType);
    xlabel('time(s)'); ylabel('Ax(m/s^2)');
    subplot(subplotrows,subplotcols,8);
    scatter(TimeArray, Ay{:,1}, myMarkerType, dataColorType);
    xlabel('time(s)'); ylabel('Ay(m/s^2)');
    ax = gca; ax.YAxis.TickLabelFormat = '%,.2f';
    subplot(subplotrows,subplotcols,9);
    scatter(TimeArray, Az{:,1}, myMarkerType, dataColorType);
    xlabel('time(s)'); ylabel('Az(m/s^2)');
    ax = gca; ax.YAxis.TickLabelFormat = '%,.2f';
    
    % 4.4. Plot Speed(s)
    subplot(subplotrows,subplotcols,10);
    scatter(TimeArray, speedxy, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Speed-x-y(m/s)');
    subplot(subplotrows,subplotcols,11);
    scatter(TimeArray, speedTot, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Speed'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Speed-total(m/s)');

    % Close All Figures
%   close all;
    
end % end function
