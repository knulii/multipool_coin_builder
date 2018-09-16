#####################################################
# Source code https://github.com/end222/pacmenu
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
cd $STORAGE_ROOT/coin_builder

RESULT=$(dialog --stdout --title "Ultimate Crypto-Server Daemon Installer" --menu "Choose one" -1 60 4 \
1 "Fix invalid application of sizeof error" \
2 "Fix openSSL 1.1x incompatibilities" \
4 Exit)
if [ $RESULT = ]
then
exit ;
fi

if [ $RESULT = 1 ]
then
clear;
source size_of.sh;
exit;
fi

if [ $RESULT = 2 ]
then
clear;
source ssl_errors.sh;
exit;
fi

if [ $RESULT = 3 ]
then
clear;
exit;
fi

if [ $RESULT = 4 ]
then
clear;
exit;
fi
