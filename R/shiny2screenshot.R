#' Tags for documenting shiny apps with screenshots
#'
#' Provides new roxygen2 tags to add screenshots to shiny app documentation.
#'
#' @details
#' Because starting a shiny app does not return,
#' it cannot be included as an `#' @examples`,
#' or must wrapped in `\dontrun`.
#' But for quick reference, a screenshot or gif of a shiny app
#' are still helpful for the reader of your documentation.
#'
#' @keywords documentation tags
#'
#' @name tag_shiny
NULL

# nifflerExamplesShiny tag ====

#' @rdname tag_shiny
#' @details
#' - `@nifflerExamplesShiny${1:# example code}`
#'    R code which returns a shiny app.
#'    A screenshot of the shiny app is added to the documentation,
#'    along with the code required to create the screenshot and
#'    launch the app interactively.
#'    Wraps @examples.
#' @usage
#' # @nifflerExamplesShiny${1:# example code}
#' @name nifflerExamplesShiny
NULL

#' @exportS3Method roxygen2::roxy_tag_parse
roxy_tag_parse.roxy_tag_nifflerExamplesShiny <- function(x) {
  check_installed_roxygen2()
  roxygen2::tag_examples(x)
}

#' @exportS3Method roxygen2::roxy_tag_rd
roxy_tag_rd.roxy_tag_nifflerExamplesShiny <- function(x, base_path, env) {
  call <- x[["val"]]
  x[["val"]] <- paste(
    "\\dontshow{",
    "# automatically inserted screenshot",
    "get_screenshot_from_app(",
    call,
    ")",
    "}",
    "\\dontrun{",
    "# launch the app",
    call,
    "}",
    sep = "\n"
  )
  roxygen2::rd_section("examples", x$val)
}

check_installed_roxygen2 <- function() {
  rlang::check_installed(
    "roxygen2",
    reason = "roxygen2 is needed for extended documentation of shiny apps."
  )
}

check_installed_shinytest2 <- function() {
  rlang::check_installed(
    "shinytest2",
    reason = "shinytest2 is needed to create screenshots of shiny apps."
  )
}

# TODO add link to snapshot-reuse function
# https://github.com/dataheld/niffler/issues/13.
#' Get screenshot from shiny app
#'
#' Wrapper around [shinytest2::AppDriver()].
#' Shows only the shiny app at launch.
#' To show interactions with an app, use a different function.
#'
#' @inheritParams shiny::runApp
#' @param screenshot_args
#' Passed to [`shinytest2::AppDriver`]'s `$new()` method.
#' @param name
#' If the shiny app is developed inside a package (recommended),
#' the name of that package.
#' The screenshot is created using the (last)
#' *installed* (not `pkgload::load_all()`d) version of that package.
#' When the name is provided,
#' the function can test whether it is using
#' the installed version of that package,
#' to avoid confusion (recommended).
#' @param strict
#' Should the function error out,
#' when the various conditions for creating screenshots are not met?
#' To reduce friction during development,
#' the function will default to just issuing a warning.
#' Instead of the screenshot,
#' it then returns the reason for the failure as a string.
#' @param file
#' Path to save the screenshot to; only used for testing.
#' Leave to `NULL`.
#' @examples
#' \dontrun{
#' get_screenshot_from_app(examples_app())
#' }
#' @keywords documentation tags
#' @export
get_screenshot_from_app <- function(appDir,
                                    screenshot_args =
                                      get_screenshot_args_attr(appDir),
                                    name = character(1L),
                                    file = NULL,
                                    strict = FALSE) {
  checkmate::assert_flag(strict)
  f_screenshot <- purrr::partial(
    get_screenshot_from_app_strictly,
    appDir,
    screenshot_args = screenshot_args,
    name = name,
    file = file
  )
  if (!strict) {
    f_screenshot <- purrr::possibly(
      f_screenshot,
      otherwise = {
        glue::glue(
          "The screenshot could not be generated.",
          "Please check the logs for errors.",
          sep = " "
        )
      },
      quiet = FALSE
    )
  }
  f_screenshot()
}

get_screenshot_from_app_strictly <- function(appDir,
                                             screenshot_args,
                                             name,
                                             file) {
  check_installed_shinytest2()
  if (name != character(1L)) {
    elf::assert_pkg_installed_but_not_via_loadall(x = name)
  }
  driver <- shinytest2::AppDriver$new(
    app_dir = appDir,
    screenshot_args = screenshot_args
  )
  withr::defer(driver$stop())
  driver$get_screenshot(file = file)
}
