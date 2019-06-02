#!/bin/bash

# Installation script for MyTAP

SQLHOST='localhost';
SQLPORT=3306;
SQLSOCK=''
FILTER=0
DB='tap'

while [[ "$#" > 0 ]]; do
    case $1 in
	-u|--user)
	    SQLUSER="$2";
	    shift
	    ;;
	-p|--password)
	    SQLPASS="$2"
	    shift
	    ;;
	-h|--host)
	    SQLHOST="$2"
	    shift
	    ;;
	-P|--port)
	    SQLPORT="$2"
	    shift
	    ;;
	-S|--socket)
	    SQLSOCK="$2"
	    shift
	    ;;
	-f|--filter)
	    NOFILTER=0
	    FILTER="$2"
	    shift
	    ;;
	-db|--database)
	    DB="$2"
	    shift
	    ;;
	-?|--help)
	    cat << EOF
Usage:
 install.sh [options]

Options:
 -u, --user string      MySQL username
 -p, --password string  MySQL password
 -h, --host name or IP  MySQL host
 -P, --port name        MySQL port
 -S, --socket filename  MySQL host
 -db, --database		Target Database to run test suite against
 -f, --filter string    Perform the action on one class of objects <matching|eq|moretap|todo|utils|charset|collation|column|constraint|engine|event|index|partition|privilege|role|routines|table|trigger|schemata|user|view>
EOF
	   exit 1 
	   ;;
	 *)     
	   exit 1
	   ;;
    esac;
    shift;
done


MYSQLOPTS="--batch --raw --skip-column-names --unbuffered"

if [[ $SQLUSER != '' ]] && [[ $SQLPASS != '' ]]; then
    MYSQLOPTS="$MYSQLOPTS -u$SQLUSER -p$SQLPASS";
fi

if [[ $SQLSOCK != '' ]]; then
   MYSQLOPTS="$MYSQLOPTS --socket=$SQLSOCK";
fi

if [[ $SQLHOST != 'localhost' ]]; then
   MYSQLOPTS="$MYSQLOPTS --host=$SQLHOST";
fi

if [[ $SQLPORT != '3306' ]]; then
  MYSQLOPTS="$MYSQLOPTS --port=$SQLPORT"
fi

MYVER1=`mysql $MYSQLOPTS --execute "SELECT @@global.version" | awk -F'-' '{print $1}' | awk -F'.' '{print $1 * 100000 }'`;
MYVER2=`mysql $MYSQLOPTS --execute "SELECT @@global.version" | awk -F'-' '{print $1}' | awk -F'.' '{print $2 * 1000 }'`;
MYVER3=`mysql $MYSQLOPTS --execute "SELECT @@global.version" | awk -F'-' '{print $1}' | awk -F'.' '{print $3}'`;


MYVER=$(($MYVER1+$MYVER2+$MYVER3));

if [[ $FILTER != 0 ]]; then
  echo "Running test suite with filter: $FILTER";
else
  echo "Running Full test suite, this will take a couple of minutes to complete."
fi

sleep 2;

if [[ $FILTER == 0 ]] || [[ $FILTER =~ "schema" ]]; then
  echo "============= schema ============="
  mysql $MYSQLOPTS --database $DB --execute 'source migration-tests/test-schema.sql'
fi


echo "Finished"
