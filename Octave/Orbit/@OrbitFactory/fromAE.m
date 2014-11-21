function o = fromAE(obj,semi, eccent, angleOffset)
	o = Orbit(semi, eccent, angleOffset, obj.centerMass, obj.massName);
end
