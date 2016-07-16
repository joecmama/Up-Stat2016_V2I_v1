function plotIDxVxAxTheory2(inData, mynumID, x, y, z)
% Example Call:
% plotIDxVxAxTheory2(filledDataTrain, mynumID, filledDataTrain(filledDataTrain.numID==mynumID,'xLongFromBegin'), filledDataTrain(filledDataTrain.numID==mynumID,'yLatFromBegin'), filledDataTrain(filledDataTrain.numID==mynumID,'zElevFromBegin'));
%
% Plots of Theory (V, A) given r (position), for mynumID.
% INPUT:
% - inData: input Data set, AFTER FilledData.
% - mynumID: ID for Data to use.
% - x, y, z: Position input.  These determine Vx, Ax, etc. in theory by derivatives.
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
    [VxTheory, AxTheory] = VxAxTheory(TimeArray, inIDData{:,'xLongFromBegin'});
    [VyTheory, AyTheory] = VxAxTheory(TimeArray, inIDData{:,'yLatFromBegin'});
    [VzTheory, AzTheory] = VxAxTheory(TimeArray, inIDData{:,'zElevFromBegin'});

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
    figureTitle = strcat('V and A Plots from Position Data, for numID=',num2str(mynumID), ' (Data: ', dataColorType,')');
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
    scatter(TimeArray, inIDData{:,'xLongFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('x(m)');
    subplot(subplotrows,subplotcols,2);
    scatter(TimeArray, inIDData{:,'yLatFromBegin'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('y(m)');
    subplot(subplotrows,subplotcols,3);
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
    scatter(TimeArray, AxTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Ax'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Ax(m/s^2)');
    subplot(subplotrows,subplotcols,8);
    scatter(TimeArray, AyTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Ay'}, myMarkerType, dataColorType); % From Data
    xlabel('time(s)'); ylabel('Ay(m/s^2)');
    ax = gca; ax.YAxis.TickLabelFormat = '%,.2f';
    subplot(subplotrows,subplotcols,9);
    scatter(TimeArray, AzTheory, myMarkerType);
    hold on;
    scatter(TimeArray, inIDData{:,'Az'}, myMarkerType, dataColorType); % From Data
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
