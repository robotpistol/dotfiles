# Spec: Hammerspoon Hyperkey Module Refactor

## Goal

Refactor the hyperkey/modal system in `init.lua` into a self-contained module
(`hyperkey.lua`) with the following improvements:

1. Replace `hs.hotkey.bind` trigger bindings with high-priority `hs.eventtap`
   so Hammerspoon wins keyboard races against apps like 1Password that also
   register global shortcuts.
2. Keep the public API (`Hyper(...)` and `Modal(...)`) identical so call sites
   in other files don't need to change.
3. No external spoon dependencies beyond `ModalMgr` (already in use).

---

## File Layout

```
~/.hammerspoon/
├── init.lua          ← require('hyperkey') replaces inline definitions
├── hyperkey.lua      ← new module (all code lives here)
└── actions.lua       ← unchanged
```

---

## Module Interface

The module must export two functions at global scope (to match current usage):

```lua
Hyper(mod, spec)
Modal(mod, modalName, key, spec, options)
FocusApp(appNameOrID)
FocusAppFn(appNameOrID)
```

`FocusApp` / `FocusAppFn` can be moved here too since they're utility helpers
used by the spec tables passed into `Hyper`.

---

## `bindHighPriority(mod, key, fn)` — internal helper

Replace every `hs.hotkey.bind(mod, key, ...)` trigger with this instead:

```lua
-- mod: table of modifier strings e.g. {"cmd", "shift"}
-- key: string e.g. "space"
-- fn:  zero-arg function to call on match
-- returns: the eventtap (caller must keep a reference to prevent GC)
local function bindHighPriority(mod, key, fn)
  local modSet = {}
  for _, m in ipairs(mod) do modSet[m:lower()] = true end

  return hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    local mappedKey = hs.keycodes.map[event:getKeyCode()]

    if mappedKey ~= key:lower() then return false end
    for m, _ in pairs(modSet) do
      if not flags[m] then return false end
    end

    fn()
    return true  -- consume: downstream apps never see this event
  end):start()
end
```

**Important:** store the returned eventtap in a module-level table so it isn't
garbage-collected:

```lua
local _taps = {}  -- keeps eventtaps alive
```

---

## `Hyper(mod, spec)` changes

Current:
```lua
hs.hotkey.bind(mod, binding.key, binding.message or "", binding.fn)
```

New:
```lua
local tap = bindHighPriority(mod, binding.key, binding.fn)
table.insert(_taps, tap)
```

The `binding.message` field is no longer used for hotkey registration but
should be preserved in the spec table for documentation purposes.

Modal sub-entries inside `Hyper` specs still use `Modal(...)` internally —
no change there.

---

## `Modal(mod, modalName, key, spec, options)` changes

Current trigger at the bottom of `Modal`:
```lua
hs.hotkey.bind(mod, key, function() modal.enterHyper() end)
```

New:
```lua
local tap = bindHighPriority(mod, key, function() modal.enterHyper() end)
table.insert(_taps, tap)
```

The internal `modal:bind(...)` calls (escape, Q, tab, custom keys) remain
unchanged — they use ModalMgr's binding system which only activates while the
modal is live, so there's no conflict risk.

---

## `mod` argument convention

The current codebase passes `mod` directly to `hs.hotkey.bind`, which accepts
either a table or a string. `bindHighPriority` requires a **table**. Enforce
this at the top of both `Hyper` and `Modal`:

```lua
if type(mod) == "string" then mod = {mod} end
```

---

## Behavior to preserve exactly

- Modal countdown timer and canvas display
- `modal.resetTimer()` on key press within modal
- `exitHyper()` / `enterHyper()` state guard (`if not modal.active`)
- escape / Q / tab built-in modal bindings
- `options.timeout` and `options.color` defaults

---

## What to remove

- The standalone `hs.hotkey.bind` calls that served as trigger bindings
  (replaced by eventtaps)
- Nothing else — all modal internals stay

---

## Testing checklist

After implementation, verify:

- [ ] Trigger hotkey fires even when 1Password is focused or its shortcut
      overlaps
- [ ] Modal enters and exits cleanly (escape, Q, timeout)
- [ ] Countdown canvas displays and counts down correctly
- [ ] Custom bindings inside modal call their `fn` after exit
- [ ] `FocusApp` / `FocusAppFn` still work from `actions.lua` call sites
- [ ] No "attempt to index a nil value" errors on reload (`hs.reload()`)
- [ ] Eventtaps don't leak — reloading Hammerspoon should not accumulate
      duplicate listeners (verify by checking `hs.eventtap.keyStrokes` count
      or simply reload 3× and confirm behavior is stable)
