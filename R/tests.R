#' Skip test if not running under shinytest2 conditions
#'
#' Some tests cannot run via [pkgload::load_all()].
#' This includes shinytest2, which always uses the *installed* variant
#' of a package.
#' This ensures that tests such as shinytest2 are never run when a package
#' is merely `load_all()`ed, but not currently running from the installed
#' version.
#' @inheritParams pkgload::is_dev_package
#' @family test helpers
#' @export
skip_if_load_all <- function(name) {
  if (pkgload::is_dev_package(name = name)) {
    testthat::skip(
      "skipping because package is just `load_all()`ed, not installed."
    )
  }
}
skip_if_load_all2 <- purrr::partial(skip_if_load_all, name = "niffler")
