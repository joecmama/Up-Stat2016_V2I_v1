function [xTheory, VxTheory] = xVxTheory(TimeArray, Ax, Vx0)
% Calculate Theoretical x position and speed (Vx) from Integration (Physics) for a given ID.
% Use example:
% [xTheory, VxTheory] = xVxTheory(filledDataTrain{filledDataTrain.numID==mynumID,'TimeSecFromBegin'}, filledDataTrain{filledDataTrain.numID==mynumID,'Ax'}, 0);
% INPUT:
% - TimeArray = Array for Time for Ax.
% - Ax = Initial starting values for Ax.
% - Vx0 : Initial Vx, i.e. Vx(t=0)
% OUTPUT:
% - xTheory: Theoretical x (position) as a function of time.
% - VxTheory: Theoretical Vx (speed in x) as a function of time.
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
    xTheory = NaN(totRows,1);
    VxTheory = NaN(totRows,1);
 
    
    % 2.0. Calculate Theoretical Hypotheses.
    % 2.1. Calculate: x(t) = x(0) + Vx(0)*t + Int((Int(Ax(t''),t''=0,t''=t'),t'=0,t'=t)
    % 2.2. Calculate: Vx(t) = Vx(0) + (Int(Ax(t'),t'=0,t'=t)
    % Integral of Ax, Ay portion Initialize
    integAx2Array = zeros(totRows,1);   % Outer integral for Ax
    integAx1Sum = zeros(totRows,1);  % Inner Integral for Ax.
    % 2.2. Calculate Double Integral:
    % Skip 1st row.  
    for (i=2:(totRows))
        DeltaTime = TimeArray(i) - TimeArray(i-1);
        % Integrate the Inner Integral.
        integAx1Sum(i) = integAx1Sum(i-1) + (Ax(i-1)*DeltaTime);
        % Integrate Outer Integral
        integAx2Array(i) = integAx2Array(i-1) + (integAx1Sum(i) * DeltaTime);
    end
    % Since (x,y,z,)(t=0)=(0,0,0):
%    xTheory = Vx0*IDData(:,'TimeSecFromBegin') + integAxArray(:);
    xTheory = Vx0*TimeArray(:) + integAx2Array(:);
    VxTheory = Vx0 + integAx1Sum(:);

    
end % end function
