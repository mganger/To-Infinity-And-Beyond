function o = fromHYP(obj,vinf,rmin)
	G = 6.6738480e-11;

	theta = atan(vinf(2)/vinf(1));

	speed = norm(vinf);
	o.semiMajor = -G*obj.centerMass/speed.^2;
	o.eccentricity = 1-rmin/o.semiMajor;
	o.alpha = rmin + rmin * o.eccentricity;
	o.centerMass = obj.centerMass;
	o.bigG = G;
	o.refAngle = theta + acos(-1/o.eccentricity);
end
