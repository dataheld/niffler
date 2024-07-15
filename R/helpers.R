source_pef <- function(...) {
  rlang::check_installed("elf")
  elf::source_pef(..., package = "niffler")
}
