test_that("module2app server works without server", {
  shiny::testServer(
    module2app_server(),
    expect_equal(res, NULL)
  )
})
test_that("module2app works with only ui module", {
  expect_snapshot(module2app_ui())
})
test_that("module2app works without inputs", {
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "no-funs")
  )
  expect_equal(
    driver$get_value(export = "res"),
    NULL
  )
  withr::defer(driver$stop())
})
