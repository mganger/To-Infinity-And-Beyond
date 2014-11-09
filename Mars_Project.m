%Dr. Kurt Aikens, November 2014 
%Preliminary Earth-Mars Transfer Calculations
%Mechanics I
clear all; clc; close all; format long eng; more off; 
addpath('helper_functions')
%Note: "more off" allows the script to scroll all the way to the end.

%---------------------------------------------------------
%When using fsolve/fzero, use the following:
  %[output, f, info] = fsolve( function, guess, options );
  %or
  %[output, f, info] = fzero( function, [lower bound guess, upper bound guess], options );

  %output = the variable that you want, i.e., the value for output that gives f(output) ~ 0
  %f = the value of the function, f(output) ~ 0
  %info = the exit flag. The following values are possible. You want info > 0 and ideally, info = 1:
    %1 Function converged to a solution x.
    %2 Change in x was smaller than the specified tolerance.
    %3 Change in the residual was smaller than the specified tolerance.
    %4 Magnitude of search direction was smaller than the specified tolerance.
    %0 Number of iterations exceeded options.MaxIter or number of function evaluations exceeded options.MaxFunEvals.
    %-1 Output function terminated the algorithm.
    %-2 Algorithm appears to be converging to a point that is not a root.
    %-3 Trust region radius became too small (trust-region-dogleg algorithm).
    %-4 Line search cannot sufficiently decrease the residual along the current search direction.
%---------------------------------------------------------

%Options for fsolve and/or fzero
options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);

%Some Constants:
g0 = 9.81; %m/s^2
G = 6.673e-11; %m^3/(kg*s^2)

%Using information from http://ssd.jpl.nasa.gov/?planet_phys_par:
earthMass = 5.97219e24; %Mass of earth -- kg
earthRadius = 6371e3; %mean radius of earth -- m
sunMass = 1.98855e30; %Mass of sun -- kg
marsMass = 6.41693e23; %Mass of Mars -- kg
marsRadius = 3389.5e3; %mean radius of mars -- m

%Orbital elements for Earth and Mars.
%Using info from: http://ssd.jpl.nasa.gov/txt/p_elem_t1.txt:
earthSemiMajor = auToMeter(1.00000261); %semimajor axis -- au
earthEccen = 0.01671123; %eccentricity
earthPeriLong = toRadians(102.93768193); %longitude of periapsis (rad) for Earth;

marsSemiMajor = auToMeter(1.52371034); %semimajor axis -- au
marsEccen = 0.09339410; %eccentricity
marsPeriLong = toRadians(-23.94362959 + 360); %longitude of periapsis (rad) for Mars;


%semilatus rectum for Earth and Mars
alphaE = semiLatus(earthSemiMajor, earthEccen);
alphaM = semiLatus(marsSemiMajor, marsEccen);

%Periapsis for Mars and Earth
marsPeriapsis = datenum(2014,12,12); 
earthPeriapsis = datenum(2015,1,4);
currentDay = earthPeriapsis;
%Integrate for Mars to find true anomaly on January 4th -- then we'll have the same time for both.
periTimeDiff = (earthPeriapsis - marsPeriapsis)*24*3600;

%True anomalies on January 4th, 2015:
TAE_i = 0; %At periapsis for Earth.
%Find Mars location for the instant that Earth is at periapsis (happens after Mars):
[TAM_i,f,info] = fsolve( @(theta_2) periTimeDiff - time_integral(G*sunMass,alphaM,marsEccen,0,0,theta_2), 0.2, options);
info

%True longitudes (angle from vernal equinox) at epoch:
thetaE_i = TAE_i + earthPeriLong;
thetaM_i = TAM_i + marsPeriLong;

theta = linspace(0,2*pi,1000);
rE = @(th) meterToAu(alphaE./(1+earthEccen*cos(th-earthPeriLong)));
rM = @(th) meterToAu(alphaM./(1+marsEccen*cos(th-marsPeriLong)));

figure(1,'visible','off')
	plot(rE(theta).*cos(theta),rE(theta).*sin(theta),'k-',rM(theta).*cos(theta),rM(theta).*sin(theta),'b-',0,0,'k.',...
	  rE(thetaE_i)*cos(thetaE_i),rE(thetaE_i)*sin(thetaE_i),'ko',rM(thetaM_i)*cos(thetaM_i),rM(thetaM_i)*sin(thetaM_i),'bo');
	title('Earth and Mars Orbits (Heliocentric)');
	axis('equal');
	xlabel('x (au) - aligned with vernal equinox');
	ylabel('y (au)');
	legend('Earth Orbit','Mars Orbit','Sun Location','Initial Earth Location','Initial Mars Location');
	print("out1.pdf")

current_burn = 1; %Integer counter for the current burn number.

%Burn #1 -- Hyperbolic burn to leave LEO from 200km altitude orbit and Transfer to Mars:
Rad_LEO = 185e3 + earthRadius; %Radius of the initial Earth orbit.

%Part 1 -- Transfer orbit from Earth to Mars (heliocentric).
%Find the best departure date: consider travel time and fuel requirements

%Choose departure and arrival true longitudes (relative to vernal equinox):
theta_d = thetaE_i + pi;     %Wait about 6 months -- may want to adjust
theta_a = theta_d + 1.3*pi;  %May want to adjust

