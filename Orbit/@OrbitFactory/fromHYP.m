function o = fromHYP(obj,vinf,rmin)
	G = 6.6738480e-11;

	speed = norm(vinf);
	o.bigG = G;
	theta = atan(vinf(1)/vinf(2));
	o.centerMass = obj.centerMass;
	o.rmin = rmin;
	o.semiMajor = -G*obj.centerMass/speed.^2;

	o.eccentricity = 1-rmin/o.semiMajor;
	o.alpha = o.semiMajor * (1- o.eccentricity*o.eccentricity);
	o.refAngle = theta + acos(-1/o.eccentricity);
	cosspart = acos(1/o.eccentricity);
%	o.rmin = o.alpha/(1+o.eccentricity);
end
