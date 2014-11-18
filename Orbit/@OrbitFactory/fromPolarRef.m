function obj = fromPolarRef(orbFact, timeReq, ci, cf)
	%optimize the polarRef function such that the amount of time between the two angles
	%is the same as the time required
	printf('Time required is %.0f days\n', timeReq/3600/24);

	%make a function with the tmpOrb that shifts the reference angle and finds the timeDiff
	func = @(ot) (tDiffFunction(orbFact, ot, ci, cf) - timeReq);

	%graph the function
	xDomain = linspace(0, 1*pi, 1000);
	for n = 1:length(xDomain)
		range(n) = func(xDomain(n));
	end

	figure(2)
		plot(xDomain, range);
		axis([0, 1*pi, -2e7, 1e8])



	%optimize it; use fsolve
	try
		options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000,'ComplexEqn', 'off');
		refAngle = fsolve(func, 1.5, options);
		%refAngle = fzero(func, 1.3, 1.7, options);
		[tmp, obj] = tDiffFunction(orbFact, refAngle, ci, cf);
	catch
		error('Could not find the reference angle for the orbit');
	end
end

function tDiff, orb = tDiffFunction(orbFact, ot, ci, cf)
	r1 = ci(1); t1 = ci(2) - ot;
	r2 = cf(1); t2 = cf(2) - ot;
	%find orbital parameters
	ecc = orb.eccentricity = -1*(r1 - r2) / (r1*cos(t1) - r2*cos(t2));
	semiLatus = r1*(ecc*cos(t1) + 1);
	orb.semiMajor = semiLatus / (1 - ecc*ecc);

	orb.centerMass = orbFact.centerMass;
	orb.massName = orbFact.massName;
	orb.bigG = 6.6738480e-11;
	orb.refAngle = real(ot);

	tDiff = timeDiff(orb, t1, t2);
end
