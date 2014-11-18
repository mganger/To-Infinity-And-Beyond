function o = fromHYP(obj,vinf,rmin,angleOffset)
	G = 6.6738480e-11;
	obj.centerMass
	G
	vinf
	rmin
	angleOffset

%	o.eccentricity = -(rmin*vinf*vinf+obj.centerMass*G)/(rmin*vinf*vinf);
%	o.semiMajor = (-obj.centerMass*G)/(vinf*vinf)
%	o.semiMajor = rmin/(1-o.eccentricity)
	vmin = sqrt(vinf.^2+2*G*obj.centerMass/rmin)
%	o.semiMajor = G*M/(2*(G*M/rmin)-(vmin).^2)
	o.semiMajor = -G*obj.centerMass/vinf.^2
	o.eccentricity = 1-rmin/o.semiMajor
	o.alpha = rmin + rmin * o.eccentricity
	o.refAngle = angleOffset;
	o.centerMass = obj.centerMass;
	o.bigG = G;
end

%Things we need:
%center mass
%eccentricity
%semi major axis
%angleOffset
