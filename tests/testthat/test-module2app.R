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
  expect_equal(
    driver$get_value(output = "returns-eval"),
    capture.output(print(0))
  )
  driver$click(selector = "#test_object-button")
  expect_equal(
    driver$get_value(output = "returns-eval"),
    capture.output(print(1))
  )
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
  expect_equal(
    driver$get_value(output = "returns-eval"),
    capture.output(print(100))
  )
  driver$click(selector = "#test_object-button")
  expect_equal(
    driver$get_value(output = "returns-eval"),
    capture.output(print(102))
  )
})
test_that("works with nested modules and flat returns", {
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
test_that("works with nested modules and deep returns", {
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    source_pef("module2app", "nested", "deep")
  )
  withr::defer(driver$stop())
  driver$expect_text("#returns-eval")
  # changing increment does not work in test,
  # probably because of needed sleep or something
})
test_that("works with bs5", {
  expect_snapshot(
    # navbar is not a good example, because it has random tab ids
    module2app_ui(
      module_ui = counter_button_ui,
      ui_wrapper = source_pef("module2app", "ui", "bootstrap")
    )
  )
})
correct_attr <- list(selector = paste0("#", inner_module_id))
test_that("returns attribute with dom selector", {
  expect_equal(
    attr(module2app(counter_button_ui), "niffler_screenshot_args"),
    correct_attr
  )
})
test_that("screenshot args attribute can be retrieved", {
  expect_equal(
    get_screenshot_args_attr(module2app(counter_button_ui)),
    correct_attr
  )
})
test_that("app without niffler args returns missing arg", {
  expect_equal(get_screenshot_args_attr(examples_app()), rlang::missing_arg())
})
test_that("absence and presence of niffler attrs can be found", {
  expect_true(has_niffler_attrs(counter_button_app()))
  expect_false(has_niffler_attrs(examples_app()))
})
