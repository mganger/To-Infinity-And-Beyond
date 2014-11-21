function delta_v=v_vector_difference(alphai,alphaf,epsi,epsf,oi,of,GM,theta)
%Calculates the delta_v between two orbits
%--------------------------------
%Variables are as follows:
% alpha -- semimajor axis
% eps -- eccentricity
% o -- longitude of periapsis
% GM -- G*Mass of body orbited
% theta -- true longitude at epoch (i.e., angle relative to the vernal equinox at the burn time)
%--------------------------------
%"i" indicates the initial orbit
%"f" indicates the final orbit

vi = sqrt(GM/alphai)*[ epsi*sin(theta-oi),(1+epsi*cos(theta-oi)) ]; % radial , theta components of initial velocity
vf = sqrt(GM/alphaf)*[ epsf*sin(theta-of),(1+epsf*cos(theta-of)) ]; % radial , theta components of initial velocity

delta_v = vf - vi;