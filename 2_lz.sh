#!/usr/bin/bash

export M=500000
export src=~/rds/results/public/gwas/heart_failure/hermes_2020/ftp/HERMES_Jan2019_HeartFailure_summary_data.gz
export rt=~/HERMES

cat << 'EOL' > ${rt}/work/2_lz.sb
#!/usr/bin/bash

#SBATCH --job-name=_lz
#SBATCH --account CARDIO-SL0-CPU
#SBATCH --partition cardio
#SBATCH --qos=cardio
#SBATCH --array=1-112
#SBATCH --mem=28800
#SBATCH --time=5-00:00:00
#SBATCH --error=work/_lz_%A_%a.err
#SBATCH --output=work/_lz_%A_%a.out
#SBATCH --export ALL

function f() {
  sed '1d' ${rt}/doc/MAP.txt | cut -f2 | grep -f - -w ${INF}/csd3/glist-hg19 | grep -v "-"
}

read chr start end gene < <(f|awk -vM=${M} 'NR==ENVIRON["SLURM_ARRAY_TASK_ID"]{if($2-M<1) $2=1;else $2=$2-M;$3=$3+M;print}')

cat <(gunzip -c lookup-all.tsv.gz | head -1) \
    <(zgrep -w ${gene} lookup-all.tsv.gz) > ${rt}/work/MAP.${gene}.lz
locuszoom --source 1000G_Nov2014 --build hg19 --pop EUR --metal ${rt}/work/MAP.${gene}.lz \
          --delim tab title="HERMES: ${gene}" \
          --markercol SNP --pvalcol p --chr ${chr} --start ${start} --end ${end} --cache None \
          --no-date --plotonly --prefix=HERMES-${gene} --rundir ${rt}/work
EOL

sbatch ${rt}/work/2_lz.sb
