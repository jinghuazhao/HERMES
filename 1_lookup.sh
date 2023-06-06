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
    }" > work/MAP.{4}
    tabix ${src} $(cat work/MAP.{4}) | \
    awk -vgene={4} -vOFS="\t" "{print gene,\$0}"
  '
) | \
Rscript -e '
  options(width=200)
  out <- read.table("stdin",col.names=c("gene","SNP","CHR","BP","A1","A2","freq","b","se","p","N"))
  suppressMessages(library(tidyverse))
  write_tsv(out,file="lookup-all.tsv.gz",quote="none")
  r <- group_by(out,gene) %>%
       slice(which.max(abs(b/se))) %>%
       data.frame
  write.table(r,file="lookup.tsv",quote=FALSE,row.names=FALSE,sep="\t")
'

sed '1d' lookup.tsv | \
cut -f1 | \
uniq | \
grep -f - -v -w doc/MAP.txt > doc/MAP.NO

