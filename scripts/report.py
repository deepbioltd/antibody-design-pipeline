#!/usr/bin/env python3
import sys, pandas as pd, os, pathlib
from datetime import datetime

if len(sys.argv) != 7:
    print("Usage: report.py <mmgbsa.csv> <md_qc.csv> <ddg.csv> <immuno.csv> <dev.csv> <out.html>")
    sys.exit(1)

mmgbsa_csv, md_qc_csv, ddg_csv, immuno_csv, dev_csv, out_html = sys.argv[1:]

def maybe_read(p):
    try:
        return pd.read_csv(p)
    except Exception:
        return pd.DataFrame()

mmgbsa = maybe_read(mmgbsa_csv)
md_qc  = maybe_read(md_qc_csv)
ddg    = maybe_read(ddg_csv)
immuno = maybe_read(immuno_csv)
dev    = maybe_read(dev_csv)

html_parts = []
html_parts.append("<h1>Antibody Design Pipeline Report</h1>")
html_parts.append(f"<p>Generated: {datetime.now().isoformat()}</p>")

def tbl(title, df):
    if df is None or df.empty:
        return f"<h2>{title}</h2><p><em>No data.</em></p>"
    return "<h2>{}</h2>{}".format(title, df.to_html(index=False))

html_parts.append(tbl("MM/GBSA Summary", mmgbsa))
html_parts.append(tbl("MD Quality Control", md_qc))
html_parts.append(tbl("Affinity Maturation (ΔΔG)", ddg))
html_parts.append(tbl("Immunogenicity (HLA-II binders)", immuno))
html_parts.append(tbl("Developability Metrics", dev))

out_dir = pathlib.Path(out_html).parent
out_dir.mkdir(parents=True, exist_ok=True)
with open(out_html, "w", encoding="utf-8") as f:
    f.write("\n".join(html_parts))

print(f"[report] Wrote {out_html}")