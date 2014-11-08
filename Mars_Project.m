%Dr. Kurt Aikens, November 2014 
%Preliminary Earth-Mars Transfer Calculations
%Mechanics I
clear all; clc; close all; format long eng; more off; 
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
m_by_au = 149597870700; %m/au, exactly
au_by_m = 1/m_by_au;    %au/m

deg_by_rad = 180/pi;
rad_by_deg = 1/deg_by_rad;

G = 6.673e-11; %m^3/(kg*s^2)
%Using information from http://ssd.jpl.nasa.gov/?planet_phys_par:
ME = 5.97219e24; %Mass of earth -- kg
Rad_E = 6371e3; %mean radius of earth -- m
MS = 1.98855e30; %Mass of sun -- kg
MM = 6.41693e23; %Mass of Mars -- kg
Rad_M = 3389.5e3; %mean radius of mars -- m

%Orbital elements for Earth and Mars.
%Using info from: http://ssd.jpl.nasa.gov/txt/p_elem_t1.txt:
aE = 1.00000261; %semimajor axis -- au
eE = 0.01671123; %eccentricity
oE = 102.93768193*rad_by_deg; %longitude of periapsis (rad) for Earth;
aM = 1.52371034; %semimajor axis -- au
eM = 0.09339410; %eccentricity
oM = (-23.94362959 + 360)*rad_by_deg; %longitude of periapsis (rad) for Mars;

aE = aE*m_by_au; %Now everything is in meters
aM = aM*m_by_au;

alphaE = aE / (1-eE^2); %semilatus rectum for Earth
alphaM = aM / (1-eM^2); %semilatus rectum for Mars

%Periapsis for Mars: December 12th, 2014
mars_periapsis = datenum(2014,12,12); 
%Periapsis for Earth: January 4th, 2015
earth_periapsis = datenum(2015,1,4);
current_day = earth_periapsis;
%Integrate for Mars to find true anomaly on January 4th -- then we'll have the same time for both.
delta_t = (earth_periapsis-mars_periapsis)*24*3600; %seconds

%True anomalies on January 4th, 2015:
TAE_i = 0; %At periapsis for Earth.
%Find Mars location for the instant that Earth is at periapsis (happens after Mars):
[TAM_i,f,info] = fsolve( @(theta_2) delta_t - time_integral(G*MS,alphaM,eM,0,0,theta_2), 0.2, options);
info

%True longitudes (angle from vernal equinox) at epoch:
thetaE_i = TAE_i + oE;
thetaM_i = TAM_i + oM;

theta = linspace(0,2*pi,1000);
rE = @(th) au_by_m*alphaE./(1+eE*cos(th-oE)); %Radius of Earth in au (for plotting)
rM = @(th) au_by_m*alphaM./(1+eM*cos(th-oM)); %Radius of Mars in au

figure(1)
plot(rE(theta).*cos(theta),rE(theta).*sin(theta),'k-',rM(theta).*cos(theta),rM(theta).*sin(theta),'b-',0,0,'k.',...
  rE(thetaE_i)*cos(thetaE_i),rE(thetaE_i)*sin(thetaE_i),'ko',rM(thetaM_i)*cos(thetaM_i),rM(thetaM_i)*sin(thetaM_i),'bo');
title('Earth and Mars Orbits (Heliocentric)');
axis('equal');
xlabel('x (au) - aligned with vernal equinox');
ylabel('y (au)');
legend('Earth Orbit','Mars Orbit','Sun Location','Initial Earth Location','Initial Mars Location');

current_burn = 1; %Integer counter for the current burn number.

%Burn #1 -- Hyperbolic burn to leave LEO from 200km altitude orbit and Transfer to Mars:
Rad_LEO = 185e3 + Rad_E; %Radius of the initial Earth orbit.

%Part 1 -- Transfer orbit from Earth to Mars (heliocentric).
%Find the best departure date: consider travel time and fuel requirements

%Choose departure and arrival true longitudes (relative to vernal equinox):
theta_d = thetaE_i + pi;     %Wait about 6 months -- may want to adjust
theta_a = theta_d + 1.95*pi;  %May want to adjust

