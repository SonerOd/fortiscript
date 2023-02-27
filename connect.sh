#!/bin/bash

VPNFILE="./vpnsettings.conf"
VPNON=""
while [ -z "$VPNON" ]
do
    echo
	echo -e "Credentials"
	echo -e "================================="
	echo "Configurant"
	echo host = ${HOST} > $VPNFILE
	echo port = ${PORT} >> $VPNFILE
	echo username = ${USERNAME} >> $VPNFILE
	echo password = ${PASSWORD} >> $VPNFILE
	echo trusted-cert = ${TRUSTED} >> $VPNFILE
    echo
	echo "Connecting to vpn"
	VPNON=""
    sudo openfortivpn -c $VPNFILE > openfortivpn.log 2>&1 &
   COUNT=1
    while [ -z "$VPNON" ]
	do
	    echo -ne "\e[33mCONNECTING TO VPN ... $COUNT\033[0K\r"
		VPNON=$(ip a | grep ppp0)
		if [ ! -z "$VPNON" ]
		then
            echo
			echo -e "\e[32mVPN. Ok "
			break
		fi
		if [ $COUNT -eq 10 ];
		then
			echo ""
			echo ""
			echo -e "\e[31mERROR: VPN Connection Error. "
			break
		fi
		let COUNT=$COUNT+1
		sleep 1
	done
done
