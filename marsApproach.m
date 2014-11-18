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
	sunFactory = OrbitFactory(1.98855e30,'Sun');
	marsFactory = OrbitFactory(639e21,'Mars');


	%args(factory, semiMajorAxis, Eccentricity, angleToReference)
	%generate a circularized orbit
	cirOrbit = fromAE(marsFactory,3575000, 0, toRadians(336.05637041))
	marsSurface = fromAE(marsFactory,3390000,0,toRadians(0))

	%args(factory,vinf,rmin,angleOffset)
	%generate a hyperbolic orbit
%	hypOrbit = fromHYP(marsFactory,24138.9,cirOrbit.rmin,0)
%	hypOrbit = fromHYP(marsFactory,[241,241],cirOrbit.rmin,0)

	%generate mars orbit
	marsOrbit = fromAE(sunFactory,227.92e6,0.0935,toRadians(336.05637041));

	%generate landing pattern
	landingOrbit = hohmannTransfer(cirOrbit,marsSurface,pi/2)

	%periapsis of ship
	printf('Vernal Equinox: %d/%d/%d\n',2013,7,13);
	vernalEquinox = datenum(2013,7,13);
	vernalAngle = angSolve(marsOrbit,0,vernalEquinox);
	marsAnomalyInit = angSolve(cirOrbit, 0, 0);

%	pointGraph(earthOrbit,.23*pi);
%	pointGraph(cirOrbit,.5*pi);


	%plot vernal equinox
%	pointGraph(cirOrbit,vernalAngle,40);
%	graph(hypOrbit);
	graph(marsSurface)
	graph(cirOrbit);
	print('marsApproach.pdf')

	graph(landingOrbit)

%	deltaV = hypOrbit.vmin-cirOrbit.vmin
%	hypVelocity = velocity(hypOrbit,0)
%	cirVelocity = velocity(cirOrbit,0)
%	deltaV = velocity(hypOrbit,0) - velocity(cirOrbit,0)



