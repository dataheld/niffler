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
