%Calculates the eccentricity of an orbit 
function eccen = transferEccen(omega,thetaA,thetaD)
	eccen = (rM(thetaA)-rE(thetaD))./(rE(thetaD).*cos(thetaD-omega) - rM(thetaA).*cos(thetaA-omega));
