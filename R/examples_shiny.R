#' Tag to print a screenshot of a shiny app
#' @inheritParams roxygen2::roxy_tag_parse
#' @keywords shiny documentation functions
#' @exportS3Method roxygen2::roxy_tag_parse
roxy_tag_parse.roxy_tag_examplesShiny <- function(x) {
  check_installed_roxygen2()
  # TODO assert that x is a shiny app, etc.
  x[["val"]] <- paste0(
    "\\dontshow{",
    x[["val"]],
    "}",
    "\\dontrun{",
    x[["val"]],
    "}"
  )
  roxygen2::tag_examples(x)
}

check_installed_roxygen2 <- function() {
  rlang::check_installed(
    "roxygen2",
    reason = "roxygen2 is needed for extended documentation of shiny apps."
  )
}
