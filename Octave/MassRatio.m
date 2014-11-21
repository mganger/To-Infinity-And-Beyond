clear all; close all;

mfinal=10112+(1.9824*300);
mJ2X=5000;
monmars=0
mRS25=12708;
mSRB=173000;
dv8=
dv7=
dv6=
dv5=
dv4=
dv3=
dv2=
dv1=0
J2X=448;
RS25=452;
SRB=269;
g=9.81;


minitial=(mfinal+mJ2X+monmars+mRS25+mSRB)*exp((dv8/(J2X*g))+(dv7/(J2X*g))+(dv6/(J2X*g))...
+(dv5/(J2X*g))+(dv4/(J2X*g))+(dv3/(J2X*g))+(dv2/(RS25*g))+(dv1/(SRB*g)))
