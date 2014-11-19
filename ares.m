clear all;close all
%From hyperbolic to hyperbolic
%	hyper	->	LMO
%	LMO 	->	Surface
%	Surface ->	LMO
%	LMO 	->	Hyper

options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
addpath('Orbit/@Orbit');
addpath('Orbit/@OrbitFactory');
addpath('helper_functions');

%declare vinf until we can receive it from another obit
vinf = [0,30000]

	%create a Sun Factory for the hyperbolic orbit
	%create a Mars Factory for the circularized LMO
	sunFactory = OrbitFactory(1.98855e30,'Sun');
	marsFactory = OrbitFactory(639e21,'Mars');


	%generate circularized LMO and begin tracking mars surface as an orbit
	LMO = fromAE(marsFactory,3575000, 0, toRadians(336.05637041));
	marsSurface = fromAE(marsFactory,3390000,0,toRadians(0));

	%generate hyperbolic orbit
	hyperbolicOrbit = fromHYP(marsFactory,vinf,LMO.rmin);
	hyperbolicOrbit.refAngle;

	%generate landing pattern
	landingOrbit = hohmannTransfer(LMO,marsSurface,pi/2);



	%output velocities at overlapping points in hyperbolic trajectory and LMO
	hyperbolicVelocity = velocity(hyperbolicOrbit,hyperbolicOrbit.refAngle)
	LMOvelocity = velocity(LMO,hyperbolicOrbit.refAngle)



	%Calculate delta-V to enter LMO
	printf("delta-V (1) = %f\n", LMOvelocity(1) - hyperbolicVelocity(1) )
	printf("delta-V (2) = %f\n", LMOvelocity(2) - hyperbolicVelocity(2) )
	deltaVLMO= norm(LMOvelocity - hyperbolicVelocity)
	deltaV(1) = deltaVLMO;


	%Calculate the velocities at overlapping points in LMO and landing orbit
%	LMOvelocity = velocity(LMO,hyperbolicOrbit.refAngle)
	landingVelocity = velocity(landingOrbit,landingOrbit.refAngle+pi)

	%Calculate delta-V to enter landing orbit
	printf("delta-V (1) = %f\n",landingVelocity(1) - LMOvelocity(1))
	printf("delta-V (2) = %f\n",landingVelocity(2) - LMOvelocity(2))
	deltaVLandingOrbit = norm(landingVelocity - LMOvelocity)
	deltaV(2) = deltaVLandingOrbit;
	
	
	%Calculate velocities matching landing time
	marsSurfaceVelocity = velocity(marsSurface,marsSurface.refAngle)
	touchdownVelocity = velocity(landingOrbit,landingOrbit.refAngle)

	%Calculate delta-V 
	printf("delta-V (1) = %f\n",marsSurfaceVelocity(1) - touchdownVelocity(1))
	printf("delta-V (2) = %f\n",marsSurfaceVelocity(2) - touchdownVelocity(2))
	deltaVtouchdown = norm(marsSurfaceVelocity - touchdownVelocity)
	deltaV(3) = deltaVtouchdown;
	
	liftOffVelocity = touchdownVelocity;

	%Prepare to lift off
	printf("delta-V (1) = %f\n", liftOffVelocity(1) - marsSurfaceVelocity(1) )
	printf("delta-V (2) = %f\n", liftOffVelocity(2) - marsSurfaceVelocity(2) )
	deltaVliftOff = norm(liftOffVelocity - marsSurfaceVelocity)

	deltaV(4) = deltaVliftOff;

	%Calculate delta-V to re-enter LMO
	printf("delta-V (1) = %f\n", LMOvelocity(1) - landingVelocity(1))
	printf("delta-V (2) = %f\n", LMOvelocity(2) - landingVelocity(2))
	deltaVLandingOrbit = norm(LMOvelocity - landingVelocity)
	deltaV(5) = deltaVLandingOrbit;


	%Calculate delta-V to return to Earth
	%need a vinf-final to calculate
%	printf("delta-V (1) = %f\n", LMOvelocity(1) - landingVelocity(1))
%	printf("delta-V (2) = %f\n", LMOvelocity(2) - landingVelocity(2))
%	deltaVLandingOrbit = norm(LMOvelocity - landingVelocity)
%	deltaV(6) = deltaVLandingOrbit;


%printf("Total deltaVs are: %f\n",deltaV)
printf("Total deltaVs are: %f",sum(deltaV))

	%graphs each orbit
figure(1,'visible','off');
	graph(hyperbolicOrbit);
	graph(marsSurface);
	graph(landingOrbit);
	graph(LMO);

%reference points on plot
	%Intersection between LMO and hyperbolic entry orbit
		pointGraph(LMO,angleRel(hyperbolicOrbit,hyperbolicOrbit.rmin),10);
	%Intersection between hyperbolic Orbit and entry orbit
		pointGraph(hyperbolicOrbit,angleRel(hyperbolicOrbit,hyperbolicOrbit.rmin),20);
	%Intersection between LMO and landing orbit
		pointGraph(landingOrbit,landingOrbit.refAngle+pi,10)
	%Intersection betwteen landing orbit and mars surface
		pointGraph(marsSurface,landingOrbit.refAngle,45)
print('file.pdf');
