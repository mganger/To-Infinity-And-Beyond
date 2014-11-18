function o = fromHYP(obj,vinf,rmin,angleOffset)
	G = 6.6738480e-11;
	theta = atan(vinf(2)/vinf(1))
	o.vmin = sqrt(vinf^2+2*G*obj.centerMass/rmin);
	o.semiMajor = -G*obj.centerMass/speed.^2;
	o.eccentricity = 1-rmin/o.semiMajor;
	o.alpha = rmin + rmin * o.eccentricity;
	o.refAngle = angleOffset;
	o.centerMass = obj.centerMass;
	o.bigG = G;
end
