# you can provide your own ui wrapper with partialised arguments
if (elf::is_installed2("bslib")) {
  # current bootstrap theme via bslib
  theme <- bslib::bs_theme(version = 5)
  ui_wrapper <- purrr::partial(shiny::bootstrapPage, theme = theme)
}
