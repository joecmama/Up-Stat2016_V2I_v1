#(1) Created by Brian Roach
#(2) Creation date: [1] "Tue Jul 19 21:16:58 2016" (adapted univariate script)
#(3) Purpose:
#	This script was created to try the Shumway-Stoffer Kalman
#	smoother for missing data problems (1982) using the data
#	that were originally provided.  This is an alternative to the
# multivariate approach
#
#	A few variables are edited at the top to either load
#	training data or testing data, then the script runs
#	and generates a data.frame called "outputDF".  This
#	dataframe contains all the solutions, stacked, in the
#	same order with the same formatting as the input data
#	sets.
#
# This version is modified to also generate smoothed "Heading" variable, 
# in degrees,  and Yawrate variable along with the non-smoothed (raw) data values in the 
# appropriate time locations.
#
#(4)Last executed: "Tue Jul 19 22:34:58 2016"

#the data are stored here (change to your path):
setwd("C:/Users/Brian/Documents/up-stat/UPSTAT2016_DataContest/")

#Options here are to load and estimate models for the training data or the testing data:
#---------------------------------------------------------------------------------------
#load the training data:
#data<-read.delim(file="DataContestTraining.txt")
#solutionFileName="DataContestTraining_solution.csv"

#...or the test data:
#data<-read.delim(file="DataContestTesting.txt")
#solutionFileName="DataContestTesting_solution.csv"

#or do both at once:
data1<-read.delim(file="DataContestTraining.txt")
data2<-read.delim(file="DataContestTesting.txt")

data<- rbind(data1,data2)
solutionFileName="DataContestCombined_original_xyz_Univariate_v1a.csv"

#There should be no need to modify code from here if all goes well...
#---------------------------------------------------------------------------------------

#> names(data)
# [1] "Latitude"   "Longitude"  "Elevation"  "Speed"      "Heading"   
# [6] "Ax"         "Ay"         "Az"         "Yawrate"    "GentimeSec"
#[11] "ID" 

#names(data)
attach(data)

#initialize an output dataframe:
outputDF <- data.frame()

#the sampling rate is fixed at 10Hz
srate <- 10

#use formula provided for conversion of distance between 
#lat/lon pairs to meters:

#Here is a handy R-function that implements a distance calculation for two points on a great circle, returned in meters using the Spherical Law of Cosines:
LatLon2Dist = function(Lon1, Lat1, Lon2, Lat2){
  point1.lat.rad = Lat1*pi/180
  point1.lon.rad = Lon1*pi/180
  point2.lat.rad = Lat2*pi/180
  point2.lon.rad = Lon2*pi/180
  d = acos(sin(point1.lat.rad)*sin(point2.lat.rad)+cos(point1.lat.rad)*cos(point2.lat.rad)*cos( point2.lon.rad-point1.lon.rad))*6371000
  return(d)
}


#convert angle to sine and cosine values
cosHeading<-cos(Heading)
sinHeading<-sin(Heading)

#not sure that will be useful, but let's unwrap the
#jump discontinuities in the angle data:

#need signal package for this:
library(signal)

#convert from 0-360degrees to 0 to 2pi radians:
rHeading <- Heading*(pi/180)
unHeading <-unwrap(rHeading)

tIDs<- unique(ID)

#need the time series package:
library(astsa)

#initialize some summary statistics for a table, such as:
#1. counts of EM convergence
#2. number of CCA rejected components
#u<-1
converged <- matrix(0, nrow=length(tIDs),ncol=9)

nbad<- rep(0, length(tIDs))

#summary matricies:
sumQ = matrix(0,9,9)
sumPhi=sumQ
sumR = sumQ
nP = sumQ


