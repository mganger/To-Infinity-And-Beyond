%return the radius of a body at a given orbit (the angle is in the reference frame)
function r = radiusAbs(obj,ang)
	r = semiLatus(obj) / (1 + obj.eccentricity*cos(ang-obj.refAngle));
end
