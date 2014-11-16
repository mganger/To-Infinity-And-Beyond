function delta_t = numerical_integral(GM,alpha,epsilon,omega,theta1,theta2)

if( length(alpha) ~= length(epsilon) || length(epsilon) ~= length(omega) )

	error('Time Integral Error bad lengths and stuff you know');

else
	for i = 1:length(alpha)
		integrand = @(theta) (1 + epsilon(i)*cos(theta-omega(i)))^-2;
		delta_t(1,i) = alpha(i)^(3/2)/sqrt(GM)*quad(integrand,theta1,theta2,1e-10);
	end
end
end
