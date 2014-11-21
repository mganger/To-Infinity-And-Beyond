%This function is use to find a transfer orbit between two given polar
%coordinates, with a transfer time eqivalent to the one provided. If graph is
%equal to one, it will also plot the graph that fsolve is finding the root of.
%This generally finds the correct orbit; the only major problem results from
%fsolve trying imaginary values.
function obj, tDiff = fromPolarRef(orbFact, timeReq, ci, cf, graph)
	%optimize the polarRef function such that the amount of time between the two angles
	%is the same as the time required

	%make a function with the tmpOrb that shifts the reference angle and finds the timeDiff
	func = @(ot) (tDiffFunction(orbFact, ot, ci, cf) - timeReq);

	try graph == 1; catch graph = 0; end
	if(graph == 1)
		%graph the function
		xDomain = linspace(0, 1*pi, 1000);
		for n = 1:length(xDomain)
			range(n) = func(xDomain(n));
		end

		figure(2)
			plot(xDomain, range);
			axis([0, 1*pi, -2e7, 1e8])
	end

	%optimize it; use fsolve
	try
		options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000,'ComplexEqn', 'off');
		refAngle = fsolve(func, 1.5, options);
		%refAngle = fzero(func, 1.3, 1.7, options);
		[tDiff, obj] = tDiffFunction(orbFact, refAngle, ci, cf);
	catch
		error('Could not find the reference angle for the orbit');
	end
end

%This function calculates an orbit between two polar coordinates given a
%reference angle, and returns the amount of time that it takes the orbiting
%body to travel between two points. This is the function that the above
%function optimizes
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
