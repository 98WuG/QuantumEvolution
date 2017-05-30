int numIndex=1000;
double interval=2*Math.PI;
double timestep=0.05;
double latSpace;
Phi[] phis = new Phi[numIndex];
int counter;

void setup()
{
	size(2000, 1500);
	latSpace = (double) width / (double) numIndex;
	for(int i = 0; i < numIndex; i++)
	{
		double x = findCoordinate(i);

		double value = Math.sin(x);
		double prime = Math.cos(x);

		phis[i] = new Phi(value,prime);
		println(i + ": Value: " + value + ", Prime: " + prime);
	}
	phis[0] = new Phi(0,0);
	phis[numIndex - 1] = new Phi(0,0);
	counter = 0;
	frameRate(1000);
}

void draw()
{
	background(0);
	timeEvolve();
	counter++;
	textSize(30);
	fill(255);
	text("Timestep " + counter + "\nActual Time: " + counter * timestep, 12, 60);

	render();
}

void timeEvolve()
{
	/*
	Phi[] temphalf = new Phi[numIndex];

	for(int i = 1; i < numIndex - 1; i++)
	{
		temphalf[i] = phis[i].evolve(phis[i-1],phis[i+1],(double)1/(double)2);
	}
	temphalf[0] = new Phi(0,0);
	temphalf[numIndex - 1] = new Phi(0,0);
	for(int i = 1; i < numIndex - 1; i++)
	{
		phis[i] = phis[i].evolve(temphalf[i-1],temphalf[i+1],(double)1);
	}
	*/
	Phi[] temp = new Phi[numIndex];

	for(int i = 0; i < numIndex; i++)
	{
		temp[i] = phis[i];
	}
	for(int i = 1; i < numIndex - 1; i++)
	{
		phis[i] = temp[i].evolve(temp[i-1],temp[i+1],(double)1);
	}
}

double findCoordinate(int i)
{
	i = i - numIndex / 2;
	return (double) i * (double) interval / (double) numIndex;
}

float findDisplayX(int index)
{
	return (float) index * (float) latSpace;
}

float findDisplayY(double y)
{
	return (float)(height / 2) - 20 * (float) y;
}

void render()
{
	noStroke();

	for(int i = 0; i < numIndex; i++)
	{
		//Access the x and y coordinates of the each state
		double x = findCoordinate(i);
		double y = phis[i].getValue();
		double prime = phis[i].getPrime();

		fill(255,0,0);
		ellipse(findDisplayX(i), findDisplayY(y), 8, 8);
		fill(0,255,0);
		ellipse(findDisplayX(i), findDisplayY(prime), 8, 8);
	}
}

class Phi
{
	double value;
	double prime;

	Phi(double value, double prime)
	{
		this.value = value;
		this.prime = prime;
	}

	double spaceDerivative(Phi left, Phi right)
	{
		double temp = 2 * this.value - right.getValue() - left.getValue();
		return temp;
	}

	Phi evolve(Phi left, Phi right, double frac)
	{
		double phiDoubleX = spaceDerivative(left,right);
		double newValue = this.value + frac * timestep * this.prime;
		double newPrime = this.prime + frac * timestep * phiDoubleX;
		return new Phi(newValue,newPrime);
	}

	//get-setters
	double getValue()
	{
		return value;
	}
	double getPrime()
	{
		return prime;
	}
	void setValue(double value)
	{
		this.value = value;
	}
	void setPrime(double prime)
	{
		this.prime = prime;
	}

	String toString()
	{
		return "" + value + "," + prime;
	}
}
