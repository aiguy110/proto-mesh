#!bin/bash

#batctl td Daemon collecting originator connections over time
#
#Usage:
#	sudo bash batctl_tcp_dump.sh $1=minutes to run
startDate=$(date +%F)
startTime=$(date +%T)
totalSeconds=$(($1 * 60))

echo "Collecting TCP dump for $totalSeconds seconds" 

TOP=$(pwd)
DataDumpDir="../TestOutput/Bat_TCP_Dump/TD_$startDate/"
DataDumpFile="TD_$startDate[From_$startTime][For_$1_minute(s)].txt"

if [ ! -d $DataDumpDir ]; then
mkdir -p $DataDumpDir
fi

cd $DataDumpDir

separator="==================================================="
echo $separator > $DataDumpFile
echo "| BATMAN TCP DUMP CONNECTIONS LOG BEGIN $startDate//$startTime |" >> $DataDumpFile
echo $separator >> $DataDumpFile


sudo timeout $totalSeconds batctl td bat0 | awk '{print "{ "$0" }" }' >> $DataDumpFile

endTime=$(date +%T)

echo $separator>>$DataDumpFile
echo "| BATMAN TCP DUMP LOG STOP $endDate//$endTime |" >>$DataDumpFile
echo $separator>>$DataDumpFile
