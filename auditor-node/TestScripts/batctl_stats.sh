#!bin/bash

#batctl s Daemon collecting statistics over time
#
#Usage:
#	sudo bash batctl_stats.sh $1=minutes to run
startDate=$(date +%F)
startTime=$(date +%T)
totalSeconds=$(($1 * 60))

echo "Collecting batctl_stats.sh for $totalSeconds seconds" 

TOP=$(pwd)
DataDumpDir="../TestOutput/Bat_Stats/BS_$startDate/"
DataDumpFile="BS_$startDate[From_$startTime][For_$1_minute(s)].txt"

if [ ! -d $DataDumpDir ]; then
mkdir -p $DataDumpDir
fi

cd $DataDumpDir

separator="==================================================="
echo $separator > $DataDumpFile
echo "| BATMAN STATISTICS LOG BEGIN $startDate//$startTime |" >> $DataDumpFile
echo $separator >> $DataDumpFile


for i in `seq 1 $totalSeconds` ; do
#Jsonified output

echo "{Timestamp:$(date +%F_%T)," >> $DataDumpFile
sudo batctl s | awk '{ print $1 $2 }' | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' >> $DataDumpFile
echo "}" >>$DataDumpFile

sleep 1

done

endDate=$(date +%F)
endTime=$(date +%T)

echo $separator>>$DataDumpFile
echo "| BATMAN STATISTICS LOG STOP $endDate//$endTime |" >>$DataDumpFile
echo $separator>>$DataDumpFile
