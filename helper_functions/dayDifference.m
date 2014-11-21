%Calculates the difference between two datenums. A simple wrapper for datenum functions
function days = dayDifference(departure, arrival)
	days = datenum(arrival) - datenum(departure);
