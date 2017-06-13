# Evolution Schemes

## How to run

First, try to run the ```run.sh``` script.

```
Usage:
    run.sh [-h] [-p progname] [-i initstate] -- program to numerically compute evolutions of initial states to the schrodinger equation and wave equation

Options:
    -h, --help                show this help text
    -p, --program <progname>  specify which program to run (schrodinger,wave)
    -i, --initial <initstate> specify what initial state to evolve (eigenstate,gaussian,normal,mover)
```

For example, if I want to see the gaussian wave packet for the Schrodinger equation, I'd run ```./run.sh -p schrodinger -i gaussian```.

If the ```run.sh``` script doesn't work, fallback to the ```compat_run.sh``` script. Run this with ```./compat_run.sh```.

This script will prompt you each time for what you'd like to run. This is less efficient but is POSIX compliant.
