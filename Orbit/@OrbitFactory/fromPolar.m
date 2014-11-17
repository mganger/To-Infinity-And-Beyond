%function to construct an orbit from two polar coordinates (r,theta*)
%does not provide a reference angle
function orb = fromPolar(fact, ci, cf)
	r1 = ci(1); t1 = ci(2);
	r2 = cf(1); t2 = cf(2);

	ecc = orb.eccentricity = (r2 - r1) / (r1*cos(t1) - r2*cos(t2));
	semiLatus = (r2 - r1) / (r1*cos(t1) - r2*cos(t2));

	orb.semiMajor = semiLatus / (1 - ecc*ecc);
	orb.centerMass = fact.centerMass;
	orb.massName = fact.massName;
	obj.bigG = 6.6738480e-11;
end
