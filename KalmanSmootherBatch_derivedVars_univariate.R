#(1) Created by Brian Roach
#(2) Creation date: [1] "Sun Jul 17 20:36:43 2016" (adapted from multivariate script)
#(3) Purpose:
#	This script was created to try the Shumway-Stoffer Kalman
#	smoother for missing data problems (1982) using the data
#	that were derived from xyz variables in a previous Kalman smoother
# batch
#
#	A few variables are edited at the top to either load
#	training data or testing data, then the script runs
#	and generates a data.frame called "outputDF".  This
#	dataframe contains all the solutions, stacked, in the
#	same order with the same formatting as the input data
#	sets.
#
# This version is modified to use only one variable's time
# series at a time to estimate kalman smoothed values with
# the EM0 and Ksmooth0 functions from astsa
#
#(4)Last executed: "Sun Jul 17 20:56:25 2016"

#the data are stored here (change to your path):
setwd("C:/Users/Brian/Documents/GitHub/Up-Stat2016_V2I_v1/")

#Options here are to load and estimate models for the training data or the testing data:
#---------------------------------------------------------------------------------------

data<- read.delim(file="finalOutputData_v1b_0i.txt", stringsAsFactors = FALSE)
solutionFileName="DataContestCombined_derived_Univariate_v2a.csv" #DataContestCombined_combinedMultivariate_v2a.csv

#---------------------------------------------------------------------------------------

#> names(data)
# [1] "numID"            "TimeSecFromBegin" "xLongFromBegin"   "yLatFromBegin"    "zElevFromBegin"  
# [6] "smoothLatitude"   "smoothLongitude"  "smoothElevation"  "smoothHeading"    "smoothYawrate"   
# [11] "smoothGentimeSec" "ID"               "latitude"         "longitude"        "elevation"       
# [16] "heading"          "YawRate"          "GentimeSec"       "VxTheory"         "VyTheory"        
# [21] "VzTheory"         "AxTheory"         "AyTheory"         "AzTheory"         "SpeedxyTheory"   
# [26] "SpeedTotTheory"   "YawrateTheory"  

#names(data)
attach(data)

#initialize an output dataframe:
outputDF <- data.frame()
originalDF<-data.frame()

#the sampling rate is fixed at 10Hz
srate <- 10

tIDs<- 1:75

#need the time series package:
library(astsa)

#initialize some summary statistics for a table, such as:
#1. counts of EM convergence
#2. number of CCA rejected components
#u<-1
converged <- matrix(0, nrow=length(tIDs),ncol=8)

#summary matricies:
sumQ = matrix(0,8,8)
sumPhi=sumQ
sumR = sumQ
nP = sumQ

