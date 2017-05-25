int numIndex=500;
double interval=0.5;
double timestep=0.1;
double latSpace;
double dx;
State[] states = new State[numIndex];
int counter;

void setup()
{
	size(1500, 900);
	latSpace = (double) width / (double) numIndex;
	dx = (double) interval / (double) numIndex;
	for(int i=0; i < numIndex; i++)
	{
		double x = findCoordinate(i);
		double a1 = 0.01;
		double totalAmplitude = (double) 1 / Math.sqrt(Math.sqrt(Math.PI) * a1) * Math.exp(0 - Math.pow(x,2) / (2 * Math.pow(a1,2)));
		
		double a = totalAmplitude * Math.cos((x-1000)*1000);
		double b = totalAmplitude * Math.sin((x-1000)*1000);
		/*
		double a = totalAmplitude * 1;
		double b = totalAmplitude * 0;
		*/
		//println("a: " + a);
		states[i] = new State(a,b);
	}
	counter=0;
	frameRate(6000);
}

void draw()
{
	background(0);
	timeEvolve();
	double prob=0;
	for(State current : states)
	{
		prob += Math.pow(current.getA(),2) + Math.pow(current.getB(),2);
	}
	prob = prob / (double) numIndex * (double) interval;
	counter++;
	textSize(30);
	fill(255);
	text("Timestep " + counter + "\nTotal probability: " + prob, 12, 60);
		
	render();
}

void timeEvolve()
{
	//Create a temporary array to store the current states for evolve
	State[] temp = new State[numIndex];
	for(int i=0; i < numIndex; i++)
	{
		temp[i]=states[i];
	}

	for(int i=1; i < numIndex-1; i++)
	{
		states[i]=temp[i].evolve(temp[i-1],temp[i+1]);
	}
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
	return (float)(height/2) - 20*(float)y;
}

//Render the array of states
void render()
{
	noStroke();
	
	for(int i=0; i < numIndex; i++)
	{
		//Access the x and y coordinates of each state
		double x = findCoordinate(i);
		double y = states[i].getA();
		double yb = states[i].getB();
		//Draw an ellipse at each x and y coordinate
		fill(255,0,0);
		ellipse(findDisplayX(i), findDisplayY(y), 8, 8);
		fill(0,255,0);
		ellipse(findDisplayX(i), findDisplayY(yb), 8, 8);
		double overall = Math.pow(y,2) + Math.pow(yb,2);
		fill(0,0,255);
		ellipse(findDisplayX(i), findDisplayY(overall), 8, 8);
	}
}


class State
{
	double a;
	double b;

	State(double a, double b)
	{
		this.a = a;
		this.b = b;
	}

	//Approximate a time derivate of this state in the lattice
	State timeDerivative(State left, State right)
	{
		double newB = right.getA() + left.getA() - 2*this.a;
		double newA = 2*this.b - right.getB() - left.getB();

		return new State(newA,newB);
	}

	//Use the timeDerivative() function to evolve forward in time by one time step
	State evolve(State left, State right)
	{
		State dt = timeDerivative(left,right);
		double tempA = this.a + timestep * dt.getA();
		double tempB = this.b + timestep * dt.getB();
		return new State(tempA, tempB);
	}
	
	//get-setters
	double getA()
	{
		return a;
	}
	double getB()
	{
		return b;
	}
	void setA(double a)
	{
		this.a = a;
	}
	void setB(double b)
	{
		this.b = b;
	}

	String toString()
	{
		return "" + a + "," + b;
	}
}
