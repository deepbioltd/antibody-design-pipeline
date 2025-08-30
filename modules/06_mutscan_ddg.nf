// modules/06_mutscan_ddg.nf
process MUTSCAN {
  tag "mutscan"
  conda "../envs/general.yml"
  cpus 2
  memory '4 GB'

  input:
    path ab_model_pdb
    path antigen
    path best_pose

  output:
    path "mutscan/ddg.csv"

  script:
  """
  set -euo pipefail
  mkdir -p mutscan

  # Example real command (FoldX/Rosetta ddG):
  # foldx --command=PositionScan --pdb=${ab_model_pdb} --positions=CDR_positions.txt --output-file=mutscan/ddg.csv

  # Placeholder ddG table
  cat > mutscan/ddg.csv << 'CSV'
position,mutation,ddG_kcal_per_mol
H31,Y->F,-0.6
H54,S->T,-0.3
L32,N->D,0.2
CSV
  """
  stub:
  """
  mkdir -p mutscan
  echo -e "position,mutation,ddG_kcal_per_mol
H31,Y->F,-0.5
H54,S->T,-0.2
L32,N->D,0.1" > mutscan/ddg.csv
  """
}