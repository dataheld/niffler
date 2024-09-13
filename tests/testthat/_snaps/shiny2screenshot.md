# roxy_tag_nifflerExamplesShiny: can be parsed

    Code
      roxygen2::parse_text(example)[[1]]$tags
    Output
      [[1]]
      [<text>:  1] @title 'An example documentation for a shiny app' {parsed}
      
      [[2]]
      [<text>:  2] @nifflerExamplesShiny '...' {parsed}
      
      [[3]]
      [<text>:  4] @usage '<generated>' {parsed}
      
      [[4]]
      [<text>:  4] @.formals '<generated>' {unparsed}
      
      [[5]]
      [<text>:  4] @backref '<generated>' {parsed}
      

# roxy_tag_nifflerExamplesShiny: can be formatted

    Code
      topic$get_section("examples")
    Output
      \examples{
      \dontshow{
      # automatically inserted screenshot
      get_screenshot_from_app(
      counter_button_app()
      )
      }
      \dontrun{
      # launch the app
      counter_button_app()
      }
      } 

# screenshots fail according to `strict` setting

    Code
      get_screenshot_from_app("does_not_exist")
    Message
      Error: `app_dir` must be an existing directory
      i Received: "does_not_exist"
      
      
      i You can inspect the failed AppDriver object via `rlang::last_error()$app`
      i AppDriver logs:
      {shinytest2} R info 12:58:54.14 Start AppDriver initialization
      {shinytest2} R info 12:58:54.14 Starting Shiny app
      {shinytest2} R info 12:58:54.15 Error while initializing AppDriver:
                                      `app_dir` must be an existing directory
                                      i Received: "does_not_exist"
      
      
      Caused by error in `app_set_dir()`:
      ! `app_dir` must be an existing directory
      i Received: "does_not_exist"
    Output
      The screenshot could not be generated.Please check the logs for errors.

