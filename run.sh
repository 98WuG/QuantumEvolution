#!/bin/bash


function ctrl_c() {
	echo "Detected user abort! Cleaning up files..."
	if [ -f "$program.pde" ]
	then
		rm "$program.pde"
		echo "Removed $program/$program.pde"
	fi
	exit 10
}
function run {
	cd "$1"
	cp "$2" "$1.pde"
	trap ctrl_c INT
	make
	rm "$1.pde"
	cd ..
	echo "Program finished, cleaning up"
}

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

SHORT=hpi
LONG=help,program,initial

# -temporarily store output to be able to check for errors
# -activate advanced mode getopt quoting e.g. via “--options”
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# use eval with "$PARSED" to properly handle the quoting
eval set -- "$PARSED"

usage="Usage:
$(basename "$0") [-h] [-p progname] [-i initstate] -- program to numerically compute evolutions of initial states to the schrodinger equation and wave equation

Options:
    -h, --help                show this help text
    -p, --program <progname>  specify which program to run (schrodinger,wave)
    -i, --initial <initstate> specify what initial state to evolve (eigenstate,gaussian,normal,mover)
	"
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            echo "$usage"
            exit
            ;;
        -p|--program)
            program="$4"
            shift
            ;;
        -i|--initial)
            initial="$4"
            shift
            ;;
		--)
			shift
			break
			;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ -z $program ]; then
	echo -e "Missing required flag: -p <progname>\n"
	echo "$usage"
	exit 4
fi
if [ -z $initial ]; then
	echo -e "Missing required flag: -i <initstate>\n"
	echo "$usage"
	exit 5
fi

echo -e "Program: $program, Initial Condition: $initial\n"

run "$program" "$initial"
