%Finds the difference beteween the current position of Mars and it's equinox position
function ret = marsEquinox(currentDate)
	ret = angSolve(marsOrbit,0,currentDate*24*3600) - angSolve(marsOrbit,0,datenum(2013,7,13)*24*3600)
