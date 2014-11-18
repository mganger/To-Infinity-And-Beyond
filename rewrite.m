%Steps to get to Mars and Back
%	Calculate transfer from Earth to Mars
%	Transfer from hyperbolic to LMO
%	Wait until we are at one of the two spots on the line of mars axis (projected onto the top view)
%		Separate and descend to mars
%		Stay on the surface for about 30 days
%		Get back into orbit, and possibly reconvene with some fuel in orbit
%	Transfer from LMO to hyperbolic
%	Calculate Mars to Earth

format short eng; clear all; close all;

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
	map = struct;



	%periapsis of mars minus periapsis of earth, in seconds
	periTimeDiff = (datenum(2015,1,4) - datenum(2014,12,12))*24*3600;
	%angle of mars in its orbit at t = 0
	map.init.time = 0;
	map.init.earth = 0;
	map.init.mars = angSolve(marsOrbit, 0, periTimeDiff);





	%arrival and departure angles (user inputed)
	thetaD = 4*pi;
	thetaA = 4.7*pi;
	while(thetaD < earthOrbit.refAngle) thetaD += 2*pi; end;
	while(thetaA < thetaD) thetaA += 2*pi; end;
	map.depart.ref = thetaD;
	map.arrival.ref = thetaA;





	%find the eqivalent earth and mars angles for above reference angles
	map.depart.earth = relAngle(thetaD, earthOrbit);
	map.arrival.mars = relAngle(thetaA, marsOrbit);






	%find the time that the earth is at the desired depart angle
	map.depart.time = timeDiff(earthOrbit, 0, map.depart.earth);
	printf('Departure Time:  %.0f days from earth equinox\n', map.depart.time/3600/24);




	%find mars's location at the departure angle (for the earth); make sure that the arrival angle is greater than the departure angle
	map.depart.mars = angSolve(marsOrbit, map.init.mars, map.depart.time);
	while(map.arrival.mars < map.depart.mars) map.arrival.mars += 2*pi; end;
	printf('Departure Angle: %.2f revolutions from ref\n', map.depart.ref/(2*pi)  );
	printf('Arrival Angle:   %.2f revolutions from ref\n', map.arrival.ref/(2*pi) );




	%find the amount of time for mars to orbit between the two points
	map.arrival.time = map.depart.time + timeDiff(marsOrbit, map.depart.mars, map.arrival.mars);
	printf('Arrival Time:    %0.f days from departure\n', (map.arrival.time - map.depart.time)/3600/24);




	%find earth's location at the when the ship arrives at mars
	map.arrival.earth = angSolve(earthOrbit, 0, map.arrival.time);

	




	%graph mars and earth's orbits (to see if the orbit is actually possible)
	figure(1, 'visible', 'off')
	graphRel(earthOrbit,  map.depart.earth, map.arrival.earth, 1);
	%graph(marsOrbit,   absAngle(map.depart.mars, marsOrbit), map.arrival.ref, 1);





	%construct a transfer orbit from the two known coordinates (r,theta) for the intial earth and the final mars
	%just a system of equations from the first function
	tDiff = map.arrival.time - map.depart.time;
	ci = [radiusAbs(earthOrbit, map.depart.ref),  map.depart.ref];
	cf = [radiusAbs(marsOrbit,  map.arrival.ref), map.arrival.ref];
	eToMorb = fromPolarRef(sunFactory, tDiff, ci, cf);
	map.depart.transfer  = relAngle(map.depart.ref, eToMorb);
	map.arrival.transfer = relAngle(map.arrival.ref, eToMorb);
	printf('The trip will take %.1f days\n', tDiff/3600/24);
	printf('The transfer is calculated to be %.1f days\n', timeDiff(eToMorb, map.depart.transfer, map.arrival.transfer)/24/3600);




	%graph the transfer orbit on
	map
	eToMorb

	%graph(earthOrbit, absAngle(map.init.earth, earthOrbit), absAngle(map.arrival.earth, earthOrbit), 1);
	graphRel(marsOrbit, map.depart.mars, map.arrival.mars, 1);

	%mars and earth location at departure
	pointGraphRel(earthOrbit, map.depart.earth, 10);
	pointGraphRel(marsOrbit,  map.depart.mars, 10);

	%mars and earth location at arrival
	pointGraphRel(earthOrbit, map.arrival.earth);
	pointGraphRel(marsOrbit,  map.arrival.mars);
	graph(eToMorb, map.depart.ref, map.arrival.ref, 1);


	%create an orbit around the earth
	earthFactory = OrbitFactory(5.97219e24, 'Earth');
	%args(factory, semiMajorAxis, Eccentrcity, angleToReference)
	lowEarthOrbit = fromAE(earthFactory, 185e3 + 6371, 0, 0);
	

	print('graph.pdf');
