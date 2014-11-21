%return the amount of time that it takes an orbital body to travel between two
%angles (which are relative angles/theta*). Uses timeInt function.
function t = timeDiff(obj, angleInit, angleFinal)
	t = semiLatus(obj).^(3/2.0) / (sqrt(obj.bigG*obj.centerMass)) * (timeInt(angleFinal, obj.eccentricity) - timeInt(angleInit,obj.eccentricity));
end