for (u in 1:length(tIDs)){

#This is for plotting (comment out in solution file):
#png(filename = paste(tIDs[u], "_KalmanCov1.png",sep=""),  width = 1280, height = 800)
#par(mfrow=c(3,3))


#there are no missing data, simplifying this portion
#relative to original competition script:
sVx<-scale(as.numeric(VxTheory[numID==tIDs[u]]))

sVy<-scale(as.numeric(VyTheory[numID==tIDs[u]]))

sVz<-scale(as.numeric(VzTheory[numID==tIDs[u]]))

sAx<-scale(as.numeric(AxTheory[numID==tIDs[u]]))

sAy<-scale(as.numeric(AyTheory[numID==tIDs[u]]))

sAz<-scale(as.numeric(AzTheory[numID==tIDs[u]]))

sSpd<-scale(as.numeric(SpeedxyTheory[numID==tIDs[u]]))

sYaw<-scale(YawrateTheory[numID==tIDs[u]])
#Note: values were z-scored up there...

#use Shumway Example 6.9 code from http://www.stat.pitt.edu/stoffer/tsa3/Rexamples.htm
#...modified for our 10 variable cases:
y = cbind(sVx,sVy,sVz,sAx,sAy,sAz,sSpd,sYaw)
#y = cbind(ulat,ulon,uElv,uSpd,ucos,usin,uAx,uAy,uAz,uYaw)
#exclude 0 variance (constant) variables:
#emInc<-which(diag(cov(origY))>0)
emInc<-which(diag(cov(y))>0)
y<-y[,emInc]

num = nrow(y)       
ncol=dim(y)[2]
smoothData<- matrix(0,ncol=num, nrow=ncol)
A = array(0, dim=c(ncol,ncol,num))  # creates nxn zero matrices
#for(k in 1:num) if (abs(y[k,1]) > 0) A[,,k]= diag(1,ncol) 
for(k in 1:num) A[,,k]= diag(1,ncol) 

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
emA = EM0(num=num,y=ts(y[,tp]),1,mu0=0,Sigma0=1,Phi=Phi[tp,tp],cQ=1,cR=1,max.iter=25,tol=.01)

##2nd pass - if it doesn't converge, at least we have initial 25 iteration solution
emt = try(EM0(num=num,y=ts(y[,tp]),1,mu0=emA$mu0,Sigma0=emA$Sigma0,Phi=emA$Phi,cQ=chol(emA$Q),cR=chol(emA$R),max.iter=100,tol=.01))


if (class(emt)!="try-error"){
  #update MLEs:
  emA <- emt
  converged[u,tpi] = 1
} else {
  converged[u,tpi] = 0
}

ksA <- Ksmooth0(num,ts(y[,tp]),1,emA$mu0, emA$Sigma0, emA$Phi, emA$Q, emA$R)

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

#sVx
#1
if(any(emInc==1)){
	#Transform Latitude from z-scores to degree units:
	smoothVxTheory = (smoothData[which(emInc==1),]*attributes(sVx)[[3]])+attributes(sVx)[[2]]
} else {
	#This was constant, so make no assumptions and replace entire ts with mean:
  smoothVxTheory = attributes(sVx)[[2]]
}

#2 sVy
if(any(emInc==2)){
  #Transform Latitude from z-scores to degree units:
  smoothVyTheory = (smoothData[which(emInc==2),]*attributes(sVy)[[3]])+attributes(sVy)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothVyTheory = attributes(sVy)[[2]]
}

#3 sVz
if(any(emInc==3)){
  #Transform Latitude from z-scores to degree units:
  smoothVzTheory = (smoothData[which(emInc==3),]*attributes(sVz)[[3]])+attributes(sVz)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothVzTheory = attributes(sVz)[[2]]
}

#4 sAx
if(any(emInc==4)){
  #Transform Latitude from z-scores to degree units:
  smoothAxTheory = (smoothData[which(emInc==4),]*attributes(sAx)[[3]])+attributes(sAx)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothAxTheory = attributes(sAx)[[2]]
}

#5 sAy
if(any(emInc==5)){
  #Transform Latitude from z-scores to degree units:
  smoothAyTheory = (smoothData[which(emInc==5),]*attributes(sAy)[[3]])+attributes(sAy)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothAyTheory = attributes(sAy)[[2]]
}

#6 sAz
if(any(emInc==6)){
  #Transform Latitude from z-scores to degree units:
  smoothAzTheory = (smoothData[which(emInc==6),]*attributes(sAz)[[3]])+attributes(sAz)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothAzTheory = attributes(sAz)[[2]]
}


#7 sSpd
if(any(emInc==7)){
  #Transform Latitude from z-scores to degree units:
  smoothSpeedTheory = (smoothData[which(emInc==7),]*attributes(sSpd)[[3]])+attributes(sSpd)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothSpdTheory = attributes(sSpd)[[2]]
}

#8 sYaw
if(any(emInc==8)){
  #Transform Latitude from z-scores to degree units:
  smoothYawrateTheory = (smoothData[which(emInc==8),]*attributes(sYaw)[[3]])+attributes(sYaw)[[2]]
} else {
  #This was constant, so make no assumptions and replace entire ts with mean:
  smoothYawrateTheory = attributes(sYaw)[[2]]
}

#stitch them all together in a data frame for this ts
#(could be used for saving/checking single case solutions)
uDF <- data.frame(cbind(numID=u,smoothVxTheory, smoothVyTheory,smoothVzTheory,
                        smoothAxTheory, smoothAyTheory,smoothAzTheory,
                        smoothSpeedTheory, smoothYawrateTheory))


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
#write.table(cbind(outputDF,data), file="DataContestCombined_combinedUnivariate_v2a.csv", sep=",", row.names = FALSE)


detach(data)