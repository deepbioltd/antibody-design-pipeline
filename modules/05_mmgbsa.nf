// modules/05_mmgbsa.nf
process MMGBSA {
  tag "mmgbsa"
  conda "../envs/gromacs.yml"
  cpus 2
  memory '4 GB'

  input:
    path tpr
    path xtc

  output:
    path "mmgbsa/summary.csv"

  script:
  """
  set -euo pipefail
  mkdir -p mmgbsa

  # Example real command (gmx_MMPBSA):
  # gmx_MMPBSA -O -i mmpbsa.in -cs <complex.tpr> -ci <index.ndx> -cg 1 13 -ct <traj.xtc> -o mmgbsa/summary.dat
  # python parse_to_csv.py ...

  # Placeholder inspired by case study
  cat > mmgbsa/summary.csv << 'CSV'
term,value,stderr
E_VDW,-133.56,10.86
E_EEL,476.36,23.18
E_GB,-341.02,7.82
E_SURF,-20.26,0.59
G_TOTAL,-18.48,27.74
CSV
  """
  stub:
  """
  mkdir -p mmgbsa
  echo -e "term,value,stderr
E_VDW,-120.0,11.0
E_EEL,450.0,22.0
E_GB,-330.0,8.0
E_SURF,-19.0,0.6
G_TOTAL,-19.0,28.0" > mmgbsa/summary.csv
  """
}