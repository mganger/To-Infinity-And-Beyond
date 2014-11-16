function a = angleAbs(obj,radius)
	a = acos( (semiLatus(obj) - radius) / (radius * obj.eccentricity));
end
