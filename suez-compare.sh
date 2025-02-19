#!/bin/sh

# Compares current suez output to previous run
# Obviously needs suez: https://github.com/prusnak/suez
#
SUEZ_DIR="$HOME/suez"
STATUS_DIR='statuses'
stamp=`date '+%Y-%m-%d-%H%M%S'`

cd $SUEZ_DIR
/usr/bin/poetry run ./suez --show-chan-ids --client=c-lightning | awk 'BEGIN { FPAT = "([[:space:]]*[[:alnum:][:punct:][:digit:]]+)"; OFS = ""; } { $6=$7=$8=$9="";  print $0; }' >temp.status

# Compare two given status files and display result. Recent first
fn_compare() {
	sort -k 7 $1 >/tmp/suez.status.1
	sort -k 7 $2 >/tmp/suez.status.2
	result=`diff -w -U 0 /tmp/suez.status.2 /tmp/suez.status.1`
	echo "$result"
}

if [ -d $STATUS_DIR ];
then
	prev_status=`readlink -f $STATUS_DIR/latest.status`
	if [ -f $prev_status ];
	then
		echo "Comparing current to $prev_status"
		fn_compare temp.status $prev_status
	else
		prev_status=$STATUS_DIR/`ls -1t $STATUS_DIR | head -1`
		if [ -f $prev_status ];
		then
			echo "latest.status missing, will compare to $prev_status"
			fn_compare temp.status $prev_status			
		else
			echo "Empty $STATUS_DIR, nothing to compare, will populate"
		fi
	fi
else
	echo "Creating $STATUS_DIR"
	mkdir -p $STATUS_DIR
fi

echo "Creating $STATUS_DIR/$stamp.status"
mv temp.status $STATUS_DIR/$stamp.status
ln -fs ./$stamp.status $STATUS_DIR/latest.status

echo "All done."
