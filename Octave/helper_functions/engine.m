%Information about rocket
%Currently using the Space Launch System
%Information was not used in our calculations
%These same numbers were used explicitly in the calculations in MassRatio.m 


function payload= getPayload
	% Payload to LEO in Newtons
	payload= 1274864.5;
endfunction

function impulse = getImpulse(a) 
	%Specific Impulse
	%	1: Two Solid Rocket Boosters	269 seconds 
	%	2: RS-25D/E Engine		452 seconds 
	%	3: J-2X Engine			448 seconds 
	SI = [269,452,448];
	impulse = SI(cast(a,'int8'));
endfunction

function returnThrust = getThrust(a)
	%Thrust
	%	1: Two Solid Rocket Boosters	20015372.708 Newtons (per Rocket)
	%	2: RS-25D/E Engine 		7437363.3817 Newtons
	%	3: J-2X Engine			1310000 Newtons
	thrust = [20015372.708 * 2,2278000 * 4,1310000 * 2];
	returnThrust = thrust(cast(a,'int8'));
endfunction

function returnPropellantMass= getPropellantMass(a)
	%Useable Propellant Mass for each stage
	%	1: Stage 1	8820000		Newtons
	%	2: Stage 2	9473920.2	Newtons
	%	3: Stage 3	2020366.039	Newtons
	propellantMass = [8820000,9473920.2,2020366.039];
	returnPropellantMass = propellantMass(cast(a,'int8'));
endfunction

function returnBurnoutMass = getBurnoutMass(a)
	%Burnout Mass for each stage
	%	1: Stage 1	823758.602	Newtons
	%	2: Stage 2	1230391.346	Newtons
	%	3: Stage 3	301162.222	Newtons
	burnoutMass= [823758.602,1230391.346,301162.222	];
	returnBurnoutMass = burnoutMass(cast(a,'int8'));
endfunction

function returnDryMass = getDryMass(a)
	%Dry Mass for each stage
	%	1: Stage 1	0		Newtons
	%	2: Stage 2	1133423.190	Newtons
	%	3: Stage 3	258895.561	Newtons
	dryMass = [0,1133423.190,258895.561];
	returnDryMass = dryMass(cast(a,'int8'));
endfunction

function returnBurnTime = getBurnTime(a)
	%	1: Two Solid Rocket Boosters	124 seconds
	%	2: RS-25D/E Engine 		476 seconds
	%	3: J-2X Engine			431 seconds
	burnTime = [124,476,431];
	returnBurnTime = burnTime(cast(a,'int8'));
endfunction
