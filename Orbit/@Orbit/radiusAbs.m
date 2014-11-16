function r = radiusAbs(obj,ang)
	r = semiLatus(obj) / (1 + obj.eccentricity*cos(ang-obj.refAngle));
end