for (u in 1:length(tIDs)){
  
  #This is for plotting (comment out in solution file):
  #png(filename = paste(tIDs[u], "_KalmanCov1.png",sep=""),  width = 1280, height = 800)
  #par(mfrow=c(3,3))
  
  
  #determine which time points are missing
  utime<-round((GentimeSec[ID==tIDs[u]]-GentimeSec[ID==tIDs[u]][1])/.1)
  #initialize vectors with space for missing values:
  #+1 is because utime starts at t=0
  ulat<-rep(0,max(utime)+1)
  ulon<-ulat
  uElv<-ulat
  uSpd<-ulat
  ucos<-ulat
  usin<-ulat
  uhead<-ulat
  uAx<-ulat
  uAy<-ulat
  uAz<-ulat
  uYaw<-ulat
  
  #insert the observed values in the appropriate locations:
  #ulat[utime+1]<-(Latitude[ID==tIDs[u]] - mean(Latitude[ID==tIDs[u]]))/sd(Latitude[ID==tIDs[u]])
  slat<-scale(Latitude[ID==tIDs[u]])
  ulat[utime+1]<-slat
  
  slon<-scale(Longitude[ID==tIDs[u]])
  ulon[utime+1]<-slon
  
  sElv<-scale(Elevation[ID==tIDs[u]])
  uElv[utime+1]<-sElv
  
  sSpd<-scale(Speed[ID==tIDs[u]])
  uSpd[utime+1]<-sSpd
  
  shead<-scale(unHeading[ID==tIDs[u]])
  uhead[utime+1]<-shead
  
  sAx<-scale(Ax[ID==tIDs[u]])
  uAx[utime+1]<-sAx
  
  sAy<-scale(Ay[ID==tIDs[u]])
  uAy[utime+1]<-sAy
  
  sAz<-scale(Az[ID==tIDs[u]])
  uAz[utime+1]<-sAz
  
  sYaw<-scale(Yawrate[ID==tIDs[u]])
  uYaw[utime+1]<-sYaw
  
  #Note: values were z-scored up there...
  
  #I need the original data to estimate 
  #the covariance matrix and check for
  #time series variables that are constant
  origY<-cbind(Latitude[ID==tIDs[u]],
               Longitude[ID==tIDs[u]],
               Elevation[ID==tIDs[u]],Speed[ID==tIDs[u]],
               unHeading[ID==tIDs[u]],
               Ax[ID==tIDs[u]],Ay[ID==tIDs[u]],Az[ID==tIDs[u]],
               Yawrate[ID==tIDs[u]])
  
  #use Shumway Example 6.9 code from http://www.stat.pitt.edu/stoffer/tsa3/Rexamples.htm
  #...modified for our 10 variable cases:
  y = cbind(ulat,ulon,uElv,uSpd,uhead,uAx,uAy,uAz,uYaw)
  #y = cbind(ulat,ulon,uElv,uSpd,ucos,usin,uAx,uAy,uAz,uYaw)
  #exclude 0 variance (constant) variables:
  #emInc<-which(diag(cov(origY))>0)
  emInc<-which(diag(cov(y[utime+1,]))>0)
  y<-y[,emInc]
  
  num = nrow(y)       
  ncol=dim(y)[2]
  smoothData<- matrix(0,ncol=num, nrow=ncol)
  A = array(0, dim=c(ncol,ncol,num))  # creates nxn zero matrices
  for(k in 1:num) if (abs(y[k,1]) > 0) A[,,k]= diag(1,ncol) 
  
# Initial values 

#mu0 = matrix(0,ncol,1) #thought 0 made some sense for z-scored values
mu0 = matrix(y[1,], ncol, 1)
#Sigma0 = diag(diag(cov(y[utime+1,])),ncol) 
Sigma0 = cov(y)
#Sigma0= diag(1,ncol) 
#cov(origY[,emInc]) 
#diag(c(.1,.1,1),3)

#use the real single sample (100ms) transitions to estimate
#the transition matrix, Phi:
Phi = diag(colMeans(y),ncol)

cQ = diag(1,ncol)
#diag(1,ncol)/2 
#diag(c(.1,.1,1),3)

cR = diag(1,ncol) #diag(c(.1,.1,1),3)  
for (tp in 1:length(emInc)){
  tpi <- emInc[tp]
  
  #obtain maximum liklihood estimators:
  emA = emA = EM1(num=num,y=y[,tp],array(data=A[1,1,], dim=c(1,1,num)),mu0=y[1,tp],Sigma0=1,Phi=Phi[tp,tp],cQ=1,cR=1,max.iter=50,tol=.01)
  
  ##2nd pass - if it doesn't converge, at least we have initial 25 iteration solution
  emt = try(EM1(num=num,y=y[,tp],array(data=A[1,1,], dim=c(1,1,num)),mu0=emA$mu0,Sigma0=emA$Sigma0,Phi=emA$Phi,cQ=chol(emA$Q),cR=chol(emA$R),max.iter=100,tol=.01))
  
  
  if (class(emt)!="try-error"){
    #update MLEs:
    emA <- emt
    converged[u,tpi] = 1
  } else {
    converged[u,tpi] = 0
  }
  
  #ksA <- Ksmooth0(num,ts(y[,tp]),1,emA$mu0, emA$Sigma0, emA$Phi, emA$Q, emA$R)
  ksA <- Ksmooth1(num,y[,tp],array(data=A[1,1,], dim=c(1,1,num)),emA$mu0, emA$Sigma0, emA$Phi,0,0, emA$Q, emA$R,0)
  
  #get smoothed data:
  smoothData[tp,]<-ksA$xs[1,1,]
  
  y1s = smoothData[tp,]
  
  plot(y[,tp], type="p", pch=19, xlab="sample", ylab=names(data)[emInc[tp]], col="red")
  lines(lowess(y[,tp],f=10/num)$y,col="green", lwd=2)
  lines(ksA$xs[1,1,],col="purple",lwd=3)
  
  
  #store estimated values:
  sumQ[emInc[tpi],emInc[tpi]] <- sumQ[emInc[tpi],emInc[tpi]] + emA$Q
  sumR[emInc[tpi],emInc[tpi]] <- sumR[emInc[tpi],emInc[tpi]] + emA$R
  sumPhi[emInc[tpi],emInc[tpi]] <- sumPhi[emInc[tpi],emInc[tpi]] + emA$Phi
  nP[emInc[tpi],emInc[tpi]] <- nP[emInc[tpi],emInc[tpi]] + 1
}

#1
if(any(emInc==1)){
  #Transform Latitude from z-scores to degree units:
  smoothLatitude = (smoothData[which(emInc==1),]*attributes(slat)[[3]])+attributes(slat)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothLatitude = attributes(slat)[[2]]
}

#2
if(any(emInc==2)){
  #Transform Longitude from z-scores to degree units:
  smoothLongitude = (smoothData[which(emInc==2),]*attributes(slon)[[3]])+attributes(slon)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothLongitude = attributes(slon)[[2]]
}


#3 
if(any(emInc==3)){
  #Transform Elevation from z-scores to original units:
  smoothElevation = (smoothData[which(emInc==3),]*attributes(sElv)[[3]])+attributes(sElv)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothElevation = attributes(sElv)[[2]]
}

#4 
if(any(emInc==4)){
  #Transform Speed from z-scores to original units:
  smoothSpeed = (smoothData[which(emInc==4),]*attributes(sSpd)[[3]])+attributes(sSpd)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothSpeed = attributes(sSpd)[[2]]
}

#5 
if(any(emInc==5)){
  #Transform heading from z-scores to original, unwrapped units:
  smoothHeading = (smoothData[which(emInc==5),]*attributes(shead)[[3]])+attributes(shead)[[2]]
  #then wrap them back to nearly original form and transform to degrees:
  smoothHeading = (smoothHeading%%(2*pi))*(180/pi)
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothHeading = attributes(shead)[[2]]
  #then wrap them back to nearly original form and transform to degrees:
  smoothHeading = (smoothHeading%%(2*pi))*(180/pi)
}

#6
if(any(emInc==6)){
  #Transform Ax from z-scores to original units:
  smoothAx = (smoothData[which(emInc==6),]*attributes(sAx)[[3]])+attributes(sAx)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothAx = attributes(sAx)[[2]]
}

#7
if(any(emInc==7)){
  #Transform Ay from z-scores to original units:
  smoothAy = (smoothData[which(emInc==7),]*attributes(sAy)[[3]])+attributes(sAy)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothAy = attributes(sAy)[[2]]
}

#8
if(any(emInc==8)){
  #Transform Az from z-scores to original units:
  smoothAx = (smoothData[which(emInc==8),]*attributes(sAz)[[3]])+attributes(sAz)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothAz = attributes(sAz)[[2]]
}

#9
if(any(emInc==9)){
  #Transform Yawrate from z-scores to original units:
  smoothYawrate = (smoothData[which(emInc==9),]*attributes(sYaw)[[3]])+attributes(sYaw)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothYawrate = attributes(sYaw)[[2]]
}

#Transform utime values back to GentimeSec values:
smoothGentimeSec = (0:max(utime) * 0.1) + GentimeSec[ID==tIDs[u]][1]

#and don't forget the ID:
smoothID <- rep(tIDs[u], length(smoothYawrate))

#stitch them all together in a data frame for this ts
#(could be used for saving/checking single case solutions)
uDF <- data.frame(numID=u,cbind(smoothLatitude, smoothLongitude, smoothElevation, 
                        smoothSpeed, smoothHeading, smoothAx, smoothAy, smoothAz,
                        smoothYawrate, smoothGentimeSec), ID=as.character(smoothID))

write.table(uDF,
            file=paste("numID",u,solutionFileName, sep=""), sep=",", row.names = FALSE)
#Finally, stack solutions:
#e.g. rbind(data.frame(matrix(0,6,6)),data.frame(matrix(0,6,6)))
#outputDF<- rbind(outputDF, uDF)

}

nP
nP/length(tIDs)
sumPhi/nP
sumQ/nP
sumR/nP

#write out the solution, if you'd like to:
#write.table(outputDF, file=solutionFileName, sep=",", row.names = FALSE)
#
#write.table(cbind(outputDF,data), file="DataContestCombined_combinedMultivariate_v2a.csv", sep=",", row.names = FALSE)


detach(data)