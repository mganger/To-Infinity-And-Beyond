function v = velocity(obj,angle)
	tmp = sqrt(obj.bigG * obj.centerMass / obj.semiLatus() );
	v(1) = tmp * obj.eccentricity * sin(angle)
	v(2) = tmp * (1 + obj.eccentricity * cos(angle))
end
