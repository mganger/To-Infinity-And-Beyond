function ret = hzero(func)
	options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
	for n = 0:300
		guess = [n/100,(n+1)/100];
		try
			[a,b,c] = fzero(func,guess,options);
			ret = a
			break
		catch
			outcome='try again...';
			guess;
			continue;
		end
	end

