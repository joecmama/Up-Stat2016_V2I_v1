function [YawrateTheory] = YawrateTheoryCalc(TimeArray, heading)
% Calculate Theoretical Yawrate from Derivative (Physics) for a given ID.
%
% INPUT:
% - TimeArray = Array for Time for heading.
% - heading = Heading values to use to calculate Yawrate.
% OUTPUT:
% - YawrateTheory: Theoretical Yawrate as a function of time.
% - TimeArray: Array of Time for the given ID.
% ASSUMPTIONS:
% 1) Initial (x, y, z) = (0,0,0) and Initial t=0. This should be the case
% after processing through fillData.
% => So xTheory, yTheory, zTheory represent the difference between position
% at time=t and time=0.
% 2) DeltaTime = Fixed. 
%     e.g.) DeltaTime =  IDData{(j),'TimeSecFromBegin'} - tmpIDData{(j-1),'TimeSecFromBegin'};

    %1. Initialize
    %1.1. First store Data for given mynumID
    sizeIDData = size(TimeArray);
    totRows = sizeIDData(1);  %round(IDtotTimeSec/DeltaTime) + 1;   % Add 1 row for t=0; sizeIDData(1);
    %1.2. Initialize
    YawrateTheory = zeros(totRows,1);

    
    % 2.0. Calculate Theoretical Hypotheses.
    % 2.1. Calculate: Yawrate(t) = dheading(t)/dt.
    for (i=1:(totRows-1))
        DeltaTime = TimeArray(i+1) - TimeArray(i);
        if (DeltaTime ==0)
            YawrateTheory(i,1) = 0;
        else
            YawrateTheory(i,1) = (heading(i+1,1) - heading(i,1))/DeltaTime;        
        end
    end
    % Just assume Last value for Yawrate is same as the one before:
    YawrateTheory(totRows,1) = YawrateTheory(totRows-1,1); 
    % 2.2. Calculate: Ax(t) = dVx(t)/dt.

    
end % end function
