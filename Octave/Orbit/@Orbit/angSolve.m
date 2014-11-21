%solve for an angle using the periapsis time difference. Opposite of timeDiff. Takes an intial angle and returns the next angle that the body will be at, givent the target time.
function a = angSolve(obj, angleInit, targetTime)

	options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);

	func = @(ang) (targetTime - timeDiff(obj, angleInit, ang));
	a = fsolve(func, 0.2, options);
end
