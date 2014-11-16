function ret = hzero(func)
	options = optimset('TolFun',1e-8,'TolX',1e-15,'MaxIter',1000);
	for n = 0:300
		guess = [n/100,(n+1)/100];
		try
			[a,b,c] = fzero(func,guess,options);
			ret = a
			break
		catch
			if(n == 300) error('HZero Function: after 300 attempts, no root has been found');
			continue;
		end
	end
end
