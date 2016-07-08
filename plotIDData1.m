function plotIDData1(inData, mynumID)
% Plot Data for given mynumID
% ASSUMPTIONS:
% - inData is NOT raw Data but was processed through fillData().
% - Data for given mynumID are contained in continuous rows in both inData and aggData 
% INPUT:
% - inData: input Data set
% FUNCTIONS:
% 1) All variable Plots for given ID

    %1. Initialize
    SizeinData = size(inData);
%     subplotrows = 3;
%     subplotcols = round((SizeinData(2)-3)/subplotrows);
    subplotcols = 3;
    subplotrows = round((SizeinData(2)-3)/subplotcols);

%    %2. Store Data for given mynumID
%    tmpIDData = inData((inData.numID==mynumID),:);

    %3. Plots
    %figure(mynumID);
    %figure('Name','Simulation Plot Window','NumberTitle','off')
     figureTitle = strcat('Individual Plots for numID=',num2str(mynumID))
     figure('Name', figureTitle,'NumberTitle','off')
%     for colnum=3:(SizeinData(2)-1)
%         plotnum = colnum - 2;
%         subplot(subplotrows,subplotcols,plotnum);
%         %plot(tmpIDData{:,'TimeSecFromBegin'},tmpIDData{:,colnum});
% %        scatter(tmpIDData{:,'TimeSecFromBegin'},tmpIDData{:,colnum});
%         scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),colnum});
%         %xlabel(tmpIDData.Properties.VariableNames(2));
%         xlabel('time(s)');
% %        ylabel(tmpIDData.Properties.VariableNames(colnum));
%         ylabel(inData.Properties.VariableNames(colnum));
%     end


        % 2.2.0. Curate Order and Layout of Plots:
        myMarkerType = '.';
        subplotrows = 3;
        % 2.2.1. (x,y,z) position plots
        subplot(subplotrows,subplotcols,1);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'xLongFromBegin'},myMarkerType);
        xlabel('time(s)'); ylabel('x(m)');
        subplot(subplotrows,subplotcols,2);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'yLatFromBegin'},myMarkerType);
        xlabel('time(s)'); ylabel('y(m)');
        subplot(subplotrows,subplotcols,3);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'zElevFromBegin'},myMarkerType);
        xlabel('time(s)'); ylabel('z(m)');
    
        % 2.2.2. (Ax,Ay,Az) plots
        subplot(subplotrows,subplotcols,4);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'Ax'},myMarkerType);
        xlabel('time(s)'); ylabel('Ax(m/s^2)');
        subplot(subplotrows,subplotcols,5);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'Ay'},myMarkerType);
        xlabel('time(s)'); ylabel('Ay(m/s^2)');
        subplot(subplotrows,subplotcols,6);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'Az'},myMarkerType);
        xlabel('time(s)'); ylabel('Az(m/s^2)');
    
        % 2.2.3. Other plots
        subplot(subplotrows,subplotcols,7);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'Speed'},myMarkerType);
        xlabel('time(s)'); ylabel('Speed(m/s)');
        subplot(subplotrows,subplotcols,8);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'Heading'},myMarkerType);
        xlabel('time(s)'); ylabel('Heading (deg)');
        subplot(subplotrows,subplotcols,9);
        scatter(inData{(inData.numID==mynumID),'TimeSecFromBegin'},inData{(inData.numID==mynumID),'Yawrate'},myMarkerType);
        xlabel('time(s)'); ylabel('Yawrate(deg/s)');
    



end % end function
