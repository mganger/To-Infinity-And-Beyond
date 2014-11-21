%Calculates a Hohmann Transfer between two circular orbits given an angle of periapsis
%This function makes assumptions based on circular orbits and is designed to calculate mars surface transfer orbitals
function ret = hohmannTransfer(orbit1,orbit2,omega)
	try omega == 2;
		ret.refAngle = omega;
	catch 
		ret.refAngle = 0;
	end

	G = 6.6738480e-11;
	rmin = orbit2.rmin;
	rmax = orbit1.rmin;
	vmin = orbit2.vmin;
	vmax = orbit1.vmin;

	ret.alpha = 2*rmax*rmin/(rmax+rmin);
	ret.eccentricity = ((ret.alpha-rmin)/rmin);
	ret.semiMajor = ret.alpha/(1-ret.eccentricity.^2);
	ret.bigG = G;
	if(orbit1.centerMass == orbit2.centerMass)
		ret.centerMass = orbit1.centerMass
	else
		print = 'What are you even going around?'
	end
end