delta_t_seconds = time_integral(G*MS,alphaE,eE,oE,thetaE_i,theta_d);
current_day = current_day + delta_t_seconds/(3600*24); %Find departure time from LEO
leave_LEO = datestr(current_day)
%Find location of Mars at that time:
[thetaM_T_departs,f,info] = fsolve(@(thet) (delta_t_seconds - time_integral(G*MS,alphaM,eM,oM,thetaM_i,thet)), 0.1, options); 
info

%Eccentricity and semilatus rectum for the transfer arc:
eT_toMars = @(oT) (rM(theta_a)-rE(theta_d))./(rE(theta_d).*cos(theta_d-oT) - rM(theta_a).*cos(theta_a-oT));
alphaT_toMars = @(oT) m_by_au*rE(theta_d).*(eT_toMars(oT).*cos(theta_d-oT) + 1);

%Need to use time to find omega_T (oT). The right-hand side (only based on Earth and Mars orbits):
RHS = time_integral(G*MS,alphaM,eM,oM,thetaM_i,theta_a) - time_integral(G*MS,alphaE,eE,oE,thetaE_i,theta_d);
delta_t_Transfer_days = RHS/(24*3600) %Total travel time on the transfer arc
%Transcendental equation for oT:
delta_t_function = @(oT) (time_integral(G*MS,alphaT_toMars(oT),eT_toMars(oT),oT,theta_d,theta_a) - RHS);

figure(2)
vec = linspace(0,pi,100);
plot(vec,delta_t_function(vec));
xlabel('oT'); ylabel('Delta T Function (want zero)');
axis([0, pi, -2e7, 1e8])

guess(1) = input('Enter a lower bound on the value of oT: ');
guess(2) = input('Enter an upper bound on the value of oT: ');

[oT,f,info] = fzero(delta_t_function,guess,options);
info

%The radius of the transfer arc in au:
rT = @(theta) au_by_m*alphaT_toMars(oT)./(1 + eT_toMars(oT).*cos(theta - oT));

%Part 2 -- plan hyperbolic escape:
%required velocity as r -> infinity from hyperbolic escape
vinf_vec = v_vector_difference(alphaE,alphaT_toMars(oT),eE,eT_toMars(oT),oE,oT,G*MS,theta_d);
vinf = sqrt( vinf_vec(1)^2 + vinf_vec(2)^2 );
delta_v(current_burn) = sqrt(2*G*ME/Rad_LEO + vinf^2) - sqrt(G*ME/Rad_LEO); %Req'd delta_v
current_burn = current_burn + 1;

%Transfer to Mars:
figure(3)
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

%Burn #3 to transfer to LMO from Hyperbolic Approach -- Radius = 1.2*Rad_M
Rad_LMO = 1.2*Rad_M; %m -- chosen height for LMO
vinf_vec = v_vector_difference(alphaT_toMars(oT),alphaM,eT_toMars(oT),eM,oT,oM,G*MS,theta_a);
vinf = sqrt(vinf_vec(1)^2 + vinf_vec(2)^2);

delta_v(current_burn) = sqrt(2*G*MM/Rad_LMO + vinf^2) - sqrt(G*MM/Rad_LMO);
current_burn = current_burn + 1;

current_day = current_day + delta_t_Transfer_days;
mars_arrival = datestr(current_day) %Output the date and time for mars arrival

%Mass Estimates for LMO:
mass_initial = 25800; %kg -- the amount one Delta IV Heavy can get into an orbit at 185km altitude

Isp = 462; % RL10B-2 engine Isp -- pretty good!
Mratio = exp(-sum(delta_v)/(Isp*g0));
Mass_Payload_to_Mars = mass_initial*Mratio; %kg

total_days = datenum(mars_arrival) - datenum(leave_LEO);

%Assume that 1.4 pounds of food needed per day, 7 pounds of water, and 2 pounds of oxygen, for 3 people.
food_H20_O2_mass = total_days*3*(1.4 + 7 + 2)*0.45359237;
astronauts_mass = 3*150*0.45349237; %150 pounds per person (?)

Mass_Payload_to_Mars
Reqd_Mass = food_H20_O2_mass + astronauts_mass
%Hmmm..... Going to need a lower delta_v / more mass in LEO at the beginning.