# HERMIS lookup

## Setup

```bash
cd ~/rds/results/public/gwas/heart_failure/hermes_2020/ftp
wget https://broad-portal-resources.s3.amazonaws.com/CVDKP/HERMES_Jan2019_HeartFailure_summary_data.README.txt
wget https://personal.broadinstitute.org/ryank/HERMES_Jan2019_HeartFailure_summary_data.txt.zip
cat <(gunzip -c HERMES_Jan2019_HeartFailure_summary_data.txt.zip | head -1) \
    <(gunzip -c HERMES_Jan2019_HeartFailure_summary_data.txt.zip | sed '1d' | sort -k2,2n -k3,3n) | \
bgzip -f > HERMES_Jan2019_HeartFailure_summary_data.gz
tabix -S1 -s2 -b3 -e3 HERMES_Jan2019_HeartFailure_summary_data.gz
```
## Notes

The raw summary data are kept here along with README without permission issue.

## Data availability

<https://cvd.hugeamp.org/> (<https://cvd.hugeamp.org/dinspector.html?dataset=GWAS_HERMES_eu>)

## Reference

Genome-wide association study provides new insights into the genetic architecture and pathogenesis of heart failure.
Shah S, Henry A, et al. *Nat Commun*. 2020 Jan 9;11(1):163. <doi:10.1038/s41467-019-13690-5>.
