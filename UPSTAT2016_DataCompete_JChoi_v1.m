% UP-STAT 2016 Data Competition
% By Joseph S. Choi, University of Rochester (The Institute of Optics)
% Due April 1, 2016.

% 0.0. Initial Cleanup
clear all
close all
clc

% 1.0. Import Data
filenameTest = 'DataContestTesting.txt'    % Test data
filenameTrain = 'DataContestTraining.txt'   % Training data
delimiterIn = '\t';
%delimiterIn = ' ';
headerlinesIn = 1;
%rawDataTrain = importdata(filenameTrain,delimiterIn,headerlinesIn);
%rawDataTrain = dlmread(filenameTrain);
%rawDataTrain = readtable(filenameTrain,'Format','%f%f%f%f%f%f%f%f%f%f%s');
rawDataTrain = readtable(filenameTest);
%rawDataTrain = readtable(filenameTrain);
rawDataTrain(1,:)

% 1.1. Initialize Variables
sizerawDataTrain = size(rawDataTrain);
sizeRowrawDataTrain = sizerawDataTrain(1);
sizeColrawDataTrain = sizerawDataTrain(2);
% 1.2. Fixed Parameters
dataFreq = 10; % Units = Hz
TimeSecSeparation = 1/dataFreq; % Separation between data points in Sec.

% 2.0. Aggregate Training Data Initially
[aggDataTrain totIDTrain] = aggregateData(rawDataTrain, sizeRowrawDataTrain);
totIDTrain


% 3.0. Add Data
% 3.1. Add useful data
%rawDataTrain = fillData(rawDataTrain, sizeRowrawDataTrain, sizeColrawDataTrain, aggDataTrain, totIDTrain);
DataTrain = addData(rawDataTrain, sizeRowrawDataTrain, sizeColrawDataTrain, aggDataTrain, totIDTrain);
clear rawDataTrain;


% 4.0. Fill Data
% 4.1. Since some data may be missing, add sufficient rows
filledDataTrain = fillData(DataTrain, TimeSecSeparation);



% 5.0. Plot Data
% 5.1. Plot data for each ID
%scatter(rawDataTrain{:,'TimeSecFromBegin'},rawDataTrain{:,'Latitude'})
plotIDData1(DataTrain, 1);
plotIDData1(filledDataTrain, 1);
plotAllData1(DataTrain, 1, totIDTrain, totIDTrain);
plotAllData1(filledDataTrain, 1, totIDTrain, totIDTrain);

% yy2 = smooth(x,y,0.1,'rloess');
% plot(x,y,'b.',x,yy2,'r-')



% 10.0. Final Output Data
sizefilledDataTrain = size(filledDataTrain);
%OriginalID = NaN(sizefilledDataTrain(1),1);
OriginalID = cell(sizefilledDataTrain(1),1);

for (i = 1:(sizefilledDataTrain(1)))
    rowMatchaggData = (aggDataTrain.numID == filledDataTrain{i,'numID'});
    OriginalID(i) = aggDataTrain{rowMatchaggData,'ID'};
end


finalOutputData = [(filledDataTrain(:,6:(6+sizeColrawDataTrain-2))) cell2table(OriginalID)];
%scatter(finalOutputData{:,'GentimeSec'},finalOutputData{:,'Longitude'});

writetable(finalOutputData,'finalOutputData.txt','Delimiter','\t');
