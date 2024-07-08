# you can pass in
# - reactive and non-reactive values to the server function and
# - non-reactive values to the ui function
module2app(
  module_ui = counter_button_ui,
  module_server = counter_button_server,
  ui_args = list(label = "Double Counter"),
  server_args = list(set_to = 100L, increment_by = shiny::reactiveVal(2L))
)
