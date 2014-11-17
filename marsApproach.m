clear all;close all;
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
addpath('helper_functions');

%step 2:
	%Earth Transfer Orbit to Low Mars Orbit. (ETO to LMO)
	sunFactory = OrbitFactory(1.98855e30,'Sun')
	marsFactory = OrbitFactory(639e21,'Mars')

	%args(factory, semiMajorAxis, Eccentricity, angleToReference)
	earthOrbit = fromAE(sunFactory, 149.60e6, 0.01671022, toRadians(102.93768193));
	marsOrbit  = fromAE(sunFactory, 227.92e6, 0.0935, toRadians(336.05637041));

	%periapsis of ship
	printf('Vernal Equinox: %d/%d/%d\n',2013,7,13)
	vernalEquinox = datenum(2013,7,13);
	angSolve(marsOrbit,0,vernalEquinox)
	marsAnomalyInit = angSolve(shipOrbit, 0, 0)

	graph(earthOrbit,0,2*pi,1);
	graph(marsOrbit,0,2*pi,1);
