#!/usr/bin/bash

cd ~/rds/results/public/gwas/heart_failure/hermes_2020/ftp
wget https://broad-portal-resources.s3.amazonaws.com/CVDKP/HERMES_Jan2019_HeartFailure_summary_data.README.txt
wget https://personal.broadinstitute.org/ryank/HERMES_Jan2019_HeartFailure_summary_data.txt.zip
cat <(gunzip -c HERMES_Jan2019_HeartFailure_summary_data.txt.zip | head -1) \
    <(gunzip -c HERMES_Jan2019_HeartFailure_summary_data.txt.zip | sed '1d' | sort -k2,2n -k3,3n) | \
bgzip -f > HERMES_Jan2019_HeartFailure_summary_data.gz
tabix -S1 -s2 -b3 -e3 HERMES_Jan2019_HeartFailure_summary_data.gz

export rt=~/HERMES
for dir in doc work results
do
  if [ ! -d ${rt}/${dir} ]; then mkdir ${rt}/${dir}; fi
done
