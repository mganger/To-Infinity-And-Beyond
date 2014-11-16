%Steps to get to Mars and Back
%	Calculate transfer from Earth to Mars
%	Transfer from hyperbolic to LMO
%	Wait until we are at one of the two spots on the line of mars axis (projected onto the top view)
%		Separate and descend to mars
%		Stay on the surface for about 30 days
%		Get back into orbit, and possibly reconvene with some fuel in orbit
%	Transfer from LMO to hyperbolic
%	Calculate Mars to Earth

options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
addpath('Orbit/@Orbit');
addpath('Orbit/@OrbitFactory');

%step 1:
	%transfer from earth to mars
	sunFactory = OrbitFactory(1.98855e30, 'Sun');

	%args(factory, semiMajorAxis, Eccentricity, angleToReference)
	earthOrbit = fromAE(sunFactory, 149.60e6, 0.01671022, 102.93768193)
	marsOrbit  = fromAE(sunFactory, 227.92e6, 0.0935,     336.05637041)


	%periapsis of mars minus periapsis of earth, in seconds
	periTimeDiff = (datenum(2015,1,4) - datenum(2014,12,12))*24*3600
	marsAnomalyInit = angSolve(marsOrbit, 0, periTimeDiff)
