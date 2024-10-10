describe("roxy_tag_nifflerExamplesShiny", {
  example <- brio::read_file(
    fs::path_package(
      package = "niffler",
      "examples", "shiny2screenshot", "example", ext = "R"
    )
  )
  it(
    "can be parsed",
    expect_snapshot(roxygen2::parse_text(example)[[1]]$tags)
  )
  it(
    "can be formatted",
    {
      topic <- roxygen2::roc_proc_text(roxygen2::rd_roclet(), example)[[1]]
      expect_snapshot(topic$get_section("examples"))
    }
  )
})
# these should use boring counter_button_app, not examples_app,
# because they're in this package and don't change
# upstream change from shiny examples could break screenshots
describe("get_screenshot_from_app", {
  name <- "counter.png"
  announce_snapshot_file(name = name)
  skip_if_load_all2()
  path <- withr::local_tempfile(fileext = ".png")
  it(
    "can record a screenshot",
    {
      get_screenshot_from_app(counter_button_app(), file = path)
      expect_snapshot_file(
        path = path,
        name = name,
        variant = shinytest2::platform_variant(r_version = FALSE)
      )
    }
  )
})

test_that("screenshots fail according to `strict` setting", {
  expect_equal(
    # messages must be supressed,
    # otherwise snapshot gets polluted with timestamps
    suppressMessages(
      get_screenshot_from_app(counter_button_app(), name = "does_not_exist")
    ),
    # oddly, a snapshot doesn't work here,
    # but keeps getting deleted/re-added
    glue::glue(
      "The screenshot could not be generated.",
      "Please check the logs for errors.",
      .sep = " "
    )
  )
  expect_error(
    get_screenshot_from_app(
      counter_button_app(),
      name = "does_not_exist",
      strict = TRUE
    )
  )
})

describe("dir_ls_snaps", {
  variant <- shinytest2::platform_variant(r_version = FALSE)
  it("finds named snaps", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      name = "bins",
      variant = variant,
      strictly_numbered = FALSE
    )
    expect_snapshot(snaps, variant = variant)
  })
})
