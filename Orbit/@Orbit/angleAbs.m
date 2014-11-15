function a = angleAbs(obj,radius)
	a = acos( (obj.semiLatus() - obj.radius) / (obj.radius * obj.eccentricity));
end
