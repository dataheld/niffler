source_pef <- function(...) {
  rlang::check_installed("elf")
  elf::source_pef(..., package = "niffler")
}

#' Example shiny apps
#'
#' These are the example apps shipping with shiny as `shiny.appobj`.
#' Also shows screenshot in documentation.
#' @nifflerExamplesShiny
#' examples_app()
#' @inheritParams shiny::runExample
#' @family documentation
#' @export
examples_app <- function(example = "01_hello") {
  # library calls and others make noise
  res <- suppressMessages(
    source(fs::path_package("shiny", "examples-shiny", example, "app.R"))
  )
  res$value
}

skip_if_load_all2 <- function() {
  elf::skip_if_pkg_installed_but_not_via_loadall("niffler")
}
