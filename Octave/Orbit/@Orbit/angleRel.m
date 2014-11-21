%Takes an orbit and a given orbit and returns the angle that the body is at, in the orbit frame
function a = angleRel(obj,radius)
	a = angleAbs(obj,radius) + obj.refAngle;
end
