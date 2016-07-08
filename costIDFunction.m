function costID = costIDFunction(inData, mynumID, Ax, Ay, Az, Vx, Vy, Longitude, Latitude, Elevation, Heading, Yawrate)
% Calculate Cost for given mynumID: Goal is to minimize this cost through optimization.
% INPUT:
% - inData: input Data set
% - mynumID: numID to evaluate Cost
% ASSUMPTIONS:
% 1) Initial (x, y, z) = (0,0,0) and Initial t=0. This should be the case
% after processing through fillData.
% => So xTheory, yTheory, zTheory represent the difference between position
% at time=t and time=0.

    %1. Initialize
    %1.1. First store Data for given mynumID
    tmpIDData = inData((inData.numID==mynumID),:);
    sizeIDData = size(tmpIDData);
    totRows = sizeIDData(1);
    %1.2. Initialize
    xTheory = NaN(totRows,1);
    yTheory = NaN(totRows,1);
    zTheory = NaN(totRows,1);
    VxTheory = NaN(totRows,1);
    VyTheory = NaN(totRows,1);
    
    
    
    
    
    
    
    % Calculate Theoretical Hypotheses.
    % x(t) = x(0) + Vx(0)*t + Int((Int(Ax(t''),t''=0,t''=t'),t'=0,t'=t)
    % Integral of Ax portion Initialize
    integAxArray = zeros(totRows,1);
    integAxSum = 0.0;
    DeltaTime = 0.0;
    for (i=1:(totRows-1))
        for (j=1:i)
            DeltaTime =  tmpIDData{(j+1),'TimeSecFromBegin'} - tmpIDData{j,'TimeSecFromBegin'};
            integAxSum = integAxSum + (Ax(j)*DeltaTime);
        end
        integAxArray(i) =  integAxSum
    end    
    xTheory = Vx(1)*tmpIDData(:,'TimeSecFromBegin') 
    
    
    
    
    
    
    
    
    
    numID = NaN(sizeRowrawData,1);
    TimeSecFromBegin = NaN(sizeRowrawData,1);
    xLongFromBegin = NaN(sizeRowrawData,1);
    yLatFromBegin = NaN(sizeRowrawData,1);
    zElevFromBegin = NaN(sizeRowrawData,1);
    currnumID = 1;
    currID = aggData{1,'ID'};
    minGentimeSec = aggData{1,'minGentimeSec'};
    xLongBeg = aggData{1,'xLongBeg'};
    yLatBeg = aggData{1,'yLatBeg'};
    zElevBeg = aggData{1,'zElevBeg'};


    % 2. Loop through Data
    for i = 1:sizeRowrawData   
        % First check if new ID
        if ( ~strcmp(currID, inData{i,'ID'}) )   % If Different ID
            currnumID = currnumID + 1;
            % Reset parameters
            currID = aggData{currnumID,'ID'};
            minGentimeSec = aggData{currnumID,'minGentimeSec'};
            xLongBeg = aggData{currnumID,'xLongBeg'};
            yLatBeg = aggData{currnumID,'yLatBeg'};
            zElevBeg = aggData{currnumID,'zElevBeg'};
        end
        
        numID(i) = [currnumID];
        TimeSecFromBegin(i) = [(inData{i,'GentimeSec'} - minGentimeSec)];
        % Need to convert from angles of Longitude & Latitude to length for
        % (x,y)
        xLongFromBegin(i) = LatLon2Dist(xLongBeg, yLatBeg, inData{i,'Longitude'}, yLatBeg);
        yLatFromBegin(i) = LatLon2Dist(xLongBeg, yLatBeg, xLongBeg, inData{i,'Latitude'});
        zElevFromBegin(i) = [(inData{i,'Elevation'} - zElevBeg)];

    end % end for loop

    % Final Output: Remove ID and replaced with number ID
%    fillDataOut = [array2table(TimeSecFromBegin) inData(:,1:(sizeColrawDataTrain-1))];
    % Output Table:
    fillDataOut = [array2table(numID) array2table(TimeSecFromBegin) array2table(xLongFromBegin) array2table(yLatFromBegin) array2table(zElevFromBegin) inData(:,1:(sizeColrawDataTrain-1))];
    % Output Matrix:
%    fillDataOut = [numID TimeSecFromBegin inData{:,1:(sizeColrawDataTrain-1)}];
       
    
end % end function
