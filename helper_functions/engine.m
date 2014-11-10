%Information about rocket
%Currently using the Space Launch System


function impulse = getImpulse(a) 
	%Specific Impulse
	%	1: 270 seconds
	%	2: 452 seconds
	%	3: 462 seconds
	SI = [270,452,462];
	impulse = SI(cast(a,'int8'))
endfunction

function returnThrust = getThrust(a)
	%Thrust
	%	1: 20015372.7084 Newtons
	%	2:  7437363.3817 Newtons
	%	3: 2562085.38648 Newtons
	thrust = [20015372.7084,7437363.3817,2562085.38648];
	returnThrust = thrust(cast(a,'int8'))
endfunction

function returnWeight = getWeight(a)
	%Weight for each stage
	%	1:
	%	2:
	%	3:
	weight = [00,00,00];
	returnWeight = weight(cast(a,'int8'))
endfunction

function capacity = getCapacity
	capacity = 0
endfunction

function propellant = getPropellantMass(a)
	%Propellant Mass
	%	1: 6952914.870305761
	%	2: 
	%	3: 
	propellantMass = [6952914.870305761,0000,0000]
	returnMass = propellantMass(cast(a,'int8'))
endfunction

function burnTime = getBurnTime
	burnTime = 8
endfunction
