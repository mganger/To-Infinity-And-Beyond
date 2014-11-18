function ret = pointGraph(orbit,angle,size)
	try size == 2
	scatter(radiusAbs(orbit,angle)*cos(angle),radiusAbs(orbit,angle)*sin(angle),size);
	catch
	hold on;
	scatter(radiusAbs(orbit,angle)*cos(angle),radiusAbs(orbit,angle)*sin(angle),30);
	end
end
