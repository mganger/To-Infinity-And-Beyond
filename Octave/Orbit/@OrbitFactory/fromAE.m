%Simplest construction of orbits from the orbital parameters. Takes the factory
%(body), semimajor axis, eccentricity, and angle of offset from the reference
%angle (omegaT)
function o = fromAE(obj,semi, eccent, angleOffset)
	o = Orbit(semi, eccent, angleOffset, obj.centerMass, obj.massName);
end
