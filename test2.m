for i=1:totIDTrain
    mynumID=i; 
    plotIDxVxAxTheory(filledDataTrain(filledDataTrain.numID==mynumID,:), mynumID, aggDataTrain{aggDataTrain.numID==mynumID,'totTimeSec'}, TimeSecSeparation, filledDataTrain(filledDataTrain.numID==mynumID,'Ax'), filledDataTrain(filledDataTrain.numID==mynumID,'Ay'), filledDataTrain(filledDataTrain.numID==mynumID,'Az'));
end
