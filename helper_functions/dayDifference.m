function days = dayDifference(departure, arrival)
	days = datenum(arrival) - datenum(departure);
