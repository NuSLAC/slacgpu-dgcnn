#!/bin/bash
invalid=0;
for arg in "$@"
do
    if [ "$arg" = "-if" ]; then
	invalid=1;
    elif [ "$arg" = "-ld" ]; then
	invalid=1;
    elif [ "$arg" = "-wp" ]; then
	invalid=1;
    fi
    if [ $invalid -eq 1 ]; then
	echo "This script cannot take the argument $arg";
	exit;
    fi
done

ARGS="$*"
#CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
IN_STORAGE_DIR=/gpfs/slac/staas/fs1/g/neutrino/kterao;
OUT_STORAGE_DIR=/gpfs/slac/staas/fs1/g/neutrino/${USER};
SWDIR=$HOME/sw
DGCNN_DIR=$SWDIR/dynamic-gcnn;
TRAIN_FILE=dlprod_ppn_v08_p02_train_similarity.root;
WORK_DIR=/scratch/${USER}/temp_$$;
DATA_DIR=/scratch/${USER}/data_$$;

source $SWDIR/larcv2/configure.sh;
mkdir -p $WORK_DIR;
mkdir -p $DATA_DIR;
cp $IN_STORAGE_DIR/data/$TRAIN_FILE $DATA_DIR;
cd $WORK_DIR;
echo $CUDA_VISIBLE_DEVICES >> log.txt
echo $DGCNN_DIR/bin/dgcnn.py $ARGS -ld log -wp weights/snapshot -if $DATA_DIR/$TRAIN_FILE >> log.txt;
$DGCNN_DIR/bin/dgcnn.py $ARGS -ld log -wp weights/snapshot -if $DATA_DIR/$TRAIN_FILE >> log.txt;
cd ..;
mkdir -p $OUT_STORAGE_DIR;
cp -r $WORK_DIR $OUT_STORAGE_DIR;
if [ $? -eq 1 ]; then
cp -r $WORK_DIR $HOME;
fi
if [ $? -eq 0 ]; then
rm -rf $WORK_DIR;
fi
rm -rf $DATA_DIR;
