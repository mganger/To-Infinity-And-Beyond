//this is an attempt to hash out an orbital "factory" pattern

class Orbit;
class OrbitFactory;
class Satellite;

class OrbitFactory {
	public:
		Orbit fromAlpha(double alpha, double epsilon, double omega){
			
		}
};


class Orbit {
	public:
		//for velocity and time calculations
		double bigG = 6.67e-11, centerMass, pi = 3.14159;


		//Geometry
		double semiLatus, eccentricity, offsetAngle;
		double semiMajor;



		double radius(angle);
		double apoapsis(){return radius(offsetAngle+pi);
		double periapsis(){return radius(offsetAngle);}

};

class Satellite {
	public:
		Orbit orbit;

		Satellite(Orbit inputOrbit) : orbit(inputOrbit) {}

		double velocity(double radius);
		double energy(double mass);
};

int main(){}
