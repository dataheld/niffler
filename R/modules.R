#' Helper to stop if input is or is not a reactive
#' @inheritParams shiny::is.reactive
#' @family modules
#' @export
abort_if_reactive <- function(x) {
  if (shiny::is.reactive(x)) {
    rlang::abort("Input must not be reactive.")
  }
}

#' @rdname abort_if_reactive
#' @export
abort_if_not_reactive <- function(x) {
  if (!shiny::is.reactive(x)) {
    rlang::abort("Input must be reactive.")
  }
}
