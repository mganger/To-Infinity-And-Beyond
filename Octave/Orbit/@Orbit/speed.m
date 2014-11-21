%return the speed of a given orbit at a given radius
function v = speed(obj,radius)
	v = sqrt(2*obj.bigG*obj.centerMass * ( 1/radius - 1/(2*obj.semiMajor)));
end
