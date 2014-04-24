#!/bin/sh

alert_key="ERROR"
#hostname=`hostname`

usage() {
  echo ""
  echo "Please argument"
  echo "\"sh log_checker.sh /var/log/nginx/access.log\""
  echo ""
}

alert(){
  while read i
  do
    echo $i | grep -i -q ${alert_key}
    if [ $? = "0" ]; then
      echo alert error
      echo alert >> hoge
#      zabbix_sender -z zabbix -p 10051 -s ${hostname} -k log.item -o 1 > /dev/null 2>&1
    fi
  done
}

if [ -z "$1" ]; then
  usage
  exit 0
fi

tail -F -n 0 $1 | alert
