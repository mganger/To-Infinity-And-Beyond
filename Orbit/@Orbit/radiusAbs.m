function r = radiusAbs(obj,angle)
	r = obj.semiLatus() / (1 + obj.eccentricity*cos(angle-obj.refAngle));
end
