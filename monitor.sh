#!/bin/bash

# Define here a valid email address where notigications will be send to
EMAIL_ADDRESS="delanhype@gmail.com"

# Declare here a list of hosts
declare -a HOST=("192.168.56.101" "192.168.56.102" "192.168.56.103")

# Check if mail utility is installed, if not, it's installed
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' mailutils|grep "install ok installed")
if [ $PKG_OK == "" ]; then
  `sudo apt-get --force-yes --yes install mailutils`
fi
for i in "${HOST[@]}"
do  
    echo "Host: " $i
    MYSQL_CHECK=$(mysql -uroot -h$i -e "SHOW VARIABLES LIKE '%version%';" || echo 1)
    SECONDS_BEHIND_MASTER=$(/usr/bin/mysql -uroot -h$i -e "SHOW SLAVE STATUS\G"| grep "Seconds_Behind_Master" | awk '{ print $2 }')
    SQL_IS_RUNNING=$(/usr/bin/mysql -uroot -h$i -e "SHOW SLAVE STATUS\G" | grep "Slave_SQL_Running" | awk '{ print $2 }')
    MASTER_HOST=$(/usr/bin/mysql -uroot -h$i -e "SHOW SLAVE STATUS\G" | grep "Master_Host" | awk '{ print $2 }')
    ERRORS=()

    echo "Master running on: " $MASTER_HOST

    if [ "$MYSQL_CHECK" == 1 ]
    then
        ERRORS=("${ERRORS[@]}" "MySQL server seems to be down!")
    fi

    # Check if SQL is running
    if [ "$SQL_IS_RUNNING" != "Yes" ]
    then
        ERRORS=("${ERRORS[@]}" "SQL is running")
    fi

    # Check if slave is behind master
    if [ "$SECONDS_BEHIND_MASTER" == "0" ]
    then
        ERRORS=("${ERRORS[@]}" "The Slave is not behind the master)")
    elif [ "$SECONDS_BEHIND_MASTER" > 60 ]
    then
        ERRORS=("${ERRORS[@]}" "The Slave is more than 60s behind the master")
    fi

    # Alert the system admin
    if [ "${#ERRORS[@]}" -gt 0 ]
    then
        MESSAGE="Yo! An error has been detected on HOST ${HOST}.\n
        $(for i in $(seq 1 ${#ERRORS[@]}) ; do echo "\t${ERRORS[$i]}\n" ; done)
        "
        echo -e $MESSAGE | mail -s "Error(s)" ${EMAIL_ADDRESS}
    fi
done

# Note: 
   # 1. The script can be set in a dedicated machine/server that's runnning 24/7, e.g a VM in GCE or AWS 
   # 2. A cronjob can be set to run this script every five minutes as shown below:
            ## */5 * * * * ./path-to-monitor.sh