# no inputs
test_that("works without any inputs", {
  shiny::testServer(
    module2app_server(),
    expect_equal(res, NULL)
  )
  expect_snapshot(module2app_ui())
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "no-funs")
  )
  withr::defer(driver$stop())
  expect_equal(
    driver$get_value(export = "res"),
    NULL
  )
})
# only ui input
test_that("works with only UI input", {
  expect_snapshot(module2app_ui(module_ui = counter_button_ui))
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "only-ui")
  )
  withr::defer(driver$stop())
  driver$expect_text("#test_object-button")
})
