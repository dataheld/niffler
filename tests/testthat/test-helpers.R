# this need not actually be tested;
# but the test results, in turn, can be used as screenshot examples
test_that("example app for multiple, named screenshots", {
  bins <- 20:30
  purrr::walk(
    bins,
    function(bin) testthat::announce_snapshot_file(glue::glue("bins-{bin}.png"))
  )
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    examples_app(),
    variant = shinytest2::platform_variant(r_version = FALSE)
  )
  purrr::walk(
    bins,
    function(bin) {
      driver$set_inputs(bins = bin)
      driver$expect_screenshot(name = glue::glue("bins-{bin}.png"))
    }
  )
})
test_that("example app for single, named screenshots", {
  announce_snapshot_file("mpg-001.png")
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    examples_app("04_mpg"),
    name = "mpg",
    variant = shinytest2::platform_variant(r_version = FALSE)
  )
  driver$expect_screenshot()
})
test_that("example app for multiple, unnamed screenshots", {
  announce_snapshot_file("001.png")
  announce_snapshot_file("002.png")
  skip_if_load_all2()
  driver <- shinytest2::AppDriver$new(
    examples_app("05_sliders"),
    variant = shinytest2::platform_variant(r_version = FALSE)
  )
  driver$expect_screenshot()
  driver$expect_screenshot()
})
