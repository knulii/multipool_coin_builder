#####################################################
# Source code https://github.com/end222/pacmenu
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
cd $HOME/multipool/daemon_builder

RESULT=$(dialog --stdout --title "Ultimate Crypto-Server Daemon Installer" --menu "Choose one" -1 60 6 \
1 "Make clean - does not build only cleans build dir" \
2 "Fix invalid application of sizeof error" \
3 "Fix openSSL 1.1x incompatibilities" \
4 "Build Berkeley Coin with -fPIC" \
5 "Build Berkeley Coin with --without-miniupnpc" \
6 Exit)
if [ $RESULT = ]
then
exit;
fi

if [ $RESULT = 1 ]
then
clear;
source make_clean.sh
exit;
fi

if [ $RESULT = 2 ]
then
clear;
source size_of.sh;
exit;
fi

if [ $RESULT = 3 ]
then
clear;
source ssl_errors.sh;
exit;
fi

if [ $RESULT = 4 ]
then
clear;
source fPIC.sh
exit;
fi

if [ $RESULT = 5 ]
then
clear;
source mini.sh
exit;
fi

if [ $RESULT = 6 ]
then
clear;
exit;
fi
