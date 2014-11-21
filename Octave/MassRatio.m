%This is a linear script to calculate the amount of initial mass needed to
%reach mars. Values must be explicitly specified inline.

%The reason that the initial mass is so ridiculous is directly related to the
%first and second change in velocity. If we change dv2 by an order of
%magnitude, we can reduce the initial mass by multiple orders of magnitude.
%This means that, by choosing a more efficient path, we can reduce the number
%of rockets we need to get to low earth orbit.
clear all; close all;

function m0 = mass(m1, dv, isp)
	m0 = m1 * exp(dv / (isp * 9.81));
end

mfinal=10112+60+209+34.02 + 686
mJ2X=5000;
monmars=0
mRS25=12708;
mSRB=173000;

%	Beginning of Mission ------------------------------------------------------------------- End of Mission
%     0.0000e+00    24.8603e+03    12.8515e+03   104.0969e+00     3.2621e+03     3.2621e+03   104.0969e+00    15.1976e+03

dv8=15.1976e03
dv7=104.0969
dv6=3.2621e+03     
dv5=3.2621e+03     
dv4=104.0969
dv3=12.8515e03
dv2=24.8603e03
dv1=0

J2X=448;
RS25=452;
SRB=269;
g=9.81;

minitial=(mfinal+mJ2X+monmars+mRS25)*exp((dv8/(J2X*g))+(dv7/(J2X*g))+(dv6/(J2X*g))...
+(dv5/(J2X*g))+(dv4/(J2X*g))+(dv3/(J2X*g))+(dv2/(RS25*g))+(dv1/(SRB*g)))

