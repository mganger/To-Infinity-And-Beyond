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

	%Use the factory pattern to generate orbits around different bodies;
	%a factory is a body that is orbited around
	sunFactory = OrbitFactory(1.98855e30, 'Sun');
	marsFactory = OrbitFactory(639e21,'Mars');
	earthFactory = OrbitFactory(5.97219e24,'Earth');

	%set up the orbits around the sun (using the factory pattern)
	earthOrbit = fromAE(sunFactory, 149.60e9, 0.01671022, toRadians(102.93768193));
	marsOrbit  = fromAE(sunFactory, 227.92e9, 0.0935,     toRadians(336.05637041));

	%set periapsis time for both 
	earthPeri = datenum(2014,12,12);
	marsPeri  = datenum(2015,01,04);


	%Set the departure and arrival angles for the transfer orbit from earth
	%to mars (in radians). If the angles are greater than 2pi, it means
	%that we are leaving in the future
	thetaD = 78.023397;
	thetaA = 78.910909;

	%get the transfer orbit from earth to mars, the amount of time that it
	%will take, and a map of the different positions at different times in
	%the orbit. These are used to determine the velocity changes that our
	%spacecraft must undergo.
	[EMorb, EMmap, EMreqTime, EMestTime] = transferArc(sunFactory, earthOrbit, earthPeri, marsOrbit, marsPeri, thetaD, thetaA, 'graph.pdf', quiet=1, plot=1);

	%Spin mars 30 days into the future.  This is to account for the length
	%of time that we intend to stay on mars. In seconds.
	marsDepart = angSolve(marsOrbit, EMmap.arrival.second, 30*3600*24);
	while(marsDepart <= thetaA) marsDepart += 2*pi; end;
	thetaD1 = marsDepart;
	thetaA1 = 80.992893;
	[MEorb, MEmap, MEreqTime, MEestTime] = transferArc(sunFactory, marsOrbit, marsPeri, earthOrbit, earthPeri, marsDepart, thetaA1, 'graph2.pdf', quiet=1, plot=1);

	%Find velocities at different points in the trip, and put them in a
	%struct to keep track of them
	vels = struct;
	vels.toMarsArrival.vinf = velocity(EMorb, relAngle(EMmap.arrival.ref, EMorb));
	vels.toMarsDepart.vinf  = velocity(EMorb, relAngle(EMmap.depart.ref, EMorb));

	vels.toEarthDepart.vinf  = velocity(MEorb, relAngle(MEmap.depart.ref, MEorb));



	%Now that we have the transfer orbits to and from mars, we can determine
	%the differenct velocity changes that we need to undergo through the
	%entire trip.  These will tell us the amount of initial mass that we
	%need


	%Getting out of LEO to get to Mars
	% orbit = fromAE(rad from center of mass, eccentricty, omega)
	LEO = fromAE(earthFactory, 6563e3, 0, 0);
	hypOrbFromEarth = fromHYP(earthFactory, vels.toMarsDepart.vinf, LEO.rmin);
	leoVelocity = velocity(LEO, 0);

	%Start constructing an array to hold the velocty changes. This is used
	%to determine the reequired initial mass of the spacecraft.
	deltaV(2) = norm(vels.toMarsDepart.vinf - leoVelocity)


	%Set up two orbits at mars; one in low earth orbit and the other at the
	%surface. This will allow us to transfer between the two
	LMO = fromAE(marsFactory,3575000, 0, toRadians(336.05637041));
	marsSurface = fromAE(marsFactory,3390000,0,toRadians(0));

	%generate hyperbolic orbit
	hyperbolicOrbit = fromHYP(marsFactory,vels.toMarsArrival.vinf,LMO.rmin);
	hyperbolicOrbit.refAngle-=.5;

	%generate landing pattern
	landingOrbit = hohmannTransfer(LMO,marsSurface,pi/2);

	%output velocities at overlapping points in hyperbolic trajectory and LMO
	vels.toMarsArrival.peri.hyp = velocity(hyperbolicOrbit,hyperbolicOrbit.refAngle);
	vels.toMarsArrival.peri.lmo = velocity(LMO,hyperbolicOrbit.refAngle);

	%change in velocity to exit the orbit
	deltaV(3) = norm(vels.toMarsArrival.peri.hyp - vels.toMarsArrival.peri.lmo);
	%change in velocity to land in the landing orbit (although it is not the surface speed)
	vels.marsSurface.landingVel = velocity(landingOrbit,landingOrbit.refAngle+pi);
	deltaV(4) = norm(vels.marsSurface.landingVel - vels.toMarsArrival.peri.lmo);

	%match the surface speed
	marsSurfaceSpeedsCalc='here'
	vels.marsSurface.surfSpeed = [0,239.9]
	vels.marsSurface.touchDown = velocity(landingOrbit,landingOrbit.refAngle);

	%Calculate delta-V 
	deltaV(5) = norm(vels.marsSurface.surfSpeed - vels.marsSurface.touchDown );

	%do it in reverse
	vels.marsSurface.liftOff = vels.marsSurface.touchDown;

	%change in velocity to get off the surface of mars
	deltaV(6) = norm(vels.marsSurface.liftOff - vels.marsSurface.surfSpeed);

	%velocity change to get into lmo
	vels.toEarthDepart.lmo = vels.toMarsArrival.peri.lmo;
	deltaV(7) = norm(vels.toEarthDepart.lmo - vels.marsSurface.landingVel);



	%finally, get on the transfer orbit back to earth
	%set up the hyperbolic orbit and get the velocities
	finalMarsHyp = fromHYP(marsFactory, vels.toEarthDepart.vinf, LMO.rmin);
	
	%find the difference between the velocities
	deltaV(8) = norm(vels.toEarthDepart.lmo - vels.toEarthDepart.vinf);

	%match the speed needed to get back to mars (from hyperbolic)
	vels.toEarthDepart.mars.hyp = velocity(MEorb, MEmap.depart.first);
	departHypOrbit = fromHYP(marsFactory, vels.toEarthDepart.mars.hyp, LMO.rmin);


	deltaV
	figure(3,'visible','off');
		graph(hyperbolicOrbit, hyperbolicOrbit.refAngle, 3*pi/4, 3);
		graph(marsSurface, 0, 2*pi, 3);
		graph(landingOrbit,0, 2*pi, 3);
		graph(LMO, 0, 2*pi, 3);
		axis([-7e6,7e6,-7e6,7e6]);

		%reference points on plot
		%Intersection between LMO and hyperbolic entry orbit
			%pointGraph(LMO,angleRel(hyperbolicOrbit,hyperbolicOrbit.rmin),10, 3);
		%Intersection between hyperbolic Orbit and entry orbit
			%pointGraph(hyperbolicOrbit,angleRel(hyperbolicOrbit,hyperbolicOrbit.rmin),20, 3);
		%Intersection between LMO and landing orbit
			%pointGraph(landingOrbit,landingOrbit.refAngle+pi,10,3)
		%Intersection betwteen landing orbit and mars surface
			%pointGraph(marsSurface,landingOrbit.refAngle,45,3)
		print('mars.pdf');

	printf('Depart Date: %s', datestr(earthPeri + EMmap.depart.time/3600/24));
	printf('Arrival Date: %s', datestr(earthPeri + EMmap.arrival.time/3600/24));
	printf('Depart Date: %s', datestr(earthPeri + MEmap.depart.time/3600/24));
	printf('Arrival Date: %s', datestr(earthPeri + MEmap.arrival.time/3600/24));
	printf('%f', MEestTime/3600/24);

