# BarKit Intel: experimental Sonoma build

This branch is an unofficial Intel experiment derived from Vorssaint under GPL-3.0-or-later.
Upstream is https://github.com/vorssaint/vorssaint-utils. Keep its copyright and license notices.
The experiment is not an official release or a claim of full Intel/OCLP compatibility.

The `Intel Sonoma build` workflow compiles on GitHub's `macos-15-intel` runner with Xcode 16.2,
for `x86_64-apple-macosx14.0`. No Swift compilation is required on the user's laptop.
The main app is not launched by the workflow. Download the `BarKit-Intel-Sonoma` artifact,
extract its inner ZIP, and launch `BarKit Intel.app` locally.

The executable, bundle ID (`io.github.rus-ip.barkit-intel.dev`) and procedural icon are separate
from upstream. The `.dev` identity disables upstream's automatic and manual self-updates,
so the experiment cannot overwrite itself with an ARM-only official release.
Signing is ad hoc; it is not notarized. System permissions are optional and are not granted by
this workflow. The protected fan helper cannot authenticate against the upstream Developer ID,
so protected fan control must not be considered supported by this experiment.

For local startup evidence, set `BARKIT_LAUNCH_REPORT` to an absolute JSON file path before
launching the app executable. After 10 seconds the app records its own menu bar item and window
state, version, source commit and PID. The report is local and contains no clipboard or user-file
contents. Run the bundled executable with `--selftest` for the upstream health check.
