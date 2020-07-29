#!/bin/sh

readonly LOGFILE="/tmp/fiware_DemandPower.sh.log"
readonly PROCNAME=fiware_DemandPower.sh
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$@" | tee -a ${LOGFILE}
}

dataCategory="DemandPower"

timeset=15
size=61
for j in `seq 0 $timeset`
do
tt=$(($j + 1))
starttime=`date --date "$tt hour ago" '+%Y-%m-%dT%H:%M:%S.000Z'`
endtime=`date --date "$j hour ago" '+%Y-%m-%dT%H:%M:%S.000Z'`

echo $starttime
echo $endtime
res=$(curl -s -X GET 'http://10.1.5.199:8666/STH/v1/contextEntities/type/SmartMeter/id/IIJECHONETtest/attributes/'$dataCatalog'?lastN='$size'&dateFrom='$starttime'&dateTo='$endtime'' -H 'fiware-service: openiot' -H 'fiware-servicepath: /' | jq)

for i in `seq 0 $size`
do
context=$(echo $res | jq -r '.contextResponses[0].contextElement')
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
