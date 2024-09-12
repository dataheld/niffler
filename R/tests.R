skip_if_load_all2 <- purrr::partial(
  elf::skip_if_pkg_installed_but_not_via_loadall,
  name = "niffler"
)
