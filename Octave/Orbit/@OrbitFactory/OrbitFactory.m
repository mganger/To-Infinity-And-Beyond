%Constructor for the Orbit factory. Although the term "factory" is used
%throughout the code, what it really represents is the large mass at the center
%of orbits (Sun, Earth, Mars). "Factory" is just used to keep the factory
%pattern in mind
function obj = OrbitFactory(mass,name)
	obj.centerMass = mass;
	obj.massName = name;
end
