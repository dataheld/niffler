text <- "
  #' A shiny app
  #'
  #' @examplesShiny
  #' shiny::runExample('01_hello')
  f <- function() {
    'lorem'
  }
"
describe("roxy_tag_examplesShiny", {
  it(
    "can be parsed",
    expect_snapshot(roxygen2::parse_text(text)[[1]]$tags)
)
})
