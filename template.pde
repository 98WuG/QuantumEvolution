int xspacing;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

double theta = 0.0;  // Start angle at 0
double amplitude = 75.0;  // Height of wave
double period = 500.0;  // How many pixels before the wave repeats
double dx;  // Value for incrementing X, a function of period and xspacing
double[] yvalues;  // Using an array to store height values for the wave

int amount=100;
int length=10;

void setup() {
	size(640, 360);
	w = width+16;
	xspacing=w/amount;
	dx = (TWO_PI / period) * xspacing;
	yvalues = new double[w/xspacing];
	frameRate(30);
}

void draw() {
	background(0);
	calcWave();
	renderWave();
}

void calcWave() {
	// Increment theta (try different values for 'angular velocity' here
	theta += 0.01;

	// For every x value, calculate a y value with sine function
	double x = theta;
	for (int i = 0; i < yvalues.length; i++) {
		yvalues[i] = Math.sin(x)*amplitude;
		x+=dx;
	}
}



void renderWave() {
	noStroke();
	fill(255);
	// A simple way to draw the wave with an ellipse at each location
	for (int x = 0; x < yvalues.length; x++) {
		ellipse((float) x*xspacing, (float) (height/2+yvalues[x]), (float) 16, (float) 16);
	}
}
