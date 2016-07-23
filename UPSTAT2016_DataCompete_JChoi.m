% UP-STAT 2016 Data Competition
% By Joseph S. Choi, University of Rochester (The Institute of Optics)
% Original Data Contest due April 1, 2016.
% Combine Brian Roach's code with Joseph Choi's to smooth and make
% physically valid.

% 0.0. Initial Cleanup
clear all
close all
clc

% 1.0. Import Data smoothed by Kalman Filter (Brian Roach's R code)
filenameImport = 'test1\numID1DataContestCombined_original_xyz_lowess_v1a.csv'
delimiterIn = ',';
headerlinesIn = 1;
rawDataIn = readtable(filenameImport, 'Delimiter', delimiterIn, 'ReadVariableNames', headerlinesIn);
rawDataIn(1,:)

% 1.1. Initialize Variables
sizerawDataIn = size(rawDataIn);
sizeRowrawDataIn = sizerawDataIn(1);
sizeColrawDataIn = sizerawDataIn(2);
% 1.2. Fixed Parameters
dataFreq = 10; % Units = Hz  (Manually input, using ideal device rate)
TimeSecSeparation = 1/dataFreq; % Separation between data points in Sec.

% 2.0. Aggregate Data Initially
[aggDataIn totIDIn] = aggregateData(rawDataIn, sizeRowrawDataIn);
totIDIn


% 3.0. Add Data
% 3.1. Add useful data
%rawDataIn = fillData(rawDataIn, sizeRowrawDataIn, sizeColrawDataIn, aggDataIn, totIDIn);
DataIn = addData(rawDataIn, sizeRowrawDataIn, sizeColrawDataIn, aggDataIn, totIDIn);
%clear rawDataIn;


% NOT NECESSARY: Brian Roach's Kalman Filtering interpolates.
% 4.0. Fill Data
% 4.1. Since some data may be missing, add sufficient rows
%filledDataIn = fillData(DataIn, TimeSecSeparation);


% 5.0. Clean Data
% 5.1. Acceleration, Speed, Yaw Rate not correct, let alone smooth.  For example,
% many Ay = 10m/s^2 or 20m/s^2 greater than free fall on earth!
% Acceleration, Speed, Yaw Rate are "estimated" data anyways, so calculate from
% position and heading.
% 5.2. Calculate Velocity, Acceleration, Speed, and add to data set.
filledDataIn = addVelAccYawTheoryData(DataIn, aggDataIn);



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
    plotIDxVxAxHeadYawTheory(filledDataIn, mynumID);
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

writetable(filledDataIn,'finalOutputData.txt','Delimiter','\t');
