function v = velocity(obj,angle)
	tmp = sqrt(obj.bigG * obj.centerMass / semiLatus(obj) );
	v = [0,0];
	v(1) = tmp * obj.eccentricity * sin(angle);
	v(2) = tmp * (1 + obj.eccentricity * cos(angle));
end
