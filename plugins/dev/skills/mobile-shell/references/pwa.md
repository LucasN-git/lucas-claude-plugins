# Installed app

What makes the installed app feel installed, without taking anything from the browser user.

## Viewport, status bar, inputs

- `width=device-width, initial-scale=1, viewport-fit=cover`. No `maximum-scale`, no `user-scalable=no`: zoom stays allowed.
- iOS status bar `black-translucent`; the header keeps room with safe-area padding on top.
- Every input has body-size text (16 px) below the breakpoint: iOS zooms on focusing smaller text and stays zoomed. A field that is compact on the desktop drops a size only above the breakpoint.
- Theme colour comes from the token mirror, per colour scheme; never a literal in the manifest or meta.
- Standalone detection runs in an inline critical script before hydration and sets attributes on `<html>` (standalone, platform), so the first paint already knows.
- The browser's view-transition API stays off: its two full-page snapshots stutter on phones, and the page transition needs only transform and opacity.

## Safe areas

`env(safe-area-inset-*)` on header, bar and sheets. Under `display-mode: standalone` a floor of 8 px on top and bottom for devices without a home indicator.

## Service worker

Hand-written, no library. It precaches only the shell: brand files, manifest and an offline page; user data never enters a browser cache. Navigations go network-first with the offline page as fallback. Changing a precached file or the list bumps the cache name. A new worker takes over at once and the page reloads exactly once: not on the first install and not during input. No update dialog.

## Splash

Only in standalone mode, never on Android (it brings its own splash with the finished icon). It leaves when the app is usable, and reduced motion shows the finished mark at once.

## Prompts

Install, push permission and any other invitation share one rule: at most one shows at a time, at the earliest 6 s after load, never on first paint, dismissible and remembered. The install prompt has its own layer between overlay and sheet.

## Touch above the breakpoint

A touch device above the breakpoint starts with the wide sidebar: nothing hovers there to slide the rail out (`dev:desktop-shell`, `layout.md`).
