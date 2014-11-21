%return the period of a given orbit (in seconds)
function p = period(obj)
	p = 2*pi*obj.semiMajor.^(3/2.0) / (sqrt(obj.bigG*obj.centerMass));
end
