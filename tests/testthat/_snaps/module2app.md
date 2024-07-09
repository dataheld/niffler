# works without any inputs

    Code
      module2app_ui()
    Output
      <div class="container-fluid">
        <h1>
          <code>module2app</code>
          Testbed
        </h1>
        <h2>Server Arguments</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-eval"></pre>
        <h2>Module UI</h2>
        <div class="bg-info">
          <em>No ui function provided.</em>
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
        <h2>Server Arguments</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="inputs-eval"></pre>
        <h2>Module UI</h2>
        <button id="test_object-button" type="button" class="btn btn-default action-button">Counter</button>
        <pre class="shiny-text-output noplaceholder" id="test_object-out"></pre>
        <h2>Server Return Values</h2>
        <h3>Unevaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="returns-unev"></pre>
        <h3>Evaluated</h3>
        <pre class="shiny-text-output noplaceholder" id="returns-eval"></pre>
      </div>

---

    "Counter"

# works with nested modules and deep returns

    "$increment_by\n[1] 1\n\n$count_by\n[1] 2\n\n$a_non_reactive_return\n[1] \"just for testing\"\n\n$deeper_copy_of_increment_by\n$deeper_copy_of_increment_by$increment_by\n[1] 1\n"

