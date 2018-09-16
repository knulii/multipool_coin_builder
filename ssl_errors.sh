#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

clear
source $STORAGE_ROOT/coin_builder/.my.cnf
source $STORAGE_ROOT/coin_builder/temp_coin_builds/.lastcoin.conf
cd $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin
sh autogen.sh
if [[ ("$berkeley" == "4.8") ]]; then
./configure CPPFLAGS="-I$STORAGE_ROOT/berkeley/db4/include -I$STORAGE_ROOT/openssl/include -O2" LDFLAGS="-L$STORAGE_ROOT/berkeley/db4/lib -L$STORAGE_ROOT/openssl/lib" --without-gui --disable-tests
else
./configure CPPFLAGS="-I$STORAGE_ROOT/berkeley/db5/include -I$STORAGE_ROOT/openssl/include -O2" LDFLAGS="-L$STORAGE_ROOT/berkeley/db5/lib -L$STORAGE_ROOT/openssl/lib" --without-gui --disable-tests
fi
make -j$(nproc)
clear
ls $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin/src/
read -e -p "Please enter the coind name from the directory above, example bitcoind :" coind
read -e -p "Is there a coin-cli, example bitcoin-cli [y/N] :" ifcoincli
if [[ ("$ifcoincli" == "y" || "$ifcoincli" == "Y") ]]; then
read -e -p "Please enter the coin-cli name :" coincli
fi
clear
sudo strip $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin/src/$coind
sudo cp $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin/src/$coind /usr/bin
if [[ ("$ifcoincli" == "y" || "$ifcoincli" == "Y") ]]; then
sudo strip $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin/src/$coincli
sudo cp $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin/src/$coincli /usr/bin
fi
mkdir -p $STORAGE_ROOT/wallets/."${coind::-1}"
echo "I am now going to open nano, please copy and paste the config from yiimp in to this file."
read -n 1 -s -r -p "Press any key to continue"
sudo nano $STORAGE_ROOT/wallets/."${coind::-1}"/${coind::-1}.conf
clear
echo "Starting ${coind::-1}"
/usr/bin/"${coind}" -datadir=$STORAGE_ROOT/wallets/."${coind::-1}" -conf="${coind::-1}.conf" -daemon -shrinkdebugfile
# If we made it this far everything built fine removing last coin.conf and build directory
sudo rm -r $STORAGE_ROOT/coin_builder/temp_coin_builds/.lastcoin.conf
sudo rm -r $STORAGE_ROOT/coin_builder/temp_coin_builds/$lastcoin
cd $STORAGE_ROOT/coin_builder

clear
echo Installation of your coin daemon is completed.
echo Type coinbuilder at anytime to install a new coin!
