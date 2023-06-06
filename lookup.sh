#!/usr/bin/bash

export M=500000
export src=~/rds/results/public/gwas/heart_failure/hermes_2020/ftp/HERMES_Jan2019_HeartFailure_summary_data.gz
(
  sed '1d' doc/MAP.txt | \
  cut -f2 | \
  grep -f - -w ${INF}/csd3/glist-hg19 | \
  grep -v "-" | \
  parallel -C ' ' '
    awk -vchr={1} -vstart={2} -vend={3} -vM=${M} -vgene={4} "
    BEGIN {
       if (start-M<1) start=1
       print chr\":\"start\"-\"end+M
    }" > MAP.{4}
    tabix ${src} MAP.${4}
  '
) > MAP.out

