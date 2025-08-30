// modules/03_complex_lightdock.nf
process DOCK {
  tag "docking"
  conda "../envs/general.yml"
  cpus 2
  memory '4 GB'

  input:
    path ab_model_pdb
    path antigen

  output:
    path "docking/best_complex.pdb"
    path "docking/best_pose.pdb"

  script:
  """
  set -euo pipefail
  mkdir -p docking

  # Example real command (uncomment and adapt):
  # lightdock3.py setup "${ab_model_pdb}" "${antigen}" --output docking &&   # lightdock3.py dock docking &&   # <scoring+clustering> &&   # cp docking/best_complex.pdb docking/best_pose.pdb

  # Placeholder complex
  cat > docking/best_complex.pdb << 'PDB'
REMARK demo docked complex (placeholder)
END
PDB

  cp docking/best_complex.pdb docking/best_pose.pdb
  """
  stub:
  """
  mkdir -p docking
  echo 'REMARK stub complex' > docking/best_complex.pdb
  echo 'END' >> docking/best_complex.pdb
  cp docking/best_complex.pdb docking/best_pose.pdb
  """
}