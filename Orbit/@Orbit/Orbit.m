function obj = Orbit(a,e,w,m,name)
	obj.semiMajor = a;
	obj.refAngle = w;
	obj.eccentricity = e;
	obj.centerMass = m;

	obj.massName = name;
	obj.bigG = 6.6738480e-11;
end
