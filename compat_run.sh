#!/bin/bash --posix


function ctrl_c() {
	echo "Detected user abort! Cleaning up files..."
	if [ -f "$program.pde" ]
	then
		rm -v "$program.pde"
	fi
	exit 10
}
function run {
	cd "$1"
	if ! [ -f "$2" ]
	then
		echo -e "$2 not found!\nAborting..."
		exit 2
	fi
	cp "$2" "$1.pde"
	trap ctrl_c INT
	make
	rm "$1.pde"
	cd ..
	echo "Program finished, cleaning up"
}

echo -n "Which program would you like to run? [schrodinger,wave] "
read program
if [[ "$program" == "schrodinger" ]];
then
	echo -n "Which initial condition? [eigenstate,gaussian] "
	read initial
	run $program $initial
elif [[ "$program" == "wave" ]];
then
	echo -n "Which initial condition? [normal,mover] "
	read initial
	run $program $initial
else
	echo -e "Error, invalid program\nAborting..."
	exit 1
fi
