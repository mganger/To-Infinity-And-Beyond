%return the radius of a given orbit at a given angle (theta star)
function r = radiusRel(obj,angle)
	r = semiLatus(obj) / (1 + obj.eccentricity*cos(angle));
end
