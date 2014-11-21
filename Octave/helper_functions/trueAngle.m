%return the true angle for the theta* of a given orbit
function a = trueAngle(ang, orb)
	a = orb.refAngle + ang;
end
