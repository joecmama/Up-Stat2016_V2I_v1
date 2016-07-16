function [VxTheory, AxTheory] = VxAxTheory(TimeArray, x)
% Calculate Theoretical speed (Vx) and acceleration (Ax) for one direction
% from Derivative (Physics) for a given ID.
% Use example: mynumID=1;[VxTheory, AxTheory] = VxAxTheory(filledDataTrain{filledDataTrain.numID==mynumID,'TimeSecFromBegin'}, filledDataTrain{filledDataTrain.numID==mynumID,'xLongFromBegin'});
% INPUT:
% - TimeArray = Array for Time for x.
% - x = Position values to use to calculate Vx, Ax.
% OUTPUT:
% - VxTheory: Theoretical Vx (speed in x) as a function of time.
% - AxTheory: Theoretical Ax (acceleration in x) as a function of time.
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
    VxTheory = zeros(totRows,1);
    AxTheory = zeros(totRows,1);

    
    % 2.0. Calculate Theoretical Hypotheses.
    % 2.1. Calculate: Vx(t) = dx(t)/dt.
    for (i=1:(totRows-1))
        DeltaTime = TimeArray(i+1) - TimeArray(i);
        if (DeltaTime ==0)
            VxTheory(i,1) = 0;
        else
            VxTheory(i,1) = (x(i+1,1) - x(i,1))/DeltaTime;        
        end
    end
    % Just assume Last value for Vx is same as the one before:
    VxTheory(totRows,1) = VxTheory(totRows-1,1); 
    % 2.2. Calculate: Ax(t) = dVx(t)/dt.
    for (i=1:(totRows-2))
        DeltaTime = TimeArray(i+1) - TimeArray(i);
        if (DeltaTime ==0)
            AxTheory(i,1) = 0;
        else
            AxTheory(i,1) = (VxTheory(i+1,1) - VxTheory(i,1))/DeltaTime;
        end
    end
    % Just assume Last 2 values for Ax is same as the one before:
    AxTheory(totRows,1) = AxTheory(totRows-2,1); 
    AxTheory(totRows-1,1) = AxTheory(totRows-2,1); 

    
end % end function
