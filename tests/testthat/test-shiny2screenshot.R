variant <- shinytest2::platform_variant(r_version = FALSE)

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
# unnecessary wrapper, but otherwise skip has global scope,
# see #32
test_that("get_screenshot_works", {
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
          variant = variant
        )
      }
    )
  })
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

describe("roxy_tag_nifflerInsertSnaps", {
  example <- brio::read_file(
    fs::path_package(
      package = "niffler",
      "examples", "snaps2man", "example", ext = "R"
    )
  )
  it(
    "can be parsed",
    expect_snapshot(roxygen2::parse_text(example)[[1]]$tags)
  )
})

describe("dir_ls_snaps", {
  it("finds manually numbered, named screenshots", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      regexp = glue_regexp_screenshot_files(
        name = "bins",
        auto_numbered = FALSE
      ),
      variant = variant
    )
    expect_snapshot(snaps, variant = variant)
  })
  it("finds automatically numbered, named screenshots", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      regexp = glue_regexp_screenshot_files(
        name = "mpg",
        auto_numbered = FALSE
      ),
      variant = variant
    )
    expect_snapshot(snaps, variant = variant)
  })
  it("finds automatically numbered, unnamed screenshots", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      regexp = glue_regexp_screenshot_files(),
      variant = variant
    )
    expect_snapshot(snaps, variant = variant)
  })
  it("finds non-numbered, named screenshots", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      regexp = glue_regexp_screenshot_files(
        name = "foo",
        auto_numbered = FALSE
      ),
      variant = variant
    )
    expect_snapshot(snaps, variant = variant)
  })
})

describe("map_snaps_animate", {
  it("fails if file is missing", {
    expect_error(map_snaps_animate("i-do-not-exist"))
    expect_error(map_snaps_animate(c("i-do-not-exist", "me-neither")))
  })
  it("reads in single screenshot", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      regexp = glue_regexp_screenshot_files(
        name = "foo",
        auto_numbered = FALSE
      ),
      variant = variant
    )
    path <- withr::local_tempfile()
    testthat::expect_snapshot_file(
      path = image_animate_snaps(snaps) |> image_write_snaps(path = path),
      name = "single.png",
      variant = variant
    )
  })
  it("reads in multiple screenshots", {
    snaps <- dir_ls_snaps(
      test_file = "helpers",
      regexp = glue_regexp_screenshot_files(
        name = "bins",
        auto_numbered = FALSE
      ),
      variant = variant
    )
    path <- withr::local_tempfile()
    testthat::expect_snapshot_file(
      path = image_animate_snaps(snaps) |> image_write_snaps(path = path),
      name = "multiple.gif",
      variant = variant
    )
  })
})

describe("snaps2man", {
  it("writes out snapshots to man folder", {
    output_path <- "man/figures/niffler_screenshots/helpers/bins.gif"
    withr::defer(fs::file_delete(output_path))
    res <- snaps2man(
      test_file = "helpers",
      name = "bins",
      auto_numbered = FALSE,
      variant = variant
    )
    checkmate::expect_file_exists(
      "man/figures/niffler_screenshots/helpers/bins.gif"
    )
    expect_equal(
      res,
      fs::path("niffler_screenshots", "helpers", "bins", ext = "gif")
    )
  })
})
