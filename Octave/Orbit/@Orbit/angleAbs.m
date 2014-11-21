%This function takes an orbit and a given radius, and returns the angle that
%the object is at in the reference frame.
function a = angleAbs(obj,radius)
	a = acos( (semiLatus(obj) - radius) / (radius * obj.eccentricity));
end
