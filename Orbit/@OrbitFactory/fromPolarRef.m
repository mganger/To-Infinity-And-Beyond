function obj = fromPolarRef(orbFact, timeReq, ci, cf)
	%optimize the polarRef function such that the amount of time between the two angles
	%is the same as the time required
	printf('Time required is %.0f days\n', timeReq/3600/24);
	r1 = ci(1), t1 = ci(2),
	r2 = cf(1), t2 = cf(2),

	%make a function with the tmpOrb that shifts the reference angle and finds the timeDiff
	func = @(ot) tDiffFunction(orbFact, ot, ci, cf);

	domain = linspace(0,pi,1000);
	for n = 1:length(domain)
		range(n) = func(domain(n));
	end;
	figure(2)
		plot(domain, range)
		axis([0, pi, -2e7, 1e8])


	%optimize it; use fsolve
	try
		options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
		refAngle = fsolve(func, 0.2, options);
		[tmp, obj] = tDiffFunction(orbFact, refAngle, ci, cf);
	catch
		error('Could not find the reference angle for the orbit');
	end
end

function tDiff, orb = tDiffFunction(orbFact, ot, ci, cf)
	r1 = ci(1); t1 = ci(2);
	r2 = cf(1); t2 = cf(2);
	%find orbital parameters
	ecc = orb.eccentricity = (r1 - r2) / (r1*cos(t1-ot) - r2*cos(t2-ot));
	semiLatus = (-r1*cos(t2-ot) + r2*cos(t1-ot)) / (cos(t1-ot) - cos(t2-ot));
	orb.semiMajor = semiLatus / (1 - ecc*ecc);

	orb.centerMass = orbFact.centerMass;
	orb.massName = orbFact.massName;
	orb.bigG = 6.6738480e-11;
	orb.refAngle = ot;

	tDiff = timeDiff(orb, t1 - ot, t2 - ot);
end
