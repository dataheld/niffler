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
      hello_app()
      )
      }
      \dontrun{
      # launch the app
      hello_app()
      }
      } 

# screenshots fail according to `strict` setting

    Code
      suppressMessages(get_screenshot_from_app(counter_button_app(), name = "does_not_exist"))
    Output
      The screenshot could not be generated.Please check the logs for errors.

