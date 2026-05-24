# Spec: Hammerspoon Config Opener Action

## Goal

Add a `OpenHammerspoonConfig` action that opens the `~/.hammerspoon` directory
in VS Code, suitable for binding via the existing `Hyper(...)` spec system.

---

## Implementation

Add to `actions.lua`:

```lua
EditConfig = function()
  hs.task.new("/usr/local/bin/code", nil, {"--new-window", os.getenv("HOME") .. "/.hammerspoon"}):start()
end
```

---

## VS Code CLI path

The `code` binary location varies by installation method:

1. `/usr/local/bin/code` — standard installer
2. `/opt/homebrew/bin/code` — Homebrew on Apple Silicon

**Note:** `hs.execute("which code")` does NOT work — Hammerspoon runs with a
stripped PATH that doesn't include `/usr/local/bin`. Hardcode the full path.

---

## Binding

Wire it into your existing Hyper spec:

```lua
Hyper(mod, {
  -- ... existing bindings ...
  {
    key = "H",
    message = "Open Hammerspoon Config",
    fn = OpenHammerspoonConfig
  },
})
```

Key choice `H` is a suggestion — change to whatever fits your layout.

---

## Behavior

- Opens `~/.hammerspoon` as a VS Code workspace in a new window
- If VS Code already has that folder open, `--new-window` forces a fresh
  window rather than focusing an existing one; swap for `--reuse-window` if
  you'd prefer focus behavior
- If the `code` CLI is missing, shows a Hammerspoon alert rather than failing
  silently

---

## Testing checklist

- [ ] Binding fires and opens VS Code
- [ ] `~/.hammerspoon` is the workspace root (visible in VS Code sidebar)
- [ ] Works after `hs.reload()`
- [ ] Alert shows if `code` CLI is not installed or not in PATH