periTimeDiff_seconds = time_integral(G*sunMass,alphaE,earthEccen,earthPeriLong,thetaE_i,theta_d);
currentDay = currentDay + periTimeDiff_seconds/(3600*24); %Find departure time from LEO
leoDeparture = datestr(currentDay)
%Find location of Mars at that time:
[thetaM_T_departs,f,info] = fsolve(@(thet) (periTimeDiff_seconds - time_integral(G*sunMass,alphaM,marsEccen,marsPeriLong,thetaM_i,thet)), 0.1, options); 
info

%Eccentricity and semilatus rectum for the transfer arc:
eT_toMars = @(oT) (rM(theta_a)-rE(theta_d))./(rE(theta_d).*cos(theta_d-oT) - rM(theta_a).*cos(theta_a-oT));
alphaT_toMars = @(oT) auToMeter(rE(theta_d).*(eT_toMars(oT).*cos(theta_d-oT) + 1));

%Need to use time to find omega_T (oT). The right-hand side (only based on Earth and Mars orbits):
RHS = time_integral(G*sunMass,alphaM,marsEccen,marsPeriLong,thetaM_i,theta_a) - time_integral(G*sunMass,alphaE,earthEccen,earthPeriLong,thetaE_i,theta_d);
periTimeDiff_Transfer_days = RHS/(24*3600) %Total travel time on the transfer arc
%Transcendental equation for oT:
periTimeDiff_function = @(oT) (time_integral(G*sunMass,alphaT_toMars(oT),eT_toMars(oT),oT,theta_d,theta_a) - RHS);

figure(2,'visible','off')
	vec = linspace(0,pi,100);
	plot(vec,periTimeDiff_function(vec));
	xlabel('oT');
	ylabel('Delta T Function (want zero)');
	axis([0, pi, -2e7, 1e8])
	print("out2.pdf")

guess(1) = input('Enter a lower bound on the value of oT: ');
guess(2) = input('Enter an upper bound on the value of oT: ');

%guess = [1.25,1.5]

[oT,f,info] = fzero(periTimeDiff_function,guess,options);
info

%The radius of the transfer arc in au:
rT = @(theta) meterToAu(alphaT_toMars(oT)./(1 + eT_toMars(oT).*cos(theta - oT)));

%Part 2 -- plan hyperbolic escape:
%required velocity as r -> infinity from hyperbolic escape
vinf_vec = v_vector_difference(alphaE,alphaT_toMars(oT),earthEccen,eT_toMars(oT),earthPeriLong,oT,G*sunMass,theta_d);
vinf = sqrt( vinf_vec(1)^2 + vinf_vec(2)^2 );
delta_v(current_burn) = sqrt(2*G*earthMass/Rad_LEO + vinf^2) - sqrt(G*earthMass/Rad_LEO); %Req'd delta_v
current_burn = current_burn + 1;

%Transfer to Mars:
figure(3,'visible','off')
	tE = linspace(0,2*pi,100); %Show full revolution for Earth
	tM = linspace(thetaM_T_departs,theta_a,100);
	tT = linspace(theta_d,theta_a,1000);
	plot(rE(tE).*cos(tE),rE(tE).*sin(tE),'k-',...
	     rM(tM).*cos(tM),rM(tM).*sin(tM),'b-',0,0,'k.',...
	     rT(tT).*cos(tT),rT(tT).*sin(tT),'k-.',...
	     rE(theta_d)*cos(theta_d),rE(theta_d)*sin(theta_d),'ko',...
	     rM(theta_a)*cos(theta_a),rM(theta_a)*sin(theta_a),'bo');
	title('Earth to Mars Transfer (Heliocentric)');
	axis('equal'); xlabel('x (au) - aligned with vernal equinox'); ylabel('y (au)');
	legend('Earth Orbit','Mars Orbit','Sun Location','Transfer Orbit','Departure Location','Arrival Location',...
	'Location','southwest'); %This last part places the legend in the lower left corner of the plot.
	print("out3.pdf")

%Burn #3 to transfer to LMO from Hyperbolic Approach -- Radius = 1.2*marsRadius
Rad_LMO = 1.2*marsRadius; %m -- chosen height for LMO
vinf_vec = v_vector_difference(alphaT_toMars(oT),alphaM,eT_toMars(oT),marsEccen,oT,marsPeriLong,G*sunMass,theta_a);
vinf = sqrt(vinf_vec(1)^2 + vinf_vec(2)^2);

delta_v(current_burn++) = sqrt(2*G*marsMass/Rad_LMO + vinf^2) - sqrt(G*marsMass/Rad_LMO);

currentDay += periTimeDiff_Transfer_days;
marsArrival = datestr(currentDay) %Output the date and time for mars arrival

%Mass Estimates for LMO:
massInital = 25800; %kg -- the amount one Delta IV Heavy can get into an orbit at 185km altitude

Isp = 462; % RL10B-2 engine Isp -- pretty good!
Mratio = exp(-sum(delta_v)/(Isp*g0));
massPayloadToMars = massInital*Mratio; %kg

totalDays = dayDifference(leoDeparture, marsArrival);
totalYears = totalDays/365;
integerYears = cast(totalYears,'int16');
integerDays = cast(mod(totalDays,365),'int16');
integerSeconds = cast(mod(totalDays,365*24*3600),'int16');

totalTravelTime = strcat(num2str(integerYears),' years,  ',num2str(integerDays),' days')

massPayloadToMarsString = strcat(num2str(massPayloadToMars),' kg')
Reqd_Mass = requiredMass(3,totalDays)
%Hmmm..... Going to need a lower delta_v / more mass in LEO at the beginning.
