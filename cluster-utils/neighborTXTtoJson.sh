#/!bin/bash

cd $1

OUTDIR="JsonOutput"
mkdir -p $OUTDIR

cd $OUTDIR

ONE=1
TWO=2

for file in ../neighbors*; do
	WriteTo="$file.json"
	node=$(head -n 1 $file)
	echo "{ 'NODE' : $node ," > $WriteTo
	echo " 'NEIGHBORS' : { " >> $WriteTo
	lines=$(wc -l file | awk '{print $1}')
	lines=$((lines-TWO))
	minus1=$((lines-ONE))
	echo "lines $minus1"
	for n in {3..$minus1}; do
		MAC=$(sed "${n}q;d" $file)
		echo "{'NEIGHBOR' : $MAC }," >> $WriteTo
	done

	LAST=$(sed "${lines}q;d" $file)
	echo "{ 'NEIGHBOR' : $LAST }" >> $WriteTo
	echo "		}" >> $WriteTo
	echo "}" >>$WriteTo
done

