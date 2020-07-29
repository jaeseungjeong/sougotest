#!/bin/sh

readonly LOGFILE="/tmp/fiware_ActivePower.sh.log"
readonly PROCNAME=fiware_ActivePower.sh
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$@" | tee -a ${LOGFILE}
}

timeset=15
size=61
for j in `seq 0 $timeset`
do
tt=$(($j + 1))
starttime=`date --date "$tt hour ago" '+%Y-%m-%dT%H:%M:%S.000Z'`
endtime=`date --date "$j hour ago" '+%Y-%m-%dT%H:%M:%S.000Z'`

echo $starttime
echo $endtime

for i in `seq 0 $size`
do
context=$(jq -r '.contextResponses[0].contextElement' test16.json)
value=$(echo $context | jq -r '.attributes[0].values['$i'].attrValue')
asset=$(echo $context | jq '.id')
DataCategory=$(echo $context | jq '.attributes[0].name')
measured_at=$(echo $value | jq '.data[0].measured_at')
missing=$(echo $value | jq '.data[0].missing')
value=$(echo $value | jq '.data[0].value')
if [ $value != null ]; then
  echo $asset,$asset,$DataCategory,$measured_at,$missing,$value
  log $asset,$asset,$DataCategory,$measured_at,$missing,$value
fi
done
done
