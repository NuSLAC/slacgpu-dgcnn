# slacgpu-dgcnn
This repository contains scripts for submitting queues to `slacgpu` batch system to run training/inference for [dynamic-gcnn](https://github.com/DeepLearnPhysics/dynamic-gcnn).

## Train submission command
The command below submits a job that will use 8 GPUs to train 1 instance.
The arguments of this example scripts can set number of edge-convolution layers, number of filters, K1, K2 and alpha as parameters in clustering, and iteration count respectively.
```
bsub -n 8 -W 86400 -q slacgpu -R "select[ngpus>0] rusage[ngpus_excl_p=1] span[hosts=1]" singularity exec --nv --bind /scratch --bind /gpfs $HOME/images/tf1.10.1-torch0.4.1-root6.14.04.simg /u/nu/kterao/sw/slacgpu-dgcnn/train_dgcnn.sh residual-dgcnn 4 64 40 40 5 24000
```
