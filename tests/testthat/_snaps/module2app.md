# works without any inputs

    Code
      module2app_ui()
    Output
      <div class="container-fluid">
        <h1>
          <code>module2app</code>
          Testbed
        </h1>
        <h2>Server Input Arguments</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-eval"></pre>
        <h2>Module UI</h2>
        <div id="crow-module2app-module-ui">
          <div class="bg-info">
            <em>No ui function provided.</em>
          </div>
        </div>
        <h2>Server Return Values</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="returns-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="returns-eval"></pre>
      </div>

# works with only UI input

    Code
      module2app_ui(module_ui = counter_button_ui)
    Output
      <div class="container-fluid">
        <h1>
          <code>module2app</code>
          Testbed
        </h1>
        <h2>Server Input Arguments</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-eval"></pre>
        <h2>Module UI</h2>
        <div id="crow-module2app-module-ui">
          <button id="test_object-button" type="button" class="btn btn-default action-button">Counter</button>
          <pre class="shiny-text-output noplaceholder" id="test_object-out"></pre>
        </div>
        <h2>Server Return Values</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="returns-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="returns-eval"></pre>
      </div>

---

    "Counter"

# works with `shiny.tag` returns (workaround)

    Code
      driver$get_value(output = "inputs-eval")
    Output
      <!--@generated-->
      [1] "$bar\n[1] 1\n\n$zap\ncharacter(0)"

# works with S3-classed return

    Code
      driver$get_value(output = "inputs-eval")
    Output
      <!--@generated-->
      [1] "$zap\n[1] \"<svg xmlns=\\\"http://www.w3.org/2000/svg\\\" viewBox=\\\"0 0 16 16\\\" class=\\\"bi bi-heart \\\" style=\\\"height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;\\\" aria-hidden=\\\"true\\\" role=\\\"img\\\" ><path d=\\\"m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z\\\"></path></svg>\"\nattr(,\"html\")\n[1] TRUE\nattr(,\"browsable_html\")\n[1] TRUE"

# works with nested modules and deep returns

    "$increment_by\n[1] 1\n\n$count_by\n[1] 2\n\n$a_non_reactive_return\n[1] \"just for testing\"\n\n$deeper_copy_of_increment_by\n$deeper_copy_of_increment_by$increment_by\n[1] 1\n"

# works with bs5

    Code
      module2app_ui(module_ui = counter_button_ui, ui_wrapper = source_pef(
        "module2app", "ui", "bootstrap"))
    Output
      <h1>
        <code>module2app</code>
        Testbed
      </h1>
      <h2>Server Input Arguments</h2>
      <h3>Unevaluated</h3>
      <pre class="shiny-text-output noplaceholder" id="inputs-unev"></pre>
      <h3>Evaluated</h3>
      <pre class="shiny-text-output noplaceholder" id="inputs-eval"></pre>
      <h2>Module UI</h2>
      <div id="crow-module2app-module-ui">
        <button id="test_object-button" type="button" class="btn btn-default action-button">Counter</button>
        <pre class="shiny-text-output noplaceholder" id="test_object-out"></pre>
      </div>
      <h2>Server Return Values</h2>
      <h3>Unevaluated</h3>
      <pre class="shiny-text-output noplaceholder" id="returns-unev"></pre>
      <h3>Evaluated</h3>
      <pre class="shiny-text-output noplaceholder" id="returns-eval"></pre>

