// modules/09_report.nf
process REPORT {
  tag "report"
  conda "../envs/report.yml"
  cpus 1
  memory '1 GB'

  input:
    path mmgbsa_csv
    path md_qc_csv
    path ddg_csv
    path immuno_csv
    path dev_csv

  output:
    path "report/report.html"

  script:
  """
  set -euo pipefail
  mkdir -p report
  python3 ../scripts/report.py "${mmgbsa_csv}" "${md_qc_csv}" "${ddg_csv}" "${immuno_csv}" "${dev_csv}" report/report.html
  """
  stub:
  """
  mkdir -p report
  echo '<h1>Stub Report</h1><p>This is a stub report; run without -stub-run to generate a detailed report.</p>' > report/report.html
  """
}