%This is a lengthy function that finds the transfer orbit between two different
%points. The basic process is as such:
%	1 - find the amount of time for the second body to reach the position of the
%	    first body
%	2 - start constructing an orbit out of the two polar coordinates
%	3 - start optimizing the reference angle (omegaT) so that the amount of
%	    to complete the transfer orbit is the same as the amount of time for
%	    the second planet to reach the given angle of arrival (thetaA)
function transOrb, map, reqTime, transTime = transferArc(factory, orbit1, perTime1, orbit2, perTime2,  thetaD, thetaA, filename, quiet, plot)
	try quiet == 1; catch quiet = 0; end;
	try plot == 1; catch plot = 0; end;
	%create a struct to pass around different conditions at given points in
	%the orbit time. Essentially, this acts as a way to keep all of the
	%information relevant to the transfer orbit in one location.
	map = struct;

	%Periapsis of second minus periapsis of first, in seconds. This is used
	%to align the position of the orbits at a given date
	periTimeDiff = (perTime1 - perTime2)*24*3600;
	%Angle of second in its orbit at t = 0
	map.init.time =  0;
	map.init.first = 0;
	map.init.second = angSolve(orbit2, 0, periTimeDiff);


	%Adjust the arrival and departure so that we always leave in the past
	%and arrive in the future. Then, set the reference angles of both
	%positons in the struct
	while(thetaD < orbit1.refAngle) thetaD += 2*pi; end;
	while(thetaA < thetaD)          thetaA += 2*pi; end;
	map.depart.ref  = thetaD;
	map.arrival.ref = thetaA;
	printf('thetaD: %f\n',  thetaD);
	printf('thetaA: %f\n', thetaA);


	%Find the eqivalent first and second angles for above reference angles
	map.depart.first =   relAngle(thetaD, orbit1);
	map.arrival.second = relAngle(thetaA, orbit2);

	%Find the time that the first is at the desired depart angle
	map.depart.time = timeDiff(orbit1, 0, map.depart.first);

	%find second's location at the departure angle (for the first)
	%make sure that the arrival angle is greater than the departure angle
	map.depart.second = angSolve(orbit2, map.init.second, map.depart.time);
	while(map.arrival.second < map.depart.second) map.arrival.second += 2*pi; end;
	while((map.arrival.second - map.depart.second) > 2*pi) map.depart.second += 2*pi; end;

	%find the amount of time for.second to orbit between the two points
	map.arrival.time = map.depart.time + timeDiff(orbit2, map.depart.second, map.arrival.second);

	printf('depart: %f\n',  map.depart.second);
	printf('arrival: %f\n', map.arrival.second);
	printf('Angle Difference: %f\n', map.arrival.second - map.depart.second);

	%find first's location at the when the ship arrives at second
	map.arrival.first = angSolve(orbit1, 0, map.arrival.time);


	%construct a transfer orbit from the two known coordinates (r,theta) for the intial.first and the final.second
	%just a system of equations from the first function
	reqTime = tDiff = map.arrival.time - map.depart.time;
	printf('Time Difference: %f\n', tDiff/3600/24);
	ci = [radiusAbs(orbit1, map.depart.ref),  map.depart.ref];
	cf = [radiusAbs(orbit2,  map.arrival.ref), map.arrival.ref];
	[transOrb, transTime] = fromPolarRef(factory, tDiff, ci, cf);
	map.depart.transfer  = relAngle(map.depart.ref, transOrb);
	map.arrival.transfer = relAngle(map.arrival.ref, transOrb);

	%If the plot variable is set, print out the graph to the filename
	if(plot > 0)
		figure(plot, 'visible', 'off')
			%second and first location at departure
			pointGraphRel(orbit1, map.depart.first, 10);
			pointGraphRel(orbit2,  map.depart.second, 10);

			%second and first location at arrival
			pointGraphRel(orbit1, map.arrival.first);
			pointGraphRel(orbit2,  map.arrival.second);

			graphRel(orbit1,  map.depart.first, map.arrival.first, 1);
			graphRel(orbit2, map.depart.second, map.arrival.second, 1);
			graph(transOrb, map.depart.ref, map.arrival.ref, 1);
			print(filename);
	end

	%print information about the orbit (for deugging purposes)
	if(quiet == 0)
		printf('Departure Time:  %.0f days from.first equinox\n', map.depart.time/3600/24);
		printf('Departure Angle: %.2f revolutions from ref\n', map.depart.ref/(2*pi)  );
		printf('Arrival Angle:   %.2f revolutions from ref\n', map.arrival.ref/(2*pi) );
		printf('Arrival Time:    %0.f days from departure\n', (map.arrival.time - map.depart.time)/3600/24);
		printf('The trip will take %.1f days\n', tDiff/3600/24);
		printf('The transfer is calculated to be %.1f days\n', timeDiff(transOrb, map.depart.transfer, map.arrival.transfer)/24/3600);
	end
end
