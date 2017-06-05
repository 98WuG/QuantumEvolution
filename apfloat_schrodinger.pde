int prec=32;
int numIndex=250;
int scale=50;
double interval=0.5;
double timestep=0.025;
double latSpace;
State[] states = new State[numIndex];
int counter;

void setup()
{
	size(2000, 1500);
	latSpace = (double) width / (double) numIndex;
	for(int i=0; i < numIndex; i++)
	{
		Apfloat a1 = new Apfloat(0.01, prec);
		Apfloat x = new Apfloat(findCoordinate(i), prec);
		Apfloat totalAmplitude = (new Apfloat(1)).divide(ApfloatMath.sqrt(ApfloatMath.sqrt(ApfloatMath.pi(prec)).multiply(aa1))).multiply(ApfloatMath.exp((ApfloatMath.pow(ax,2).divide((new Apfloat(2)).multiply(ApfloatMath.pow(aa1,2)))).negate())); // 1/sqrt(sqrt(pi)*a) * e^(-x^2/(2a^2))

		int n = 3;
		double k = (double) n * Math.PI / interval;

		/*
		double a = Math.sqrt(2 / interval) * Math.cos(k * x);
		double b = 0;
		*/

		Apfloat a = atotalAmplitude.multiply(ApfloatMath.cos((new Apfloat(2)).multiply(ApfloatMath.pi(prec)).multiply(ax).divide(new Apfloat(0.005,prec)));
		Apfloat b = atotalAmplitude.multiply(ApfloatMath.sin((new Apfloat(2)).multiply(ApfloatMath.pi(prec)).multiply(ax).divide(new Apfloat(0.005,prec)));

		/*
		double a = totalAmplitude * 1;
		double b = totalAmplitude * 0;
		*/

		states[i] = new State(a,b);
	}
	counter=0;
	frameRate(1000);
}

void draw()
{
	background(0);
	double prob=0;
	Apfloat aprob = new Apfloat(0);
	for(State current : states)
	{
		prob += Math.pow(current.getA(),2) + Math.pow(current.getB(),2);
	}
	for(State acurrent : astates)
	{
		aprob += ApfloatMath.pow(current.getA(),2).add(ApfloatMath.pow(current.getB(),2);
	}
	prob = prob / (double) numIndex * (double) interval;
	for(State current : states)
	{
		current.setA(current.getA() / Math.sqrt(prob));
		current.setB(current.getB() / Math.sqrt(prob));
	}
	timeEvolve();
	counter++;
	textSize(30);
	fill(255);
	text("Timestep " + counter + "\nActual Time: " + counter * timestep + "\nTotal probability: " + prob, 12, 60);

	render();
}

void timeEvolve()
{
	//Create a temporary array to store the current states for evolve
	State[] temp = new State[numIndex];
	State[] tempsix = new State[numIndex];
	State[] temp1 = new State[numIndex];
	State[] temp2 = new State[numIndex];
	State[] temphalf = new State[numIndex];
	for(int i=0; i < numIndex; i++)
	{
		temp[i]=states[i];
	}
	tempsix[0] = states[0];
	temp1[0] = states[0];
	temp2[0] = states[0];
	temphalf[0] = states[0];
	tempsix[numIndex-1] = states[numIndex-1];
	temp1[numIndex-1] = states[numIndex-1];
	temp2[numIndex-1] = states[numIndex-1];
	temphalf[numIndex-1] = states[numIndex-1];
	for(int i=1; i < numIndex-1; i++)
	{
		tempsix[i]=temp[i].evolve(temp[i-1],temp[i+1],(double)1/(double)6);
	}
	for(int i=1; i < numIndex-1; i++)
	{
		temp1[i]=states[i].evolve(tempsix[i-1],tempsix[i+1],(double)1/(double)3);
	}
	for(int i=1; i < numIndex-1; i++)
	{
		temp2[i]=states[i].evolve(temp1[i-1],temp1[i+1],(double)2/(double)3);
	}
	for(int i=1; i < numIndex-1; i++)
	{
		double halfA = ((double)1/(double)2) * (temp1[i].getA() + temp2[i].getA());
		double halfB = ((double)1/(double)2) * (temp1[i].getB() + temp2[i].getB());
		temphalf[i] = new State(halfA,halfB);
	}
	for(int i=1; i < numIndex-1; i++)
	{
		states[i]=states[i].evolve(temphalf[i-1],temphalf[i+1],(double)1);
	}
	/*
	temp[100].timeDerivativeTest(temp[99],temp[101]);
	println("Initial: " + temp[100] + "\n");
	*/
}

//Find the actual x-coordinate of an index i
double findCoordinate(int i)
{
	i = i - numIndex/2;
	return (double) i * (double) interval / (double) numIndex;
}

float findDisplayX(int index)
{
	return (float) index * (float) latSpace;
}

float findDisplayY(double y)
{
	return (float)(height/2) - scale*(float)y;
}

//Render the array of states
void render()
{
	noStroke();

	for(int i=0; i < numIndex; i++)
	{
		int size=8;
		//Access the x and y coordinates of each state
		double x = findCoordinate(i);
		double y = states[i].getA();
		double yb = states[i].getB();
		//Draw an ellipse at each x and y coordinate
		fill(255,0,0);
		ellipse(findDisplayX(i), findDisplayY(y), size, size);
		fill(0,255,0);
		ellipse(findDisplayX(i), findDisplayY(yb), size, size);
		double overall = Math.sqrt(Math.pow(y,2) + Math.pow(yb,2));
		fill(0,0,255);
		ellipse(findDisplayX(i), findDisplayY(overall), size, size);
	}
}


class State
{
	Apfloat a;
	Apfloat b;

	State(Apfloat a, Apfloat b)
	{
		this.a = a;
		this.b = b;
	}

	State timeDerivativeTest(State left, State right)
	{
		Apfloat newB = right.getA().add(left.getA()).subtract((new Apfloat(2)).multiply(this.a));
		Apfloat newA = ((new Apfloat(2)).multiply(this.b)).subtract(right.getB()).subtract(left.getB());
		println("Right A: " + right.getA() + ", Left A: " + left.getA() + ", This A: " + this.a);
		println("Right B: " + right.getB() + ", Left B: " + left.getB() + ", This B: " + this.b);
		println("New A: " + newA + ", New B: " + newB);
		return new State(newA,newB);
	}

	//Approximate a time derivate of this state in the lattice
	State timeDerivative(State left, State right)
	{
		Apfloat newB = right.getA().add(left.getA()).subtract((new Apfloat(2)).multiply(this.a));
		Apfloat newA = ((new Apfloat(2)).multiply(this.b)).subtract(right.getB()).subtract(left.getB());
		return new State(newA,newB);
	}

	//Use the timeDerivative() function to evolve forward in time by one time step
	State evolve(State left, State right, Apfloat frac)
	{
		State dt = timeDerivative(left,right);
		Apfloat tempA = (this.a).add(frac.multiply(timestep).multiply(dt.getA()));
		Bpfloat tempB = (this.b).add(frac.multiply(timestep).multiply(dt.getB()));
		return new State(tempA, tempB);
	}

	//get-setters
	Apfloat getA()
	{
		return a;
	}
	Apfloat getB()
	{
		return b;
	}
	void setA(Apfloat a)
	{
		this.a = a;
	}
	void setB(Apfloat b)
	{
		this.b = b;
	}

	String toString()
	{
		return "" + a + "," + b;
	}
}
