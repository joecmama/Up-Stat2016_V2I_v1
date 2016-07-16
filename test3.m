costID = zeros(totIDTrain,1);
for i=1:totIDTrain
    mynumID = i;
    thetasNumParams = 12;
    % Initial Trial Parameters to use:
    Ax = filledDataTrain{filledDataTrain.numID==mynumID,'Ax'};
    Ay = filledDataTrain{filledDataTrain.numID==mynumID,'Ay'};
    Az = filledDataTrain{filledDataTrain.numID==mynumID,'Az'};
    Vx = filledDataTrain{filledDataTrain.numID==mynumID,'Speed'}./sqrt(3);
    Vy = filledDataTrain{filledDataTrain.numID==mynumID,'Speed'}./sqrt(3);
    Vz = filledDataTrain{filledDataTrain.numID==mynumID,'Speed'}./sqrt(3);
    Longitude = filledDataTrain{filledDataTrain.numID==mynumID,'Longitude'};
    Latitude = filledDataTrain{filledDataTrain.numID==mynumID,'Latitude'};
    Elevation = filledDataTrain{filledDataTrain.numID==mynumID,'Elevation'};
    Heading = filledDataTrain{filledDataTrain.numID==mynumID,'Heading'};
    Yawrate = filledDataTrain{filledDataTrain.numID==mynumID,'Yawrate'};

    % Calculate Cost Function for ID
%    DeltaTime = TimeSecSeparation;
%    totTimeSec = aggDataTrain{aggDataTrain.numID==mynumID,'totTimeSec'};
    thetas = ones(thetasNumParams,1);
    costID(i,1) = costIDFunction(filledDataTrain, aggDataTrain, mynumID, thetas, Ax, Ay, Az, Vx, Vy, Vz, Longitude, Latitude, Elevation, Heading, Yawrate);
end
