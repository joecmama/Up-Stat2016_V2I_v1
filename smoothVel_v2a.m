function [smoothVel_v2a_Out] = smoothVel_v2a(inData, aggData, SpanNumPoints)
% Smooth Velocity.
% INPUT:
% - inData: input Data set
% - aggData: Aggregate Data for input Data set
% - SpanNumPoints: Number of Time Data Points to Span for smoothing.
% NOTE:
% A) Assume numID's are in order, increasing by 1 sequentially, beginning
% with 1.
% *************************************************************************
% This portion is for Step v1b (After Brian interpolates and smoothes raw
% data with Kalman Smoothing + Lowess, and Velocity Derived from such.

    %1. Initialize
    smoothVxTheory = NaN(0); 
    smoothVyTheory = NaN(0); 
    smoothVzTheory = NaN(0); 
    smoothSpeedxyTheory = NaN(0);
    smoothSpeedTotTheory = NaN(0);
%    currnumID = 0;  % Start with non-existent numID=0 which is 1 below first numID = 1.
    % For Total Number of ID's
    numIDIn = aggData(:,'numID');
    sizenumIDIn = size(numIDIn);
    totnumIDIn = sizenumIDIn(1);

    % 2. Loop through Data for All ID's, 1 ID at a time.
    for (i = 1:totnumIDIn)
%         % First check if new ID.  Only do for each ID.
%         if ( currnumID ~= inData{i,'numID'} )   % If Different ID
%             currnumID = currnumID + 1;
            % Run for each ID data
            mynumID = numIDIn{i,1};
            %2.1. First store Data for given mynumID
            inIDData = inData((inData.numID==mynumID),:);
            sizeIDData = size(inIDData);
            totRowsID = sizeIDData(1);
            SpanPercentID = SpanNumPoints/totRowsID;

            %2.2. Find Time Array for each ID.
            TimeArrayID = inData{inData.numID==mynumID,'TimeSecFromBegin'};

            %2.3. Find Velocitry Array for each ID.
            VxTheoryID = inData{inData.numID==mynumID,'VxTheory'};
            VyTheoryID = inData{inData.numID==mynumID,'VyTheory'};
            VzTheoryID = inData{inData.numID==mynumID,'VzTheory'};

            % 2.4. Smooth
            smoothVxTheoryID = smooth(TimeArrayID,VxTheoryID,SpanPercentID,'rloess');
            smoothVyTheoryID = smooth(TimeArrayID,VyTheoryID,SpanPercentID,'rloess');
            smoothVzTheoryID = smooth(TimeArrayID,VzTheoryID,SpanPercentID,'rloess');

            % 2.3.0. Calculate Derived Values
            % 2.3.1. Calculate Speed.
            smoothSpeedxyID = sqrt(smoothVxTheoryID.^2 + smoothVyTheoryID.^2);
            smoothSpeedTotID = sqrt(smoothVxTheoryID.^2 + smoothVyTheoryID.^2 + smoothVzTheoryID.^2);
            
            % 2.4.1. Append to Total Data Columns.
            smoothVxTheory = [smoothVxTheory; smoothVxTheoryID];
            smoothVyTheory = [smoothVyTheory; smoothVyTheoryID];
            smoothVzTheory = [smoothVzTheory; smoothVzTheoryID];
            smoothSpeedxyTheory = [smoothSpeedxyTheory; smoothSpeedxyID];
            smoothSpeedTotTheory = [smoothSpeedTotTheory; smoothSpeedTotID];
            
    end % end for loop

    % TEST
    disp('Show size of smoothVxTheory.., smoothSpeed');
    size(smoothVxTheory)
    size(smoothVyTheory)
    size(smoothVzTheory)
    size(smoothSpeedxyTheory)
    size(smoothSpeedTotTheory)
            
    % Final Output: Remove ID and replaced with number ID
%    addDataOut = [array2table(TimeSecFromBegin) inData(:,1:(sizeColrawDataIn-1))];
    % Output Table:
    smoothVel_v2a_Out = [ inData array2table(smoothVxTheory) array2table(smoothVyTheory) array2table(smoothVzTheory) array2table(smoothSpeedxyTheory) array2table(smoothSpeedTotTheory) ];
    % Output Matrix:
%    addDataOut = [numID TimeSecFromBegin inData{:,1:(sizeColrawDataIn-1)}];
       
    
end % end function
