clear all;close all;clc;
addpath('Orbit/@Orbit');
addpath('Orbit/@OrbitFactory');
addpath('helper_functions');

domain = linspace(0,3*pi,1000);

radius = @(th) 1./(1+1*cos(th)); 
	
	marsFactory = OrbitFactory(639e21,'Mars');
	sunFactory = OrbitFactory(1.98855e30,'Sun')

	shipOrbit  = fromAE(sunFactory, 3500, .9, 1.3*pi)
	shipOrbit2  = fromAE(marsFactory, 3500, .9, 1.3*pi)

for i = 1:length(domain)
	rad(i) = radiusAbs(shipOrbit,domain(i));
end

for i = 1:length(domain)
	rad2(i) = radiusAbs(shipOrbit2,domain(i));
end

figure(1)
	polar(domain,rad);
figure(2)
	polar(domain,rad2);
