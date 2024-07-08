test_that("works without any inputs", {
  shiny::testServer(module2app_server(), expect_equal(res, NULL))
  expect_snapshot(module2app_ui())
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "no-funs")
  )
  withr::defer(driver$stop())
  expect_equal(driver$get_value(export = "res"), NULL)
})
test_that("works with only UI input", {
  expect_snapshot(module2app_ui(module_ui = counter_button_ui))
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "only-ui")
  )
  withr::defer(driver$stop())
  driver$expect_text("#test_object-button")
})
test_that("works with only server input", {
  shiny::testServer(
    module2app_server(module_server = counter_button_server),
    expect_equal(res(), 0)
  )
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "only-server")
  )
  withr::defer(driver$stop())
  expect_equal(driver$get_value(export = "res"), 0)
})
test_that("works with both inputs", {
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "both-funs")
  )
  withr::defer(driver$stop())
  expect_equal(driver$get_value(output = "res"), capture.output(print(0)))
  driver$click(selector = "#test_object-button")
  expect_equal(driver$get_value(output = "res"), capture.output(print(1)))
})
