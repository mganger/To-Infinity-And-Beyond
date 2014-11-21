function r = radiusRel(obj,angle)
	r = semiLatus(obj) / (1 + obj.eccentricity*cos(angle));
end
