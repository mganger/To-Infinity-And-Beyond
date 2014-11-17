function ret = pointGraph(orbit,angle)
	hold on;
	scatter(radiusAbs(orbit,angle)*cos(angle),radiusAbs(orbit,angle)*sin(angle),30);
end
