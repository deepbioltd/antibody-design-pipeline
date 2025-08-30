// modules/01_number_anarci.nf
process NUMB {
  tag "numbering"
  conda "../envs/general.yml"
  cpus 1
  memory '2 GB'

  input:
    tuple path(heavy_fa), path(light_fa)

  output:
    path "heavy.fasta"
    path "light.fasta"
    path "numbering/numbered.json"

  script:
  """
  set -euo pipefail
  mkdir -p numbering
  cp "${heavy_fa}" heavy.fasta
  cp "${light_fa}" light.fasta
  python - << 'PY'
import json, os
d = {
  "schema": "IMGT",
  "heavy_fasta": os.path.basename("heavy.fasta"),
  "light_fasta": os.path.basename("light.fasta"),
  "note": "Placeholder numbering; replace with ANARCI/IgBLAST outputs."
}
os.makedirs("numbering", exist_ok=True)
open("numbering/numbered.json","w").write(json.dumps(d, indent=2))
PY
  """
  stub:
  """
  mkdir -p numbering
  cp "${heavy_fa}" heavy.fasta
  cp "${light_fa}" light.fasta
  echo '{"schema":"IMGT","note":"stub numbering"}' > numbering/numbered.json
  """
}