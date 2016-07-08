function [fillDataOut] = fillData(inData, TimeSecSeparation)
% Fill Data: Returns Table of filled in Data:
% INPUT:
% - inData: input Data set AFTER addData() processing.
% - TimeSecSeparation: Separation between each rows in time.
% FUNCTIONS:
% 1) Fill in missing data points with interpolated Data.
% ASSUMPTIONS:
% 1) TimeSecSeparation = Constant between each row.


    %1. Initialize
    countNewRow = 0;    % Index for row in new fillDataOut
    fillDataOut = [inData(1,:)];
%    countAddlRow = 0;   % Only count number of NEW rows added.
    sizeData = size(inData);
    sizeRowData = sizeData(1);
    sizeColData = sizeData(2);
%    fillDataOut = inData;
    
    % 2. Loop through Data
    for i = 1:(sizeRowData-1)
        % 2.1. Copy original Data row
        countNewRow = countNewRow + 1;
        fillDataOut(countNewRow,:) = [inData(i,:)];
        % 2.2. First check that next row is the same ID
        if ( inData{i,'numID'} == inData{i+1,'numID'} )
            % 2.3.1. Calculate time difference between current and next row:
            currTimeSep = (inData{i+1,'TimeSecFromBegin'}-inData{i,'TimeSecFromBegin'});
            % 2.3.2 Check to see if there is missing data after this row.
            if ( currTimeSep > TimeSecSeparation )
                % Determine number of rows to insert
                numRowsInsert = round(currTimeSep/TimeSecSeparation);
                % Interpolate Linearly initially.
                for (j=1:(numRowsInsert-1))
                    InterpolatedData = ( j*inData{i+1,2:sizeColData} + (numRowsInsert-j)*inData{i,2:sizeColData} )/numRowsInsert;
                    % Increment countNewRow
                    countNewRow = countNewRow + 1;
                    fillDataOut(countNewRow,:) = [ (inData(i,1)) array2table(InterpolatedData) ];
%                    fillDataOut = insertrows( fillDataOut, [ (inData(i,1)) array2table(InterpolatedData) ], (i+countAddlRow) );
%                    % Need to increment after the insertrows()
%                    countAddlRow = countAddlRow + 1;
                end
            end
        end

    end % end for loop

    % Finish last row
    countNewRow = countNewRow +1;
    fillDataOut(countNewRow,:) = [ (inData(sizeRowData,:)) ];
     
    
end % end function
