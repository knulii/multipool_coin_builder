source /etc/functions.sh
cd $STORAGE_ROOT/coin_builder

RESULT=$(dialog --stdout --title "Ultimate Crypto-Server Daemon Installer" --menu "Choose one" -1 60 5 \
1 "Install New Coin from Source" \
2 "Install New Coin from Release" \
3 "Upgrade Existing Coin" \
4 "Fix Coin Errors on last build attempt" \
5 Exit)
if [ $RESULT = ]
then
exit;
fi

if [ $RESULT = 1 ]
then
clear;
source menu2.sh;
fi

if [ $RESULT = 2 ]
then
clear;
source menu3.sh;
fi

if [ $RESULT = 3 ]
then
clear;
source menu4.sh;
fi

if [ $RESULT = 4 ]
then
clear;
source errors.sh;
fi

if [ $RESULT = 5 ]
then
clear;
exit;
fi
