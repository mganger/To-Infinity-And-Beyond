%Takes a body's position in an orbit and outputs the relative angle within that orbit's reference frame.
function a = relAngle(ang, orb)
	a = ang - orb.refAngle;
end
