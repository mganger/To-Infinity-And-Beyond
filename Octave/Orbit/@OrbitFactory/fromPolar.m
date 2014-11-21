%function to construct an orbit from two polar coordinates (r,theta*)
%does not provide a reference angle
%NOT USED
function orb = fromPolar(fact, ci, cf, refAng)
	try refAng == 0; catch refAng = 0; end
	r1 = ci(1), t1 = ci(2),
	r2 = cf(1), t2 = cf(2),

	ecc = orb.eccentricity = (r1 - r2) / (r1*cos(t1-refAng) - r2*cos(t2-refAng));
	semiLatus = (-r1*cos(t2-refAng) + r2*cos(t1-refAng)) / (cos(t1-refAng) - cos(t2-refAng));
	orb.semiMajor = semiLatus / (1 - ecc*ecc);


	orb.centerMass = fact.centerMass;
	orb.massName = fact.massName;
	orb.bigG = 6.6738480e-11;
end
