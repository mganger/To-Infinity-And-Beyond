function r = radiusRel(obj,angle)
	r = obj.semiLatus() / (1 + obj.eccentricity*cos(angle));
end
