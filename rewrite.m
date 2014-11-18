%Steps to get to Mars and Back
%	Calculate transfer from Earth to Mars
%	Transfer from hyperbolic to LMO
%	Wait until we are at one of the two spots on the line of mars axis (projected onto the top view)
%		Separate and descend to mars
%		Stay on the surface for about 30 days
%		Get back into orbit, and possibly reconvene with some fuel in orbit
%	Transfer from LMO to hyperbolic
%	Calculate Mars to Earth

format short eng; close all;

options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
addpath('Orbit/@Orbit');
addpath('Orbit/@OrbitFactory');
addpath('helper_functions');

try timeInt(); catch end
printf('\n\n');

%step 1:
	%transfer from earth to mars
	sunFactory = OrbitFactory(1.98855e30, 'Sun');

	%args(factory, semiMajorAxis, Eccentricity, angleToReference)
	earthOrbit = fromAE(sunFactory, 149.60e9, 0.01671022, toRadians(102.93768193));
	marsOrbit  = fromAE(sunFactory, 227.92e9, 0.0935,     toRadians(336.05637041));
	earthPeri = datenum(2014,12,12);
	marsPeri  = datenum(2015,01,04);

	thetaD = 4.1*pi;
	thetaA = 4.8*pi;
	[EMorb, EMmap, EMreqTime, EMestTime] = transferArc(sunFactory, earthOrbit, earthPeri, marsOrbit, marsPeri, 4.1*pi, 4.8*pi, 'graph.pdf', quiet=1, plot=0);

	%spin mars 30 days into the future
	marsDepart = angSolve(marsOrbit, EMmap.arrival.second, 30*3600*24);
	thetaD1 = marsDepart;
	thetaA1 = marsDepart + 0.7*pi;
	[MEorb, MEmap, MEreqTime, MEestTime] = transferArc(sunFactory, marsOrbit, marsPeri, earthOrbit, earthPeri, marsDepart, marsDepart + .7*pi, 'graph2.pdf', quiet=1, plot=0);


	printf('t1=%f,t2=%f,thetaD=%f,thetaA=%f,thetaD2=%f,thetaA2=%f\n', EMreqTime, MEreqTime, thetaD, thetaA, thetaD1, thetaA1);
