function t = timeDiff(obj,angleInit, angleFinal)
	t = obj.semiMajor.^(3/2.0) / (sqrt(obj.bigG*obj.centerMass)) * (timeInt(angleFinal, obj.eccentricity) - timeInt(angleInit,obj.eccentricity));
end
