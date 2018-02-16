#!/bin/bash
export LD_LIBRARY_PATH=/home/msmelyan/OptErd/trunk/ialibs/
data=/home/msmelyan/OptErd/trunk/data/new/

for fraction in 0.001 #0.002
do

for file in ${data}/1hsg_30.xyz ${data}/1hsg_32.xyz ${data}/1hsg_35.xyz ${data}/1hsg_38.xyz ${data}/1hsg_40.xyz ${data}/1hsg_42.xyz ${data}/1hsg_45.xyz ${data}/1hsg_48.xyz ${data}/1hsg_50.xyz ${data}/1hsg_55.xyz ${data}/1hsg_60.xyz ${data}/1hsg_65.xyz ${data}/1hsg_70.xyz ${data}/1hsg_80.xyz ${data}/1hsg_90.xyz ${data}/1hsg_100.xyz ${data}/1hsg_120.xyz ${data}/1hsg_140.xyz ${data}/1hsg_160.xyz ${data}/1hsg_180.xyz ${data}/1hsg_200.xyz ${data}/1hsg_220.xyz
do
   echo $fraction  $file
   testprog/pld/Bench.Opt.Math data/cc-pvdz.gbs $file $fraction 6
done
done


