// workflows/main.nf
nextflow.enable.dsl=2

include { NUMB }     from '../modules/01_number_anarci.nf'
include { IGFOLD }   from '../modules/02_model_igfold.nf'
include { DOCK }     from '../modules/03_complex_lightdock.nf'
include { MD }       from '../modules/04_md_gromacs.nf'
include { MMGBSA }   from '../modules/05_mmgbsa.nf'
include { MUTSCAN }  from '../modules/06_mutscan_ddg.nf'
include { IMMUNO }   from '../modules/07_immunogenicity.nf'
include { DEV }      from '../modules/08_developability.nf'
include { REPORT }   from '../modules/09_report.nf'

workflow {
  Channel
    .fromPath(params.antigen)
    .set { antigen_ch }

  Channel
    .fromPath(params.heavy)
    .set { heavy_ch }

  Channel
    .fromPath(params.light)
    .set { light_ch }

  Channel
    .fromPath(params.hla_list)
    .set { hla_ch }

  pair_ch = heavy_ch.combine(light_ch)

  // 1) Numbering
  NUMB(pair_ch)

  // 2) Modeling
  IGFOLD(NUMB.out[0], NUMB.out[1], NUMB.out[2])

  // 3) Docking
  DOCK(IGFOLD.out[0], antigen_ch)

  // 4) MD simulation
  MD(DOCK.out[0])

  // 5) MM/GBSA
  MMGBSA(MD.out[0], MD.out[1])

  // 6) Affinity maturation (virtual mutagenesis)
  MUTSCAN(IGFOLD.out[0], antigen_ch, DOCK.out[1])

  // 7) Immunogenicity
  IMMUNO(NUMB.out[2], hla_ch)

  // 8) Developability
  DEV(IGFOLD.out[0])

  // 9) Report
  REPORT(MMGBSA.out[0], MD.out[2], MUTSCAN.out[0], IMMUNO.out[0], DEV.out[0])
}