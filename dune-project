(lang dune 3.7)

(name advent_of_code_2024)
(version 0.1.0)

(generate_opam_files true)

(source
 (github BIRSAx2/advent_of_code_2024))

(authors "BIRSAx2")

(maintainers "BIRSAx2")

(license BSD-3-Clause)

(documentation https://github.com/BIRSAx2/advent_of_code_2024)

(package
 (name advent_of_code_2024)
 (synopsis "OCaml Advent of Code 2024")
 (depends
  ocaml
  reason
  dune
  (cmdliner(>= 1.2.0))
  (piaf (>= 0.2.0))
  (fmt (>= 0.9.0)))
 (tags ("advent-of-code")))
