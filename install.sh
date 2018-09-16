#!/bin/bash
#####################################################
# This is the entry point for configuring the system.
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh # load our functions
source /etc/multipool.conf
tmpdir=$PWD
if [ ! -d $STORAGE_ROOT/coin_builder ]; then
mkdir -p $STORAGE_ROOT/coin_builder
sudo cp -r $tmpdir/. $STORAGE_ROOT/coin_builder
echo '
#!/bin/bash
source /etc/functions.sh # load our functions
source /etc/multipool.conf
cd $STORAGE_ROOT/coin_builder
bash start.sh
cd ~
' | sudo -E tee /usr/bin/coinbuilder >/dev/null 2>&1
sudo chmod +x /usr/bin/coinbuilder
fi

cd $STORAGE_ROOT/coin_builder
source start.sh
