function [addDataOut] = addVelAccYawTheoryData_Step_v1b(inData, aggData)
% Fill Data: Returns Table of added Data- Theoretically calculated V, A,
% speed, and Yaw Rate from Position and Heading data after "addData" function.
% INPUT:
% - inData: input Data set
% - aggData: Aggregate Data for input Data set
% FUNCTIONS:
% 1) Add theoretical Velocity, Acceleration, Speed calculated from Position Data.
% NOTE:
% A) Assume numID's are in order, increasing by 1 sequentially, beginning
% with 1.
% *************************************************************************
% This portion is for Step v1b (After Brian interpolates and smoothes raw
% data with Kalman Smoothing + Lowess.

    %1. Initialize
    VxTheory = NaN(0); 
    VyTheory = NaN(0); 
    VzTheory = NaN(0); 
    AxTheory = NaN(0);
    AyTheory = NaN(0);
    AzTheory = NaN(0);
    SpeedxyTheory = NaN(0);
    SpeedTotTheory = NaN(0);
    YawrateTheory = NaN(0);
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
            %2.1.1. First store Data for given mynumID
            inIDData = inData((inData.numID==mynumID),:);
            sizeIDData = size(inIDData);
            totRows = sizeIDData(1);
            TimeArray = inData{inData.numID==mynumID,'TimeSecFromBegin'};
            %2.1.2. Initialize

            % 2.2.0. Calculate Theoretical Hypotheses:
            % 2.2.1. Obtain Theoretical Vx, Ax, etc.:
            [VxTheoryID, AxTheoryID] = VxAxTheory(TimeArray, inIDData{:,'xLongFromBegin'});
            [VyTheoryID, AyTheoryID] = VxAxTheory(TimeArray, inIDData{:,'yLatFromBegin'});
            [VzTheoryID, AzTheoryID] = VxAxTheory(TimeArray, inIDData{:,'zElevFromBegin'});
            % 2.2.2. Obtain Theoretical Yawrate:
            [YawrateTheoryID] = YawrateTheoryCalc(TimeArray, inIDData{:,'smoothHeading'});

            % 2.3.0. Calculate Derived Values
            % 2.3.1. Calculate Speed.
            SpeedxyID = sqrt(VxTheoryID.^2 + VyTheoryID.^2);
            SpeedTotID = sqrt(VxTheoryID.^2 + VyTheoryID.^2 + VzTheoryID.^2);
            
            % 2.4.1. Append to Total Data Columns.
            VxTheory = [VxTheory; VxTheoryID];
            VyTheory = [VyTheory; VyTheoryID];
            VzTheory = [VzTheory; VzTheoryID];
            AxTheory = [AxTheory; AxTheoryID];
            AyTheory = [AyTheory; AyTheoryID];
            AzTheory = [AzTheory; AzTheoryID];
            SpeedxyTheory = [SpeedxyTheory; SpeedxyID];
            SpeedTotTheory = [SpeedTotTheory; SpeedTotID];
            YawrateTheory = [YawrateTheory; YawrateTheoryID];
            
    end % end for loop

    % TEST
    disp('Show size of VxTheory.., AxTheory.., Speed.., YawrateTheory');
    size(VxTheory)
    size(VyTheory)
    size(VzTheory)
    size(AxTheory)
    size(AyTheory)
    size(AzTheory)
    size(SpeedxyTheory)
    size(SpeedTotTheory)
    size(YawrateTheory)
            
    % Final Output: Remove ID and replaced with number ID
%    addDataOut = [array2table(TimeSecFromBegin) inData(:,1:(sizeColrawDataIn-1))];
    % Output Table:
    addDataOut = [ inData array2table(VxTheory) array2table(VyTheory) array2table(VzTheory) array2table(AxTheory) array2table(AyTheory) array2table(AzTheory) array2table(SpeedxyTheory) array2table(SpeedTotTheory) array2table(YawrateTheory) ];
    % Output Matrix:
%    addDataOut = [numID TimeSecFromBegin inData{:,1:(sizeColrawDataIn-1)}];
       
    
end % end function
