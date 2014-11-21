clear all; close all;

mfinal=10112+(1.9824*346);
mJ2X=5000;
monmars=0
mRS25=12708;
mSRB=173000;

%	Beginning of Mission ------------------------------------------------------------------- End of Mission
%     0.0000e+00    24.8603e+03    12.8515e+03   104.0969e+00   103.8207e+00   103.8207e+00   104.0969e+00    15.1976e+03
%	1		2		3		4		5		6		7		8
dv8=15.1976e03
dv7=104.0969
dv6=103.8207
dv5=103.8207
dv4=104.0969
dv3=12.8515e03
dv2=24.8603e03
dv1=0

J2X=448;
RS25=452;
SRB=269;
g=9.81;

%minitial=(mfinal+mJ2X+monmars+mRS25+mSRB)*exp((dv8/(J2X*g))+(dv7/(J2X*g))+(dv6/(J2X*g))...
minitial=(mfinal+mJ2X+monmars+mRS25)*exp((dv8/(J2X*g))+(dv7/(J2X*g))+(dv6/(J2X*g))...
+(dv5/(J2X*g))+(dv4/(J2X*g))+(dv3/(J2X*g))+(dv2/(RS25*g))+(dv1/(SRB*g)))
