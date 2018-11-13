#####################################################
# Source code https://github.com/end222/pacmenu
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
cd $HOME/multipool/daemon_builder

RESULT=$(dialog --stdout --title "Ultimate Crypto-Server Daemon Installer v1.06" --menu "Choose one" -1 60 5 \
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
cd $HOME/multipool/daemon_builder
source menu2.sh;
fi

if [ $RESULT = 2 ]
then
clear;
cd $HOME/multipool/daemon_builder
source menu3.sh;
fi

if [ $RESULT = 3 ]
then
clear;
cd $HOME/multipool/daemon_builder
source menu4.sh;
fi

if [ $RESULT = 4 ]
then
clear;
cd $HOME/multipool/daemon_builder
source errors.sh;
fi

if [ $RESULT = 5 ]
then
clear;
exit;
fi
