%Steps to get to Mars and Back
%	Calculate transfer from Earth to Mars
%	Transfer from hyperbolic to LMO
%	Wait until we are at one of the two spots on the line of mars axis (projected onto the top view)
%		Separate and descend to mars
%		Stay on the surface for about 30 days
%		Get back into orbit, and possibly reconvene with some fuel in orbit
%	Transfer from LMO to hyperbolic
%	Calculate Mars to Earth

format short eng;

options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
addpath('Orbit/@Orbit');
addpath('Orbit/@OrbitFactory');
addpath('helper_functions');

function print(a,b,c,d,e,f,g)
	try       Message = strcat(a,num2str(b),c,num2str(d),e,num2str(f),g)
	catch try Message = strcat(a,num2str(b),c,num2str(d),e,num2str(f))
	catch try Message = strcat(a,num2str(b),c,num2str(d),e)
	catch try Message = strcat(a,num2str(b),c,num2str(d))
	catch try Message = strcat(a,num2str(b),c)
	catch try Message = strcat(a,num2str(b))
	catch try Message = strcat(a)
	end end end end end end end
end

%step 1:
	%transfer from earth to mars
	sunFactory = OrbitFactory(1.98855e30, 'Sun');

	%args(factory, semiMajorAxis, Eccentricity, angleToReference)
	earthOrbit = fromAE(sunFactory, 149.60e9, 0.01671022, toRadians(102.93768193));
	marsOrbit  = fromAE(sunFactory, 227.92e9, 0.0935,     toRadians(336.05637041));

	%map the earth angles to the mars angles
	earthMarsMap = struct;


	%periapsis of mars minus periapsis of earth, in seconds
	periTimeDiff = (datenum(2015,1,4) - datenum(2014,12,12))*24*3600;
	%angle of mars in its orbit at t = 0
	earthMarsMap.init.time = 0;
	earthMarsMap.init.earth = 0;
	earthMarsMap.init.mars = angSolve(marsOrbit, 0, periTimeDiff);

	domain = linspace(0,2*pi,10000);
	plot(domain, timeDiff(marsOrbit, 0, domain));
