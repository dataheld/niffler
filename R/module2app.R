# module2app helper ====

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
    module_ui(id = "test_object"),
    shiny::h2("Reactive Server Return Values"),
    shiny::verbatimTextOutput("res")
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
      exec_tree_of_reacs(filter_react_els(server_args))
    )
    res <- notify_non_reactive_returns(module_server(id = "test_object"))
    if (shiny::is.reactive(res)) {
      shiny::exportTestValues(res = res())
      output$res <- shiny::renderPrint(exec_tree_of_reacs(res))
    } else {
      shiny::exportTestValues(res = res)
    }
  }
}

notify_non_reactive_returns <- function(x) {
  if (!shiny::is.reactive(x)) {
    shiny::showNotification(
      shiny::tags$h5("Module server had a non-reactive return value."),
      shiny::p(
        "Non-reactive return values are allowed, but are not shown here."
      ),
      duration = NULL,
      type = "message"
    )
    shiny::reactive(NULL)
  }
  x
}

filter_react_els <- function(x = list()) {
  x[purrr::map_lgl(x, shiny::is.reactive)]
}

no_fun_provided_ui <- function(id, x = "ui") {
  shiny::NS(id) # unused
  shiny::tagList(
    shiny::div(
      shiny::tags$em(no_fun_provided_glue(x)),
      class = "bg-info"
    )
  )
}

no_fun_provided_server <- function(id, x = "server") {
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {
      shiny::showNotification(
        shiny::tags$h5(no_fun_provided_glue(x)),
        duration = NULL,
        id = id
      )
      # above, confusingly, returns the ID as a string instead of NULL
      NULL
    }
  )
}

no_fun_provided_glue <- function(x) glue::glue("No {x} function provided.")

exec_tree_of_reacs <- function(.x) {
  purrr::modify_tree(
    .x,
    is_node = function(x) !(shiny::is.reactive(x)),
    leaf = rlang::exec
  )
}

# test modules =====

# taken from shiny docs https://shiny.posit.co/r/articles/improve/modules/

#' Counter Button
#' @keywords internal
#' @name counter_button
NULL

#' @describeIn counter_button Test app
#' @inheritDotParams module2app
counter_button_app <- function(...) {
  module2app(
    module_ui = counter_button_ui,
    module_server = counter_button_server,
    ...
  )
}

#' @describeIn counter_button Module UI
#' @inheritParams shiny::NS
#' @inheritParams shiny::actionButton
#' @export
counter_button_ui <- function(id, label = "Counter") {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::actionButton(ns("button"), label = label),
    shiny::verbatimTextOutput(ns("out"))
  )
}

#' @describeIn counter_button Module Server
#' @param set_to
#' A reactive, giving the value to set the counter to.
#' @param increment_by
#' Increment of the count.
#' @export
counter_button_server <- function(id,
                                  set_to = 0L,
                                  increment_by = shiny::reactiveVal(1L)) {
  abort_if_reactive(set_to)
  abort_if_not_reactive(increment_by)
  shiny::moduleServer(
    id,
    function(input, output, session) {
      count <- shiny::reactiveVal(set_to)
      shiny::observeEvent(input$button, {
        count(count() + increment_by())
      })
      output$out <- shiny::renderText({
        count()
      })
      count
    }
  )
}
