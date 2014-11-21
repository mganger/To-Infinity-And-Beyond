%This is the script that was used to calculate the Monte Carlo test to find the
%most ideal transfers. It calculates orbits both to and from mars, and uses an
%exact time of 30 days on the surface of mars to determine the angle of the
%return trip. This script can find two transfers at a rate of about 3.5Hz on an
%i5 processor (single thread). It is recommended to multiple scripts at the same
%time (multi threading). The script for this is called multThread.sh.

%
%make sure you define these variables before calling this script:
%thetaD			step1			step2			iterStep	thetaDEnd 	step1End	step2End	filename
%depart from earth	increment to arrive	increment after depart	for loop steps

%iterations:
%	thetaD:thetaDEnd
%	step1:step1End
%	step2:step2End

format short eng; close all;

options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
addpath('Orbit/@Orbit');
addpath('Orbit/@OrbitFactory');
addpath('helper_functions');

try timeInt(); catch end
printf('\n\n');


function bool = aboutEq(a, b, diff)
	a/3600/24
	b/3600/24
	bool = (abs(a-b) < diff)
end

file = fopen(filename, 'w');
while(1==1)
	a = unifrnd(thetaD,thetaDEnd);
	b = unifrnd(step1, step1End);
	c = unifrnd(step2, step2End);

	%transfer from earth to mars
	sunFactory = OrbitFactory(1.98855e30, 'Sun');

	%args(factory, semiMajorAxis, Eccentricity, angleToReference)
	earthOrbit = fromAE(sunFactory, 149.60e9, 0.01671022, toRadians(102.93768193));
	marsOrbit  = fromAE(sunFactory, 227.92e9, 0.0935,     toRadians(336.05637041));
	earthPeri = datenum(2014,12,12);
	marsPeri  = datenum(2015,01,04);

	thetaA = a + b;
	[EMorb, EMmap, EMreqTime, EMestTime] = transferArc(sunFactory, earthOrbit, earthPeri, marsOrbit, marsPeri, a, thetaA, 'graph.pdf', quiet=1, plot=0);

	%spin mars 30 days into the future
	marsDepart = angSolve(marsOrbit, EMmap.arrival.second, 30*3600*24);
	while(marsDepart <= thetaA) marsDepart += 2*pi; end;
	thetaD1 = marsDepart;
	thetaA1 = marsDepart + c;
	[MEorb, MEmap, MEreqTime, MEestTime] = transferArc(sunFactory, marsOrbit, marsPeri, earthOrbit, earthPeri, thetaD1, thetaA1, 'graph2.pdf', quiet=1, plot=0);

	if(aboutEq(EMreqTime, EMestTime, 24*3600) != 1 | aboutEq(MEreqTime, MEestTime, 3600*24) != 1)
		continue;
	end;


	printf('t1=%.0f,t2=%.0f,thetaD=%f,thetaA=%f,thetaD2=%f,thetaA2=%f\n', EMreqTime/24/3600, MEreqTime/24/3600, a, thetaA, thetaD1, thetaA1);
	fprintf(file, '%f,%f,%f,%f,%f,%f\n', EMreqTime, MEreqTime, a, thetaA, thetaD1, thetaA1);
end
fclose(file);


fclose(file);
