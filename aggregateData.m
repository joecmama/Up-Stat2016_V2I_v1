function [aggData totID] = aggregateData(rawData, sizeRowrawData)
% Aggregate Data: Returns Table of aggregated metrics for input rawData,
% and total number of unique ID's.
% with sizeRowrawData number of rows.
% Determine minimum and maximum GentimeSec, and total time in seconds, for each ID
% Determine the beginning position ("x","y","z")=(Longitude, Latitude,
% Elevation) = (xLong, yLat, zElev), which is when GentimeSec =
% min(GentimeSec).

    %1. Initialize
    aggDataVars = {'numID' 'ID' 'minGentimeSec' 'maxGentimeSec' 'totTimeSec'};
%    length(aggDataVars)
    aggData = cell(1, length(aggDataVars));
    totID = 1;
    currID = rawData{1,'ID'};
    minGentimeSec = rawData{1,'GentimeSec'};
    maxGentimeSec = rawData{1,'GentimeSec'};
    % row number of rawData when GentimeSec==minGentimeSec:
    rowNumrawData4minGentimeSec(totID) = 1;
        
%    ID = [currID]; minGentimeSec = [0.0]; maxGentimeSec = [0.0]; totTimeSec = [0.0];
%    aggData = table(ID,minGentimeSec,maxGentimeSec,totTimeSec)
%    aggData.Properties.VariableNames = aggDataVars;


    % 2. Loop through Data to determine min and max of GentimeSec.
    %for i = 1:sizeRowrawData   
    % Can SKIP 1st row, since already processed in initialization
    for i = 2:sizeRowrawData
        % First check if new ID
        if ( strcmp(currID, rawData{i,'ID'}) )   % If same ID
            % Find minimum time for given ID
            if ( rawData{i,'GentimeSec'} < minGentimeSec )
                minGentimeSec = rawData{i,'GentimeSec'};
                rowNumrawData4minGentimeSec(totID) = i;
            end
            % Find maximum time for given ID
            if ( rawData{i,'GentimeSec'} > maxGentimeSec )
                maxGentimeSec = rawData{i,'GentimeSec'};
            end
        else   % If Different ID        
            % Insert data for previous ID first
            aggData(totID,:)= {totID currID minGentimeSec maxGentimeSec (maxGentimeSec-minGentimeSec)};
            % Increment totID
            totID = totID + 1;
            % Reset parameters
            currID = rawData{i,'ID'};
            minGentimeSec = rawData{i,'GentimeSec'};
            rowNumrawData4minGentimeSec(totID) = i;
            maxGentimeSec = rawData{i,'GentimeSec'};
        end

    end % end for loop
    % Special case: Finish last row
    aggData(totID,:) = {totID currID minGentimeSec maxGentimeSec (maxGentimeSec-minGentimeSec)};

    % Final touches
    aggData = cell2table(aggData);
    aggData.Properties.VariableNames = aggDataVars;

    
    % 3. Determine Beginning Positions (xLong, yLat, zElev):
    xLongBeg = NaN(totID,1);
    yLatBeg = NaN(totID,1);
    zElevBeg = NaN(totID,1);
    for (i=1:totID)
        xLongBeg(i) = rawData{rowNumrawData4minGentimeSec(i),'Longitude'};
        yLatBeg(i) = rawData{rowNumrawData4minGentimeSec(i),'Latitude'};
        zElevBeg(i) = rawData{rowNumrawData4minGentimeSec(i),'Elevation'};
    end
%     size(xLongBeg)
%     size(yLatBeg)
%     size(zElevBeg)
%     size(aggData)
    
    % Combine
    aggData = [aggData array2table(xLongBeg) array2table(yLatBeg) array2table(zElevBeg)];
    
end % end function
