%Steps to get to Mars and Back
%	Calculate transfer from Earth to Mars
%	Transfer from hyperbolic to LMO
%	Wait until we are at one of the two spots on the line of mars axis (projected onto the top view)
%		Separate and descend to mars
%		Stay on the surface for about 30 days
%		Get back into orbit, and possibly reconvene with some fuel in orbit
%	Transfer from LMO to hyperbolic
%	Calculate Mars to Earth

format short eng;

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

	%map the earth angles to the mars angles
	earthMarsMap = struct;


	%periapsis of mars minus periapsis of earth, in seconds
	periTimeDiff = (datenum(2015,1,4) - datenum(2014,12,12))*24*3600;
	%angle of mars in its orbit at t = 0
	earthMarsMap.init.time = 0;
	earthMarsMap.init.earth = 0;
	earthMarsMap.init.mars = angSolve(marsOrbit, 0, periTimeDiff);


	%arrival and departure angles (user inputed)
	thetaD = 3;
	thetaA = 3*pi;
	earthMarsMap.depart.ref = thetaD;
	earthMarsMap.arrival.ref = thetaA;

	%find the eqivalent earth and mars angles for above reference angles
	earthMarsMap.depart.earth = relAngle(thetaD, earthOrbit);
	earthMarsMap.arrival.mars = relAngle(thetaA, marsOrbit);



	%find the time that the earth is at the desired depart angle
	earthMarsMap.depart.time = timeDiff(earthOrbit, 0, earthMarsMap.depart.earth);
	printf('Departure Time: %.0f days from earth equinox\n', earthMarsMap.depart.time/3600/24);

	%find mars's location at the departure angle (for the earth)
	earthMarsMap.depart.mars = angSolve(marsOrbit, earthMarsMap.init.mars, earthMarsMap.depart.time);
	printf('Departure Angle: %.2f revolutions from mars equinox\n', earthMarsMap.depart.mars/(2*pi));

	%find the amount of time for mars to orbit between the two points
	earthMarsMap.arrival.time = earthMarsMap.depart.time + timeDiff(marsOrbit, earthMarsMap.depart.mars, earthMarsMap.arrival.mars);
	printf('Arrival Time:    %f days from earth equinox\n', earthMarsMap.arrival.time/3600/24);
	


	%construct a transfer orbit from the two known coordinates (r,theta) for the intial earth and the final mars
	%just a system of equations from the first function
	timeDiff = earthMarsMap.arrival.time - earthMarsMap.depart.time;
	ci = [radiusAbs(earthOrbit, earthMarsMap.depart.ref),  earthMarsMap.depart.ref];
	cf = [radiusAbs(marsOrbit,  earthMarsMap.arrival.ref), earthMarsMap.arrival.ref];
	eToMorb= fromPolarRef(sunFactory,timeDiff, ci, cf);
	printf('The trip will take %.0f days', timeDiff/3600/24);


	%create an orbit around the earth
	earthFactory = OrbitFactory(5.97219e24, 'Earth');
	%args(factory, semiMajorAxis, Eccentrcity, angleToReference)
	lowEarthOrbit = fromAE(earthFactory, 185e3 + 6371, 0, 0);
	
