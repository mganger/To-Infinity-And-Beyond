function ret = graph(orbit,theta1,theta2,figureNum)

try figureNum == pi
catch figureNum = 1;
end

try domain = linspace(theta1,theta2,1000);
catch domain = linspace(0,2*pi,1000);
end
	
for i = 1:length(domain)
	rad(i) = radiusAbs(orbit,domain(i));
end

%make a polar plot of the semimajor axis
xdomain = linspace(-1,1,10).*orbit.semiMajor;

figure(figureNum)
	hold on;
	polar(domain,rad);
	plot(xdomain, xdomain.*tan(orbit.refAngle));
end
