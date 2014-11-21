%file to hold helper functions for script
function result = requiredMass(astronautCount, days)
	%Assume that 2.32 kg of food needed per day, 7 pounds of water, and 2 pounds of oxygen
	food_H20_O2_mass = days*astronautCount*(2.32 + (7 + 2)*0.45359237);
	astronauts_mass = astronautCount*70; %153 pounds per person (70kg)

	result = food_H20_O2_mass + astronauts_mass;
