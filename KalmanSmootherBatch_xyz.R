#(1) Created by Brian Roach
#(2) Creation date: [1] "Tue Mar 22 20:45:56 2016" (adapted from competition script)
#(3) Purpose:
#	This script was created to try the Shumway-Stoffer Kalman
#	smoother for missing data problems (1982) using the data
#	from the up-stat data competition
#
#	A few variables are edited at the top to either load
#	training data or testing data, then the script runs
#	and generates a data.frame called "outputDF".  This
#	dataframe contains all the solutions, stacked, in the
#	same order with the same formatting as the input data
#	sets.
#
#(4)Last executed: "Tue May 10 20:08:58 2016"

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
solutionFileName="DataContestCombined_solution.csv"

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

tIDs<- unique(ID)

#need the time series package:
library(astsa)

#initialize some summary statistics for a table, such as:
#1. counts of EM convergence
#2. number of CCA rejected components
#u<-1
converged <- rep(0, length(tIDs))

#summary matricies:
sumQ = matrix(0,3,3)
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

#insert the observed values in the appropriate locations:
#ulat[utime+1]<-(Latitude[ID==tIDs[u]] - mean(Latitude[ID==tIDs[u]]))/sd(Latitude[ID==tIDs[u]])
slat<-scale(Latitude[ID==tIDs[u]])
ulat[utime+1]<-slat

slon<-scale(Longitude[ID==tIDs[u]])
ulon[utime+1]<-slon

sElv<-scale(Elevation[ID==tIDs[u]])
uElv[utime+1]<-sElv

#Note: values were z-scored up there...

#I need the original data to estimate 
#the covariance matrix and check for
#time series variables that are constant
origY<-cbind(Latitude[ID==tIDs[u]],
		 Longitude[ID==tIDs[u]],
		 Elevation[ID==tIDs[u]])

#use Shumway Example 6.9 code from http://www.stat.pitt.edu/stoffer/tsa3/Rexamples.htm
#...modified for our 10 variable cases:
y = cbind(ulat,ulon,uElv)
#y = cbind(ulat,ulon,uElv,uSpd,ucos,usin,uAx,uAy,uAz,uYaw)
#exclude 0 variance (constant) variables:
#emInc<-which(diag(cov(origY))>0)
emInc<-which(diag(cov(y[utime+1,]))>0)
y<-y[,emInc]

num = nrow(y)       
ncol=dim(y)[2]
A = array(0, dim=c(ncol,ncol,num))  # creates nxn zero matrices
for(k in 1:num) if (abs(y[k,1]) > 0) A[,,k]= diag(1,ncol) 

# Initial values 

#mu0 = matrix(0,ncol,1) #thought 0 made some sense for z-scored values
mu0 = matrix(y[1,], ncol, 1)
#Sigma0 = diag(diag(cov(y[utime+1,])),ncol) 
Sigma0 = cov(y[utime+1,])
#Sigma0= diag(1,ncol) 
#cov(origY[,emInc]) 
#diag(c(.1,.1,1),3)

#use the real single sample (100ms) transitions to estimate
#the transition matrix, Phi:
Phi = diag(colMeans(y[(utime+1)[c(0,diff(utime))==1],]),ncol)

cQ = diag(1,ncol)
#diag(1,ncol)/2 
#diag(c(.1,.1,1),3)

cR = diag(1,ncol) #diag(c(.1,.1,1),3)  

#obtain maximum liklihood estimators:
em = EM1(num=num,y=y,A=A,mu0=mu0,Sigma0=Sigma0,Phi=Phi,cQ=cQ,cR=cR,max.iter=25,tol=.01)
#note, initially used an older version of astsa that needed this syntax to run:
#em = EM1(num=num,y=y,A=A,mu0=mu0,Sigma0=Sigma0,Phi=Phi,Ups=0,Gam=0,cQ=cQ,cR=cR,0,25,.01)

##2nd pass - if it doesn't converge, at least we have initial 25 iteration solution
emt = try(EM1(num=num,y=y,A=A,mu0=em$mu0,Sigma0=em$Sigma0,Phi=em$Phi,cQ=chol(em$Q),cR=chol(em$R),max.iter=100,tol=.01))

#again, older version may need this syntax to run:
#emt = try(EM1(num=num,y=y,A=A,mu0=em$mu0,Sigma0=em$Sigma0,Phi=em$Phi,Ups=0,Gam=0,cQ=chol(em$Q),cR=chol(em$R),0,100,.01))

