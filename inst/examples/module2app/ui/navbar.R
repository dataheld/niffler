# ui wrapper with a custom function
ui_wrapper <- function(...) {
  shiny::navbarPage(
    shiny::tabPanel(title = "A Panel", ...),
    title = "Testbed with Navbar"
  )
}
