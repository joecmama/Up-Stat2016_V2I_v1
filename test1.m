selectedRow1 = (filledDataTrain.numID==1 & filledDataTrain.TimeSecFromBegin==0);
selectedRow2 = (filledDataTrain.numID==1 & abs(filledDataTrain.TimeSecFromBegin-TimeSecSeparation)<(0.1*TimeSecSeparation));
Vx0 = ( filledDataTrain{selectedRow2,'xLongFromBegin'} - filledDataTrain{selectedRow1,'xLongFromBegin'} ) / TimeSecSeparation
Vy0 = ( filledDataTrain{selectedRow2,'yLatFromBegin'} - filledDataTrain{selectedRow1,'yLatFromBegin'} ) / TimeSecSeparation
Vz0 = ( filledDataTrain{selectedRow2,'zElevFromBegin'} - filledDataTrain{selectedRow1,'zElevFromBegin'} ) / TimeSecSeparation
[xTheory, VxTheory, TimeArray1] = xVxTheory(aggDataTrain{aggDataTrain.numID==1,'totTimeSec'}, TimeSecSeparation, filledDataTrain{filledDataTrain.numID==1,'Ax'}, Vx0);
[yTheory, VyTheory, TimeArray1] = xVxTheory(aggDataTrain{aggDataTrain.numID==1,'totTimeSec'}, TimeSecSeparation, filledDataTrain{filledDataTrain.numID==1,'Ay'}, Vy0);
[zTheory, VzTheory, TimeArray1] = xVxTheory(aggDataTrain{aggDataTrain.numID==1,'totTimeSec'}, TimeSecSeparation, filledDataTrain{filledDataTrain.numID==1,'Az'}, Vz0);

speed1 = sqrt(VxTheory.^2 + VyTheory.^2);
speedTot = sqrt(VxTheory.^2 + VyTheory.^2 + VzTheory.^2);

figure(999);
subplotcols = 3;
subplotrows = 3;

subplot(subplotrows,subplotcols,1);
scatter(TimeArray1, xTheory);
subplot(subplotrows,subplotcols,2);
scatter(TimeArray1, yTheory);
subplot(subplotrows,subplotcols,3);
scatter(TimeArray1, zTheory);

subplot(subplotrows,subplotcols,4);
scatter(TimeArray1, VxTheory);
subplot(subplotrows,subplotcols,5);
scatter(TimeArray1, VyTheory);
subplot(subplotrows,subplotcols,6);
scatter(TimeArray1, VzTheory);

subplot(subplotrows,subplotcols,7);
scatter(TimeArray1, speed1,'.','r');
subplot(subplotrows,subplotcols,8);
scatter(TimeArray1, speedTot,'.','r');

% subplot(subplotrows,subplotcols,7);
% scatter(TimeArray1, Ax);
% subplot(subplotrows,subplotcols,8);
% scatter(TimeArray1, Ay);
% subplot(subplotrows,subplotcols,9);
% scatter(TimeArray1, Az);
