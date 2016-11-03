#!bin/bash

#batctl s Daemon collecting originator connections over time
#
#Usage:
#	sudo bash batctl_o_conn.sh $1=minutes to run
startDate=$(date +%F)
startTime=$(date +%T)
totalSeconds=$(($1 * 60))

echo "Collecting batctl originator connections to auditor for $totalSeconds seconds" 

TOP=$(pwd)
DataDumpDir="../TestOutput/Bat_O_Conn/OC_$startDate/"
DataDumpFile="OC_$startDate[From_$startTime][For_$1_minute(s)].txt"

if [ ! -d $DataDumpDir ]; then
mkdir -p $DataDumpDir
fi

cd $DataDumpDir

separator="==================================================="
echo $separator > $DataDumpFile
echo "| BATMAN ORIGINATOR CONNECTIONS LOG BEGIN $startDate//$startTime |" >> $DataDumpFile
echo $separator >> $DataDumpFile

for i in `seq 1 $totalSeconds` ; do
#Jsonified output

echo "{ Timestamp:$(date +%F_%T)," >> $DataDumpFile
 sudo batctl o -H | awk '{print "{ Node:"$1", Delay:"$2", Strength:"$3" }" }' >> $DataDumpFile
echo "}" >>$DataDumpFile

sleep 1

done

endDate=$(date +%F)
endTime=$(date +%T)

echo $separator>>$DataDumpFile
echo "| BATMAN ORIGINATOR CONNECTIONS LOG STOP $endDate//$endTime |" >>$DataDumpFile
echo $separator>>$DataDumpFile
