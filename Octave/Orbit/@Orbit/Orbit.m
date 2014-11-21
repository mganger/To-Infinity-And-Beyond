function obj = Orbit(a,e,w,m,name)
	obj.massName = name;
	obj.bigG = 6.6738480e-11;

	obj.semiMajor = a;
	obj.refAngle = w;
	obj.eccentricity = e;
	obj.centerMass = m;
	obj.alpha = a*(1-e.^2);
	obj.rmin = obj.alpha/(1+e);
	obj.vmin = sqrt(obj.bigG*2*m*(1/obj.rmin-1/(2*a)));
end
