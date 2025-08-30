// modules/04_md_gromacs.nf
process MD {
  tag "md"
  conda "../envs/gromacs.yml"
  cpus 4
  memory '8 GB'

  input:
    path complex_pdb

  output:
    path "md/equilibrated.tpr"
    path "md/trajectory.xtc"
    path "md/qc.csv"

  script:
  """
  set -euo pipefail
  mkdir -p md

  # Example real commands (GROMACS):
  # gmx pdb2gmx -f "${complex_pdb}" -o md/complex.gro -p md/topol.top -ignh -ff amber99sb-ildn -water tip3p
  # gmx editconf -f md/complex.gro -o md/boxed.gro -c -d 1.0 -bt cubic
  # gmx solvate -cp md/boxed.gro -cs spc216 -o md/solv.gro -p md/topol.top
  # gmx grompp -f minim.mdp -c md/solv.gro -p md/topol.top -o md/min.tpr
  # gmx mdrun -deffnm md/min
  # ... (NVT/NPT/production) ...
  # touch md/equilibrated.tpr md/trajectory.xtc

  # Placeholder artifacts + QC
  echo 'placeholder' > md/equilibrated.tpr
  echo 'placeholder' > md/trajectory.xtc
  cat > md/qc.csv << 'CSV'
metric,value
RMSD_mean_A,0.25
Rg_mean_A,20.1
HBonds_mean,12
CSV
  """
  stub:
  """
  mkdir -p md
  echo 'stub' > md/equilibrated.tpr
  echo 'stub' > md/trajectory.xtc
  echo -e "metric,value
RMSD_mean_A,0.30
Rg_mean_A,19.8
HBonds_mean,11" > md/qc.csv
  """
}