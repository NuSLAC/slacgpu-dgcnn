#!/bin/bash

MODEL_NAME=$1;  # [dgcnn,residual-dgcnn,residual-dgcnn-nofc]
NUM_LAYERS=$2;  # number of edge convolution layers
NUM_FILTERS=$3; # number of filters in each edge convolution layer
K1=$4;          # K1 factor in loss_same_pdg in clustering dgcnn
K2=$5;          # K2 factor in loss_diff_group in clustering dgcnn
ALPHA=$6;       # Alpha factor for loss_same_pdg
ITERATION=$7;   # number of iterations

ALPHA_DECAY=20;
KVALUE=40;

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
echo $DGCNN_DIR/bin/dgcnn.py train -bs 24 -mbs 1 -np -1 --gpus $CUDA_VISIBLE_DEVICES -chks 1000 -chkn 1 -chkh 0.2 -ss 100 -rs 50 -it $ITERATION -ld log -wp weights/snapshot -kv $KVALUE -mn $MODEL_NAME -ecl $NUM_LAYERS -ecf $NUM_FILTERS -io larcv -dkeys data,sim_group,sim_pdg  -if $DATA_DIR/$TRAIN_FILE -k1 $K1 -k2 $K2 -al $ALPHA -ad $ALPHA_DECAY >> log.txt;
$DGCNN_DIR/bin/dgcnn.py train -bs 24 -mbs 1 -np -1 --gpus $CUDA_VISIBLE_DEVICES -chks 1000 -chkn 1 -chkh 0.2 -ss 100 -rs 50 -it $ITERATION -ld log -wp weights/snapshot -kv $KVALUE -mn $MODEL_NAME -ecl $NUM_LAYERS -ecf $NUM_FILTERS -io larcv -dkeys data,sim_group,sim_pdg -if $DATA_DIR/$TRAIN_FILE -k1 $K1 -k2 $K2 -al $ALPHA -ad $ALPHA_DECAY >> log.txt;
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

