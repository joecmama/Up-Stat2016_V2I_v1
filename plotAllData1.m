function plotAllData1(inData, begnumID, lastnumID, totID)
% Plot Data for all ID's between begnumID and lastnumID, inclusive.
% ASSUMPTIONS:
% - inData is NOT raw Data but was processed through fillData().
% - Data for given mynumID are contained in continuous rows in both inData and aggData 
% INPUT:
% - inData: input Data set
% - begnumID, lastnumID, totID = Beginning numID, Last numID, and Total number of unique ID's.
% FUNCTIONS:
% 1) All variable Plots for given ID

    %1. Initialize
    SizeinData = size(inData);
%     subplotrows = 3;
%     subplotcols = round((SizeinData(2)-3)/subplotrows);
    subplotcols = 3;
    subplotrows = round((SizeinData(2)-3)/subplotcols);
    % 1.1. Error Check
    if (begnumID<1) begnumID=1; end
    if (lastnumID>totID) lastnumID=totID; end
    if (begnumID>lastnumID) fprintf('ERROR: begnumID>lastnumID.\n'); return; end
    
    %2. Plots
    %figure(mynumID);
    %figure('Name','Simulation Plot Window','NumberTitle','off')
     figureTitle = strcat('Data Plots for all numID between ',num2str(begnumID),'-',num2str(lastnumID));
     figure('Name', figureTitle,'NumberTitle','off');
%     for colnum=3:(SizeinData(2)-1)
%         plotnum = colnum - 2;
%         subplot(subplotrows,subplotcols,plotnum);
%         %plot(tmpIDData{:,'TimeSecFromBegin'},tmpIDData{:,colnum});
%         scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),colnum});
%         %xlabel(tmpIDData.Properties.VariableNames(2));
%         xlabel('time(s)');
%         ylabel(inData.Properties.VariableNames(colnum));
%     end

        % 2.2.0. Curate Order and Layout of Plots:
        myMarkerType = '.';
        subplotrows = 3;
        % 2.2.1. (x,y,z) position plots
        subplot(subplotrows,subplotcols,1);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'xLongFromBegin'},myMarkerType);
        xlabel('time(s)'); ylabel('x(m)');
        subplot(subplotrows,subplotcols,2);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'yLatFromBegin'},myMarkerType);
        xlabel('time(s)'); ylabel('y(m)');
        subplot(subplotrows,subplotcols,3);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'zElevFromBegin'},myMarkerType);
        xlabel('time(s)'); ylabel('z(m)');
    
        % 2.2.2. (Ax,Ay,Az) plots
        subplot(subplotrows,subplotcols,4);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'Ax'},myMarkerType);
        xlabel('time(s)'); ylabel('Ax(m/s^2)');
        subplot(subplotrows,subplotcols,5);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'Ay'},myMarkerType);
        xlabel('time(s)'); ylabel('Ay(m/s^2)');
        subplot(subplotrows,subplotcols,6);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'Az'},myMarkerType);
        xlabel('time(s)'); ylabel('Az(m/s^2)');
    
        % 2.2.3. Other plots
        subplot(subplotrows,subplotcols,7);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'Speed'},myMarkerType);
        xlabel('time(s)'); ylabel('Speed(m/s)');
        subplot(subplotrows,subplotcols,8);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'Heading'},myMarkerType);
        xlabel('time(s)'); ylabel('Heading (deg)');
        subplot(subplotrows,subplotcols,9);
        scatter(inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'TimeSecFromBegin'},inData{(inData.numID>=begnumID & inData.numID<=lastnumID),'Yawrate'},myMarkerType);
        xlabel('time(s)'); ylabel('Yawrate(deg/s)');
    
    
end % end function
