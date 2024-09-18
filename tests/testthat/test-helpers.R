# this need not actually be tested;
# but the test results, in turn, can be used as screenshot examples
test_that("example app for multiple steps", {
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    examples_app(),
    name = "bins",
    variant = shinytest2::platform_variant(r_version = FALSE)
  )
  purrr::walk(20:30, {
    function(x) {
      driver$set_inputs(bins = x)
      driver$expect_screenshot()
    }
  })
})
test_that("example app for single screenshot", {
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    examples_app("04_mpg"),
    name = "mpg",
    variant = shinytest2::platform_variant(r_version = FALSE)
  )
  driver$expect_screenshot()
})
