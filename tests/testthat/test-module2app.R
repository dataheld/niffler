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
test_that("works with arguments to ui and server", {
  increment_by <- shiny::reactiveVal(4L)
  shiny::testServer(
    app = module2app_server(
      module_server = counter_button_server,
      server_args = list(set_to = 10, increment_by = increment_by)
    ),
    expr = {
      expect_equal(res(), 10)
      session$setInputs(`test_object-button` = 1)
      expect_equal(res(), 14)
      # changing reactive input here
      increment_by(1L)
      session$setInputs(`test_object-button` = 2)
      expect_equal(res(), 15)
    }
  )
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "simple", "args")
  )
  withr::defer(driver$stop())
  expect_equal(driver$get_value(output = "res"), capture.output(print(100)))
  driver$click(selector = "#test_object-button")
  expect_equal(driver$get_value(output = "res"), capture.output(print(102)))
})
test_that("works with nested modules", {
  shiny::testServer(
    module2app_server(x_counter_button_server),
    expr = {
      expect_equal(res(), 2)
      session$setInputs(`test_object-set_count-button` = 1)
      expect_equal(res(), 3)
      session$setInputs(`test_object-set_increment-button` = 1)
      session$setInputs(`test_object-set_count-button` = 1)
      expect_equal(res(), 5)
    }
  )
})
