% UP-STAT 2016 Data Competition
% By Joseph S. Choi, University of Rochester (The Institute of Optics)
% Original Data Contest due April 1, 2016.
% Combine Brian Roach's code with Joseph Choi's to smooth and make
% physically valid.
% *************************************************************************
% This portion is for Step v2a&b, v3a (After derived V, A, Yawrate from Brian's 
% interpolation and smoothing of raw data with Kalman Smoothing + Lowess.
% I simply try to smooth V with RLoess, then derive A, then smooth A.
% 0.0. Initial Cleanup
clear all
close all
clc

% 1.0. Import Previous set of Data
% 1.1. Initialize
filename_v1b = 'finalOutputData_v1b.txt';
delimiterIn = '\t';
headerlinesIn = 1;
% 1.2. Initially set up Table
DataIn_v1b = readtable(filename_v1b, 'Delimiter', delimiterIn, 'ReadVariableNames', headerlinesIn);
DataIn_v1b(1,:)

% 1.1. Initialize Variables
sizerawDataIn = size(DataIn_v1b);
sizeRowrawDataIn = sizerawDataIn(1);
sizeColrawDataIn = sizerawDataIn(2);
% 1.2. Fixed Parameters
dataFreq = 10; % Units = Hz  (Manually input, using ideal device rate)
TimeSecSeparation = 1/dataFreq; % Separation between data points in Sec.
SpanNumPoints = 30; % Number of Data Points (in time) to Span for Smoothing in Lowess/Loess.
% 1.3 Aggregate Data (Remove when combining all procedures):
[aggDataIn totIDIn] = aggregateData(DataIn_v1b, sizeRowrawDataIn);
totIDIn

% 2.0. Loess, Lowess, or rLoess, rLowess Smooth Velocity
smoothVel_v2a_Out = smoothVel_v2a(DataIn_v1b, aggDataIn, SpanNumPoints);


% % 6.0. Plot Data
% % 6.1. Plot data for each ID
% %scatter(rawDataIn{:,'TimeSecFromBegin'},rawDataIn{:,'Latitude'})
% plotIDData1(DataIn, 1);
% plotIDData1(filledDataIn, 1);
% plotAllData1(DataIn, 1, totIDIn, totIDIn);
% plotAllData1(filledDataIn, 1, totIDIn, totIDIn);
% 
% % yy2 = smooth(x,y,0.1,'rloess');
% % plot(x,y,'b.',x,yy2,'r-')
for i=1:totIDIn
    mynumID=i
    plotIDxVxSpeed_v1a(smoothVel_v2a_Out, mynumID);
end
% disp('Before break');
% break;
% disp('After break');



% 10.0. Final Output Data
% ---------------------------------------------
% NOTE: May not need following if Original ID already included:
% sizefilledDataIn = size(filledDataIn);
% %OriginalID = NaN(sizefilledDataIn(1),1);
% OriginalID = cell(sizefilledDataIn(1),1);
% 
% for (i = 1:(sizefilledDataIn(1)))
%     rowMatchaggData = (aggDataIn.numID == filledDataIn{i,'numID'});
%     OriginalID(i) = aggDataIn{rowMatchaggData,'ID'};
% end
% 
% finalOutputData = [(filledDataIn(:,6:(6+sizeColrawDataIn-2))) cell2table(OriginalID)];
% %scatter(finalOutputData{:,'GentimeSec'},finalOutputData{:,'Longitude'});
%
% writetable(finalOutputData,'finalOutputData.txt','Delimiter','\t');
% ---------------------------------------------

writetable(filledDataIn,'finalOutputData_v1a.txt','Delimiter','\t');
