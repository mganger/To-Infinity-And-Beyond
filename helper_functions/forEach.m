%for each number in a range, run the function
function a = forEach(first, last, step, func)
	while(first != last)
		func(first);
		first += step;
	end
end
