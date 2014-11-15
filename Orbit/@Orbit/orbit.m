classdef Orbit
	properties(GetAccess = public, SetAccess = public)
		semiMajor;
		refAngle;
		eccentricity;
		centerMass;

		massName;

		bigG = 6.67384e-11;
	end


	methods(Access = public)
		%Semi-Latus rectum
		function a = semiLatus()
			a = obj.semiMajor*(1-obj.eccentricity.^2)
		end
		%Specific Angular Momentum
		function s = specAngMom()
			s = sqrt(obj.semiLatus() * obj.bigG * obj.centerMass)
		end


		%Orbital period
		function p = period()
			p = 2*pi*obj.semiMajor.^(3/2.0) / (sqrt(obj.bigG*obj.centerMass));
		end
		%Orbit time difference between two points
		function t = timeDiff(angleInit, angleFinal)
			p = obj.semiMajor.^(3/2.0) / (sqrt(obj.bigG*obj.centerMass)) * (timeInt(angleFinal, obj.eccentricity) - timeInt(angleInit,obj.eccentricity));
		end

		%radius as a function of angle
		function r = radiusAbs(angle)
			r = obj.semiLatus() / (1 + obj.eccentricity*cos(angle-obj.refAngle));
		end
		function r = radiusRel(angle)
			r = obj.semiLatus() / (1 + obj.eccentricity*cos(angle));
		end


		%angle as a function of radius
		function a = angleAbs(radius)
			a = acos( (obj.semiLatus() - obj.radius) / (obj.radius * obj.eccentricity));
		end
		function a = angleRel(radius)
			a = obj.angleAbs(radius) + obj.refAngle
		end


		%angluar speed at a given radius
		function w = angularSpeed(radius)
			w = obj.specAngMom() / (radius*radius)
		end
		%Speed as a function of radius
		function v = speed(radius)
			v = sqrt(2*obj.bigG*obj.centerMass * ( 1/radius - 1/(2*semiMajor)));
		end
		%velocity vector in polar coordinates (absolute angle)
		function v = velocity(angle)
			tmp = sqrt(obj.bigG * obj.centerMass / obj.semiLatus() );
			v(1) = tmp * obj.eccentricity * sin(angle)
			v(2) = tmp * (1 + obj.eccentricity * cos(angle))
		end
	end
end
