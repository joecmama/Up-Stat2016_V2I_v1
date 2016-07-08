function dist = LatLon2Dist(Lon1, Lat1, Lon2, Lat2)
% Given from Up-Stat 2016 Data Science Competition:
%This implements a distance calculation for two points on a great circle, returned in meters using the Spherical Law of Cosines.
%It allows you to calculate the distance in meters between two points expressed in degrees of longitude and latitude. You might find it useful to measure the distance between your estimates and the data in units that are compatible with the other fields.

  Lat1rad = Lat1*pi/180;
  Lon1rad = Lon1*pi/180;
  Lat2rad = Lat2*pi/180;
  Lon2rad = Lon2*pi/180;
  dist = acos(sin(Lat1rad)*sin(Lat2rad)+cos(Lat1rad)*cos(Lat2rad)*cos(Lon2rad-Lon1rad))*6371000;

end   % end function
