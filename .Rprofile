local({
  snapshot_date <- "2024-11-24"
  message("Setting PPM snapshot date to ", snapshot_date, "...")
  # TODO use pak::repo_add here for cross-platform support
  # currently blocked by https://github.com/r-lib/pak/issues/644
  options(
    repos = c(
      CRAN = paste0(
        "https://packagemanager.posit.co/cran/__linux__/noble/",
        snapshot_date
      )
    )
  )
  if (file.exists("~/.Rprofile") && getwd() != Sys.getenv("HOME")) {
    message(
      "Also found user `.Rprofile`, loading ..."
    )
    source("~/.Rprofile")
  }
})
