%Return the magnitude of the velocity vector at a given radius from the mass
function w = angularSpeed(obj,radius)
	w = specAngMom(obj) / (radius*radius);
end
