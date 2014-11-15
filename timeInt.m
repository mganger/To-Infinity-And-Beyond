function ret = timeInt(y,x)

	if(x == 1)
		ret = timeInt(y,1.0000000001);
		return
	end

	piCount = floor(y/pi);
	if(y/pi - piCount == 0 & y != pi)
		ret = timeInt(y+0.000001,x)
		return
	end

	first = x * sin(y) / ((x*x - 1)*(x*cos(y) + 1));
	inside = (x-1) * tan(y/2) / sqrt(x*x - 1);
	second = 2 * atanh(inside)/(x*x - 1).^(3/2.0);

	if(y == pi) ret = real(first - second);
	else ret = real( (first - second) ) + timeInt(pi,x).* 2 .*piCount - timeInt(pi,x).*2 .* floor(piCount/2);
	end
end
