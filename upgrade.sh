#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

clear
source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/multipool/daemon_builder/.my.cnf
cd $HOME/multipool/daemon_builder

read -e -p "Enter the name of the coin : " coin
read -e -p "Paste the github link for the coin : " git_hub
read -e -p "Enter the coind name as it is in yiimp, example bitcoind : " pkillcoin
read -n 1 -s -r -p "I am now going to kill $pkillcoin so the update can continue. Press any key to continue"
sudo pkill -9 $pkillcoin

now=$(date +"%m_%d_%Y")
set -e
NPROC=$(nproc)

if [[ ! -e '$STORAGE_ROOT/daemon_builder/temp_coin_builds' ]]; then
mkdir -p $STORAGE_ROOT/daemon_builder/temp_coin_builds
else
echo "temp_coin_builds already exists.... Skipping"
fi
cd $STORAGE_ROOT/daemon_builder/temp_coin_builds

coindir=$coin$now
# save last coin information in case coin build fails
echo '
lastcoin='"${coindir}"'
' | sudo -E tee $STORAGE_ROOT/daemon_builder/temp_coin_builds/.lastcoin.conf >/dev/null 2>&1
# create coin user and directory

if [[ ! -e $coindir ]]; then
git clone $git_hub $coindir
else
echo "$STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir already exists.... Skipping"
exit 0
fi
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir
cd "${coindir}"
if [[ ("$autogen" == "true") ]]; then
if [[ ("$berkeley" == "4.8") ]]; then
echo "Building using Berkeley 4.8..."
basedir=$(pwd)
sh autogen.sh
sudo chmod 777 $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/share/genbuild.sh
sudo chmod 777 $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/leveldb/build_detect_platform
./configure CPPFLAGS="-I$STORAGE_ROOT/berkeley/db4/include -O2" LDFLAGS="-L$STORAGE_ROOT/berkeley/db4/lib" --without-gui --disable-tests
else
echo "Building using Berkeley 5.3..."
basedir=$(pwd)
sh autogen.sh
sudo chmod 777 $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/share/genbuild.sh
sudo chmod 777 $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/leveldb/build_detect_platform
./configure CPPFLAGS="-I$STORAGE_ROOT/berkeley/db5/include -O2" LDFLAGS="-L$STORAGE_ROOT/berkeley/db5/lib" --without-gui --disable-tests
fi
make -j$(nproc)
else
echo "Building using makefile.unix method..."
cd $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src
if [[ ! -e '$STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/obj' ]]; then
 mkdir -p $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/obj
        else
    echo "Hey the developer did his job and the src/obj dir is there!"
fi
if [[ ! -e '$STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/obj/zerocoin' ]]; then
mkdir -p $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/obj/zerocoin
else
echo  "Wow even the /src/obj/zerocoin is there! Good job developer!"
fi
cd $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/leveldb
sudo chmod +x build_detect_platform
sudo make clean
sudo make libleveldb.a libmemenv.a
cd $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src
sed -i '/USE_UPNP:=0/i BDB_LIB_PATH = /home/crypto-data/berkeley/db4/lib\nBDB_INCLUDE_PATH = /home/crypto-data/berkeley/db4/include\nOPENSSL_LIB_PATH = /home/crypto-data/openssl/lib\nOPENSSL_INCLUDE_PATH = /home/crypto-data/openssl/include' makefile.unix
make -j$NPROC -f makefile.unix USE_UPNP=-
fi
clear
ls $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/
read -e -p "Please enter the coind name from the directory above, example bitcoind :" coind
read -e -p "Is there a coin-cli, example bitcoin-cli [y/N] :" ifcoincli
if [[ ("$ifcoincli" == "y" || "$ifcoincli" == "Y") ]]; then
read -e -p "Please enter the coin-cli name :" coincli
fi
clear
sudo strip $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/$coind
sudo cp $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/$coind /usr/bin
if [[ ("$ifcoincli" == "y" || "$ifcoincli" == "Y") ]]; then
sudo strip $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/$coincli
sudo cp $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir/src/$coincli /usr/bin
fi
mkdir -p $STORAGE_ROOT/wallets/."${coind::-1}"
echo "I am now going to open nano, please verify if there any changes that are needed such as adding or removing addnodes."
read -n 1 -s -r -p "Press any key to continue"
sudo nano $STORAGE_ROOT/wallets/."${coind::-1}"/${coind::-1}.conf
clear
echo "Starting ${coind::-1}"
/usr/bin/"${coind}" -datadir=$STORAGE_ROOT/wallets/."${coind::-1}" -conf="${coind::-1}.conf" -daemon -shrinkdebugfile -reindex

# If we made it this far everything built fine removing last coin.conf and build directory
sudo rm -r $STORAGE_ROOT/daemon_builder/temp_coin_builds/.lastcoin.conf
sudo rm -r $STORAGE_ROOT/daemon_builder/temp_coin_builds/$coindir
sudo rm -r $HOME/multipool/daemon_builder/.my.cnf
cd $HOME/multipool/daemon_builder

clear
echo "Upgrade of ${coind::-1} is completed and running. The blockchain is being reindexed, it could be several minutes before you can connect to your coin."
echo Type daemonbuilder at anytime to install a new coin!
