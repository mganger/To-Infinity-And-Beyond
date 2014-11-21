%for each number in a range, run the function
%A simple wrapper for a loop. Never used in the code.
function a = forEach(first, last, step, func)
	while(first != last)
		func(first);
		first += step;
	end
end
