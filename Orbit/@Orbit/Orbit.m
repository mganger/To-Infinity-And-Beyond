function obj = Orbit(a,e,w,m,name)
	obj = struct;
	obj.semiMajor = a;
	obj.refAngle = w;
	obj.eccentricity = e;
	obj.centerMass = m;

	obj.massName = name;
end
