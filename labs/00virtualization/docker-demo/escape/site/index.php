<?php
// ============================================================================
// S617 LAB - DELIBERATELY VULNERABLE WEB APP.  For the workshop lab ONLY.
// ============================================================================
// This page is a "web shell": it runs whatever shell command you put in ?cmd=.
// It exists to demonstrate how a vulnerable app leads to a container escape.
//
// NEVER write code like this in real life, and NEVER run it anywhere but your
// own disposable lab VM. Passing user input to system() is remote code
// execution, full stop.
// ============================================================================
?>
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>S617 Vulnerable App</title>
<style>
  body{font-family:ui-monospace,Menlo,Consolas,monospace;background:#0b0f14;
       color:#e6edf3;max-width:800px;margin:2rem auto;padding:0 1rem}
  h1{color:#58a6ff} pre{background:#0d1117;border:1px solid #30363d;
       border-radius:8px;padding:1rem;overflow:auto;color:#3fb950}
  code{color:#d2a8ff}
</style></head>
<body>
  <h1>S617 - Intentionally Vulnerable App</h1>
  <p>This app runs a command for you. Try <code>?cmd=id</code> in the URL.</p>
<?php
if (isset($_GET['cmd'])) {
    echo "<p>Running: <code>" . htmlspecialchars($_GET['cmd']) . "</code></p>";
    echo "<pre>";
    system($_GET['cmd']);   // <-- the vulnerability: user input -> shell
    echo "</pre>";
}
?>
</body>
</html>
