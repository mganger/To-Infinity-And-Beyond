function obj = fromPolarRef(orbFact, timeReq, ci, cf)
	%optimize the polarRef function such that the amount of time between the two angles
	%is the same as the time required

	%get the orbit without the reference
	tmpOrb = fromPolar(orbFact, ci, cf);

	%make a function with the tmpOrb that shifts the reference angle and finds the timeDiff
	func = @(ot) timeDiff(tmpOrb, ci(2) - ot, cf(2) - ot) - timeReq;

	%optimize it; use fsolve
	try
		options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
		obj.refAngle = fsolve(func, 0.2, options);
	catch
		error('Could not find the reference angle for the orbit');
	end
end
