# Antibody Design Pipeline (Nextflow DSL2)

A reproducible, modular pipeline for computational antibody design: **structural modeling, docking,
binding-site/affinity prediction (MD + MM/GBSA), humanization, in-silico affinity maturation,
immunogenicity and developability assessment**, with an automated HTML report.

- **Engine:** Nextflow (DSL2) with profiles for local, SLURM, AWS.
- **Reproducibility:** per-step Conda envs (or containers), fixed seeds, and deterministic artifacts.
- **Smoke test:** `-stub-run` creates placeholder outputs without installing heavy toolchains.
- **Real run:** enable conda or containers and set `params` in `configs/params.example.yaml`.

> This implementation operationalizes the stages described in *“Antibody Drug Design Using Computational Modeling”*
> (structural modeling, docking, binding-site/affinity prediction, humanization, affinity maturation,
> immunogenicity & developability, and comprehensive reports).

## Quickstart

### 1) Smoke test (no dependencies)
```bash
# Install Nextflow (requires Java 11+)
curl -s https://get.nextflow.io | bash
./nextflow run workflows/main.nf -stub-run -profile standard
```

This will create a full `results/` tree and a minimal `report/report.html` using sample data.

### 2) Real run (with Conda envs)
```bash
./nextflow run workflows/main.nf   -params-file configs/params.example.yaml   -profile conda,local   -with-report -with-trace -with-timeline
```

For **HPC** use `-profile conda,slurm`; for **containers** use `-profile docker` or `-profile singularity` (provide images).

## Inputs

- `data/antigen.pdb` (**or** `antigen.fasta` if using AF2/ABodyBuilder2)
- `data/heavy.fasta`, `data/light.fasta`
- `data/hla_ii_common.txt` (HLA-II allele list for immunogenicity scans)

## Key outputs
- `models/ab_model.pdb` – antibody structure
- `docking/best_complex.pdb` – top docked antibody–antigen complex
- `md/trajectory.xtc` & `md/equilibrated.tpr` – MD products
- `mmgbsa/summary.csv` – ΔE_VDW, ΔE_EEL, ΔE_GB, ΔE_SURF, ΔG_TOTAL
- `mutscan/ddg.csv` – ranked single-point mutations (ΔΔG)
- `immuno/immunogenicity.csv` – predicted HLA-II binders
- `developability/metrics.csv` – aggregation/pI/hydrophobicity heuristics
- `report/report.html` – consolidated HTML report

## Project structure
```
antibody-design-pipeline/
├─ data/                      # demo inputs (replace with your own)
├─ workflows/                 # main Nextflow workflow
├─ modules/                   # one process per stage (DSL2 modules)
├─ envs/                      # per-module conda envs (pinned)
├─ configs/                   # nextflow & profile configs
├─ scripts/                   # helper scripts (report generator)
├─ results/                   # populated at runtime
└─ .github/workflows/         # optional CI (stub-run)
```

## Notes
- By default, processes include a **`stub:`** section so you can run `-stub-run` for CI and onboarding.
- Real commands are provided **commented out** inside each process; un-comment once your environments are ready.
- You can swap Conda for containers by adding digests and switching the profile.

---

*Updated on 2025-08-30.*