if (class(emt)!="try-error"){
#update MLEs:
em <- emt
converged[u] = 1
} else {
converged[u] = 0
}

#store estimated values:
sumQ[emInc,emInc] <- sumQ[emInc,emInc] + em$Q
sumR[emInc,emInc] <- sumR[emInc,emInc] + em$R
sumPhi[emInc,emInc] <- sumPhi[emInc,emInc] + em$Phi
nP[emInc,emInc] <- nP[emInc,emInc] + 1

#graph the Kalman smoother:
# Graph smoother
ks = Ksmooth1(num, y, A, em$mu0, em$Sigma0, em$Phi, 0, 0, chol(em$Q), chol(em$R), 0) 

#for (tp in 1:length(emInc)){
#	#tp=6
#
#	y1s = ks$xs[tp,,]
#	p1 = 2*sqrt(ks$Ps[tp,tp,])
#
#	plot(utime,y[utime+1,tp], type="p", pch=19, xlab="sample", ylab=names(data)[emInc[tp]])
#	#plot(utime,(origY[,tp]-mean(origY[,tp]))/sd(origY[,tp]), type="p", pch=1, xlab="sample", ylab=names(data)[tp])
#	lines(min(utime):max(utime),y1s, col=4, lwd=2); 
#	lines(min(utime):max(utime),y1s+p1, lty=2); 
#	lines(min(utime):max(utime),y1s-p1, lty=2)
#	}
#
#dev.off()

#library(CCA)

#get smoothed data:
X <- ks$xs[,1,]

#initialize lag-1 matrix for smoothed data:
Y<- matrix(0, nrow=dim(X)[1], ncol=dim(X)[2])

#and fill it with lag-1 data:
Y[,2:dim(Y)[2]] <- X[,1:(dim(Y)[2]-1)]

cca<-cancor(t(X),t(Y))

#save the canonical variates:
U<-t(X)%*%cca$xcoef 

#...and coefficients:
A<-cca$xcoef

#note: steps above are based on matlab implementation
#and its documentation found here:
#http://www.mathworks.com/help/stats/canoncorr.html?s_tid=gn_loc_drop

#do an FFT of each of the variate time series:
tLength <- dim(U)[1]

#an attempt was made to do BSS-CCA de-noising, removing
#white noise canonical variates.  Interestingly, the method
#failed to identify any components to reject in these data,
#which indicates non-zero AR-1 correlations and the absence
#of obvious white noise components in the Kalman smoother estimates

#just save kalman output
smoothData<-X


#plot data after all this:
#png(filename = paste(tIDs[u], "_KalmanSmooth1.png",sep=""),  width = 1280, height = 800)

#par(mfrow=c(3,3))
#for (tp in 1:length(emInc)){
#	#tp=6
#
#	y1s = smoothData[tp,]
#
#	plot(utime,y[utime+1,tp], type="p", pch=19, xlab="sample", ylab=names(data)[emInc[tp]], col="red")
#	#plot(utime,(origY[,tp]-mean(origY[,tp]))/sd(origY[,tp]), type="p", pch=19, xlab="sample", ylab=names(data)[tp])
#	points(min(utime):max(utime),y1s, col=4, pch=21); 
#	lines(min(utime):max(utime),y1s, col=4);
#	lines(min(utime):max(utime),lowess(y1s,f=10/tLength)$y,col="green", lwd=2)
#	}
#dev.off()

#Transform utime values back to GentimeSec values:
smoothGentimeSec = (0:max(utime) * 0.1) + GentimeSec[ID==tIDs[u]][1]

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

#and don't forget the ID:
smoothID <- rep(tIDs[u], length(smoothLongitude))

#stitch them all together in a data frame for this ts
#(could be used for saving/checking single case solutions)
uDF <- data.frame(cbind(smoothLatitude, smoothLongitude, smoothElevation,
                        smoothGentimeSec), ID=as.character(smoothID))

#Finally, stack solutions:
#e.g. rbind(data.frame(matrix(0,6,6)),data.frame(matrix(0,6,6)))
outputDF<- rbind(outputDF, uDF)
}
nP
nP/length(tIDs)
sumPhi/nP
sumQ/nP
sumR/nP

#write out the solution, if you'd like to:
#write.table(outputDF, file=solutionFileName, sep=",", row.names = FALSE)

detach(data)