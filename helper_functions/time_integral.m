function delta_t = time_integral(GM,alpha,epsilon,omega,theta1,theta2)
%Uses function "quad" to take the integral for the delta_t between two "true longitudes"
%i.e., thetas are angles from the reference direction
%--------------------------------
%Variables are as follows:
% GM -- gravitational constant * Mass of body being orbited
% alpha -- semimajor axis
% epsilon -- eccentricity
% omega -- longitude of periapsis (angle between periapsis and the vernal equinox)
% theta -- true longitude at epoch (i.e., angle relative to the vernal equinox at the burn time)
%--------------------------------

if( length(alpha) ~= length(epsilon) || length(epsilon) ~= length(omega) )

  error('Time Integral Error: the lengths of the alpha, epsilon, and omega vectors need to be the same.');

else

  %delta_t = zeros(length(alpha));

  for i = 1:length(alpha)
	delta_t(1,i) = alpha(i)^(3/2)/sqrt(GM)* (timeInt(theta2-omega(i), epsilon(i))-timeInt(theta1-omega(i), epsilon(i)));;;;
  end

end
