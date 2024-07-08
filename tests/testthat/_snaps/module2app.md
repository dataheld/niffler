# works without any inputs

    Code
      module2app_ui()
    Output
      <div class="container-fluid">
        <h1>
          <code>module2app</code>
          Testbed
        </h1>
        <h2>Reactive Server Arguments</h2>
        <pre class="shiny-text-output noplaceholder" id="server_args_react"></pre>
        <h2>Module UI</h2>
        <div class="bg-info">
          <em>No ui function provided.</em>
        </div>
        <h2>Reactive Server Return Values</h2>
        <pre class="shiny-text-output noplaceholder" id="res"></pre>
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
        <h2>Reactive Server Arguments</h2>
        <pre class="shiny-text-output noplaceholder" id="server_args_react"></pre>
        <h2>Module UI</h2>
        <button id="test_object-button" type="button" class="btn btn-default action-button">Counter</button>
        <pre class="shiny-text-output noplaceholder" id="test_object-out"></pre>
        <h2>Reactive Server Return Values</h2>
        <pre class="shiny-text-output noplaceholder" id="res"></pre>
      </div>

---

    "Counter"

