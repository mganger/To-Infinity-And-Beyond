function a = semiLatus(obj)
	a = obj.semiMajor*(1-obj.eccentricity.^2)
end
