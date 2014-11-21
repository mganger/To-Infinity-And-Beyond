%Takes an angle and an orbital.
%Angle is measured from the orbital's reference frame and added to omega(w) to find the absolute angle.
function a = absAngle(ang, orb)
	a = ang + orb.refAngle;
end
