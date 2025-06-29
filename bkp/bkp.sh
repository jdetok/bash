#!/bin/bash
BKP_PATH=/mnt/store/bkp/linux/pi-jdeto
BKP_DIR=${BKP_PATH}/bkp_$(date +"%m%d%Y_%H%M%S")
MAXD=3


mkdir -p $BKP_DIR

function cphome() {
	local dir=$1
	echo "backing up ${HOME}/${dir}..."
	
	# sudo cp -rv ${HOME}/${dir}/ ${BKP_DIR}/${dir}
	sudo rsync -av --progress \
		--exclude='.git' \
		--exclude='pkg' \
		${HOME}/${dir}/ ${BKP_DIR}/${dir}/
		
}

# copy dotfiles like .vimrc .gitconfig etc
function cpdotf() {
	echo -e "\nbacking up /home dotfiles"
	# sudo cp -rv ${HOME}/.*
	sudo rsync -av \
		--include='.*' \
		--exclude '.*_history' \
		--exclude='*/' \
		--exclude='*' \
		$HOME/ /$BKP_DIR/
}

function cpetc() {
	local f=$1
	mkdir -p $BKP_DIR/etc/$(dirname $f)
	sudo cp /etc/$1 $BKP_DIR/etc/$f
}

# rm old bkp dirs if necessary
function cleanup() {
	ndirs=$(find $BKP_PATH -maxdepth 1 -type d -name 'bkp_*'  | wc -l)
	echo "number of bkp directories: $ndirs"
	
	if [ $ndirs -gt $MAXD ]; then # number of old dirs to rm
		n=$(($ndirs - $MAXD))
		i=0
		echo "attempting to remove $n old directories..."
		find $BKP_PATH -maxdepth 1 -type d -name 'bkp_*' | \
		sort | head -n $n | \
		while read oldestdir; do
			echo "removing ${oldestdir}..."
			sudo rm -r $oldestdir
		done
	fi
}

# copy hidden dotfiles in the home dir
cpdotf

# backup home directory
cphome ard
cphome go
cphome dkr
cphome scripts
cphome priv

echo -e "\nfinished with home dir backup"
# backup etc files
cpetc fstab
cpetc passwd
cpetc group
cpetc vim/vimrc

# remove old backup directories
echo -e "\nstarting cleanup..."
cleanup

echo -e "\nbackup complete at $BKP_DIR"
