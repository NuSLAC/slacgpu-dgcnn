# slacgpu-dgcnn
This repository contains scripts for submitting queues to `slacgpu` batch system to run training/inference for [dynamic-gcnn](https://github.com/DeepLearnPhysics/dynamic-gcnn).

## Pre-requisites
* Singularity image
* [dynamic-gcnn](https://github.com/DeepLearnPhysics/dynamic-gcnn) installed at `$HOME/sw/dynamic-dgcnn`
* [larcv2](https://github.com/DeepLearnPhysics/larcv2) installed at `$HOME/sw/larcv2` and built under the image environment

## Train submission command
The command below submits a job that will use 8 GPUs to train 1 instance.
```
bsub -n 8 -W 86400 -q slacgpu -R "select[ngpus>0] rusage[ngpus_excl_p=1] span[hosts=1]" singularity exec --nv --bind /scratch --bind /gpfs $IMAGE_FILE train_dgcnn.sh $ARGS
```
`$IMAGE_FILE` should be the location of your singularity image file.
The last argument `$ARGS` shuld be exactly the list of arguments you would have given to run `bin/dgcnn.py` interactively (see [dynamic-gcnn](https://github.com/DeepLearnPhysi\
cs/dynamic-gcnn)).