%This function represents an analytical solution for the amount of time it takes
%a body in orbit to move between two angles. Because of the tangent function, it
%is cyclic and discontinuous. However, we can solve this problem through a few
%changes. First, the function is undefined for parabolic eccentricities. We can
%solve this problem by simply returning a time integral of a very slightly
%hyperbolic orbit. Second, the function is undefined at multiples of pi radians,
%so we must apply the same logic here. Finally, because the function is cyclic,
%we must manually sum the iterations (essentially adding the time period of the
%orbit)
function ret = timeInt(y,x)

	if(x == 1)
		ret = timeInt(y,1.0000000001);
		return
	end

	piCount = floor(y/pi);
	if(y/pi - piCount == 0 & y != pi)
		ret = timeInt(y+0.000001,x);
		return
	end

	first = x * sin(y) / ((x*x - 1)*(x*cos(y) + 1));
	inside = (x-1) * tan(y/2) / sqrt(x*x - 1);
	second = 2 * atanh(inside)/(x*x - 1).^(3/2.0);

	if(y == pi) ret = real(first - second);
	else ret = real( (first - second) ) + timeInt(pi,x).* 2 .*piCount - timeInt(pi,x).*2 .* floor(piCount/2);
	end
end
