function [addDataOut] = addData(inData, sizeRowrawData, sizeColrawDataIn, aggData, totID)
% Fill Data: Returns Table of added Data:
% INPUT:
% - inData: input Data set
% - sizeRowrawData = number of rows for inData.
% - sizeColrawDataIn = number of columns for inData.
% - aggData: Aggregate Data for input Data set
% - totID = number of rows for aggData, which is the total number of unique ID's.
% FUNCTIONS:
% 0) Replace numID (number) with ID (string)
% 1) TimeSecFromBegin: Add column for time (sec) since beginning of measurement for each ID.
% 2) (xLong,yLat,zElev) position (in "(x,y,z)") where (0,0,0) is when GentimeSec == min(GentimeSec).
% NOTE:
% A) To calculate the position “(x,y,z)” in units of length, we convert from the angles in (Longitude, Latitude, Elevation) as follows:
% -	Use the Law of Cosine for 1 coordinate at a time.  For example, to obtain “x”, we fix Latitude (“y”) and only obtain the distance using the Longitude change from the origin.
% -	For “z”, we simply use Elevation which is already in units of length.


    %1. Initialize
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
        TimeSecFromBegin(i) = [(inData{i,'smoothGentimeSec'} - minGentimeSec)];
        % Need to convert from angles of Longitude & Latitude to length for
        % (x,y)
        xLongFromBegin(i) = LatLon2Dist(xLongBeg, yLatBeg, inData{i,'smoothLongitude'}, yLatBeg);
        yLatFromBegin(i) = LatLon2Dist(xLongBeg, yLatBeg, xLongBeg, inData{i,'smoothLatitude'});
        zElevFromBegin(i) = [(inData{i,'smoothElevation'} - zElevBeg)];

    end % end for loop

    % Final Output: Remove ID and replaced with number ID
%    addDataOut = [array2table(TimeSecFromBegin) inData(:,1:(sizeColrawDataIn-1))];
    % Output Table:
    addDataOut = [array2table(numID) array2table(TimeSecFromBegin) array2table(xLongFromBegin) array2table(yLatFromBegin) array2table(zElevFromBegin) inData(:,1:(sizeColrawDataIn-1))];
    % Output Matrix:
%    addDataOut = [numID TimeSecFromBegin inData{:,1:(sizeColrawDataIn-1)}];
       
    
end % end function
