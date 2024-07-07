#' Show a module in a full app
#'
#' During development of shiny modules,
#' it can be helpful to see and test a module in the context of a shiny app.
#' This function wraps the module UI and server functions in full shiny
#' app for those purposes.
#' You can also pass reactive values to the server function,
#' to observe how your module reacts to them.
#'
#' @details
#' If you only want to test the server logic of a module,
#' you don't need this function.
#' You can just pass the module server function to [shiny::testServer()].
#' Hadley Wickhams Mastering Shiny as a section on
#' [testing modules](https://mastering-shiny.org/scaling-testing.html#modules).
#'
#' @param module_ui,module_server
#' Module functions.
#' @param ui_args,server_args
#' Additional arguments passed to `module_server`and `module_ui`.
#' `server_args` can be [shiny::reactive()]s,
#' if corresponding argument in `module_server` accepts it.
#' @inheritParams shiny::shinyApp
#' @inheritDotParams shiny::shinyApp
#' @export
module2app <- function(module_ui = NULL,
                       module_server = NULL,
                       ui_args = list(),
                       server_args = list(),
                       options = list(test.mode = TRUE),
                       ...) {
  shiny::shinyApp(
    ui = module2app_ui(module_ui, ui_args),
    server = module2app_server(module_server, server_args),
    options = options,
    ...
  )
}

#' @describeIn module2app UI
#' @export
module2app_ui <- function(module_ui = NULL, ui_args = list()) {
  checkmate::assert_function(module_ui, args = c("id"), null.ok = TRUE)
  if (is.null(module_ui)) module_ui <- no_fun_provided_ui
  checkmate::assert_list(ui_args)
  module_ui <- purrr::partial(module_ui, !!!ui_args)
  ui_wrapper(
    shiny::h1(shiny::code("module2app"), "Testbed"),
    shiny::h2("Reactive Server Arguments"),
    shiny::verbatimTextOutput("server_args_react"),
    shiny::h2("Module UI"),
    module_ui(id = "test"),
    shiny::h2("Reactive Server Return Values"),
    shiny::verbatimTextOutput("res"),
    title = "module2app"
  )
}

ui_wrapper <- function(...) {
  shiny::basicPage(...)
}

#' @describeIn module2app Server
#' @export
module2app_server <- function(module_server = NULL, server_args = list()) {
  checkmate::assert_function(module_server, args = c("id"), null.ok = TRUE)
  if (is.null(module_server)) module_server <- no_fun_provided_server
  checkmate::assert_list(server_args)
  module_server <- purrr::partial(module_server, !!!server_args)
  function(input, output, session) {
    output$server_args_react <- shiny::renderPrint(
      filter_react_els(server_args)
    )
    module_res <- module_server("test")
    res <- shiny::reactive(exec_tree_of_reacs(module_res))
    output$res <- shiny::renderPrint(res())
    shiny::exportTestValues(res = res())
  }
}

filter_react_els <- function(x = list()) {
  x[purrr::map_lgl(x, shiny::is.reactive)]
}

no_fun_provided_ui <- function(id, x = "ui") {
  shiny::NS(id) # unused
  shiny::tagList(shiny::p(no_fun_provided_glue(x)))
}

no_fun_provided_server <- function(id, x = "server") {
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {
      shiny::reactive(no_fun_provided_glue(x))
    }
  )
}

no_fun_provided_glue <- function(x) glue::glue("No {x} function provided.")

exec_tree_of_reacs <- function(.x) {
  purrr::modify_tree(.x, leaf = rlang::exec)
}
