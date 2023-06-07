#!/usr/bin/bash

export M=500000
export src=~/rds/results/public/gwas/heart_failure/hermes_2020/ftp/HERMES_Jan2019_HeartFailure_summary_data.gz
export rt=~/HERMES

(
  sed '1d' ${rt}/doc/MAP.txt | \
  cut -f2 | \
  grep -f - -w ${INF}/csd3/glist-hg19 | \
  grep -v "-" | \
  parallel -C ' ' '
    awk -vchr={1} -vstart={2} -vend={3} -vM=${M} -vgene={4} "
    BEGIN {
       if (start-M<1) start=1; else start=start-M
       print chr\":\"start\"-\"end+M
    }" > ${rt}/work/MAP.{4}
    tabix ${src} $(cat ${rt}/work/MAP.{4}) | \
    awk -vgene={4} -vOFS="\t" "{print gene,\$0}"
  '
) | \
Rscript -e '
  options(width=200)
  rt <- Sys.getenv("rt")
  suppressMessages(library(tidyverse))
  out <- read.table("stdin") %>%
         setNames(c("gene","SNP","CHR","BP","A1","A2","freq","b","se","p","N"))
  write_tsv(out,file=file.path(rt,"results","lookup-all.tsv.gz"),quote="none")
  r <- group_by(out,gene) %>%
       slice(which.max(abs(b/se))) %>%
       data.frame
  write.table(r,file=file.path(rt,"results","lookup.tsv"),quote=FALSE,row.names=FALSE,sep="\t")
'

sed '1d' ${rt}/results/lookup.tsv | \
cut -f1 | \
uniq | \
grep -f - -v -w ${rt}/doc/MAP.txt > ${rt}/doc/MAP.NO

