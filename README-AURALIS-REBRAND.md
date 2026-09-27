# Auralis (rebranded from Noize) — what changed, what didn't, and why

This is the Noize source (GPL-3.0-or-later, originally by Anand Kumar —
https://github.com/anandssm/noize) with safe, mechanical rebranding applied.
**I have no Flutter/Dart toolchain in the environment that made these edits —
I could not run `flutter analyze` or `flutter build` to verify this.** Every
change below was chosen specifically to minimize compile/runtime risk since I
can't check it myself. You need to run the build (see bottom) and tell me if
anything breaks.

## Changed (low-risk, text/config only)

- **App display name**: `android:label` in `AndroidManifest.xml` → `Auralis`.
  This is what shows under the launcher icon on the phone.
- **All 22 translation files** (`assets/translations/*.json`): every string
  *value* containing "Noize"/"noize" now says "Auralis"/"auralis" — About
  screen, permissions text, OTA update messages, export/import labels, etc.
  Translation **keys** (e.g. `app_name_noize`) were deliberately left
  unchanged, since the Dart code looks strings up by that exact key name —
  renaming the keys without updating every `.tr()` call site across the
  codebase would silently break text lookups. Validated: all 22 files still
  parse as valid JSON after the edit.
- **Default accent color**: `MainScreenColors.skyBlue` in
  `lib/core/constants/app_colors.dart` changed from `#63B8FF` (Noize's blue)
  to `#7250A8` (Auralis's purple). This is the single constant the whole
  default theme derives from.
- **Dart package name**: `pubspec.yaml` `name: noize` → `name: auralis`.
  I checked first — the codebase uses relative imports everywhere except one
  file (`test/widget_test.dart`), which I updated to match
  (`package:noize/...` → `package:auralis/...`).
- **Windows MSIX display name** (irrelevant to the Android APK, but
  consistent): `Noize` → `Auralis`.
- `pubspec.yaml` description string updated, with a line crediting the
  original Noize project — see licensing note below.

## Deliberately NOT changed (higher risk, no user-visible benefit)

- **`applicationId`/`namespace`** in `android/app/build.gradle.kts` (still
  `com.anand.noize`), and the matching Kotlin package
  (`android/app/src/main/kotlin/com/anand/noize/`). Changing this requires
  moving the Kotlin source files to a new folder path *and* updating the
  platform-channel name strings on both the Kotlin side and every Dart
  call site that references them (`com.anand.noize/audio_output`,
  `.../local_songs`, `.../battery_optimization`). A single missed string
  there doesn't fail to compile — it fails silently at runtime (a method
  channel with no matching handler). That's a real risk I can't verify
  without a Flutter toolchain, for a change that's invisible to you as a
  user. If you actually want a different package ID (e.g. to publish it
  separately from Noize on your own device), tell me and I'll do it as its
  own careful, isolated change — not bundled in with everything else.
- **The `NoizeApp` widget class name** in `lib/main.dart` — purely internal,
  zero user-visible effect, no reason to add rename risk for it.
- **App launcher icon** — still Noize's icon. I have no source Auralis icon
  asset to drop in, and generating a full Android adaptive-icon set (multiple
  mipmap densities + XML) isn't something I could verify renders correctly
  without a device/emulator. If you have an icon image, send it and I'll
  wire it in properly.
- **Original author attribution** in the About screen (Anand Kumar,
  github.com/anandssm/noize, GPL-3.0) — left fully intact on purpose.

## Licensing — read this before you distribute this build to anyone else

Noize is **GPL-3.0-or-later**. For your own personal use/sideloading, none of
this matters — modify and run it freely. If you ever share this rebranded
build with *other people* (not just install it on your own phone), GPL
requires: keeping it open source, making the modified source available to
whoever you give the APK to, and not misrepresenting it as entirely your own
original work. The About screen's original-author credit was left in place
specifically to keep you on the right side of that.

(Separately: the in-app "about" text says "Licensed under BSD 3-Clause
License" while the repo's actual `LICENSE` file is GPL-3.0 — that
inconsistency exists in the original Noize source, not something I
introduced.)

## Build it yourself (I can't run this step for you)

```
flutter pub get
flutter build apk --split-per-abi
```

The output APKs land in `build/app/outputs/flutter-apk/`. Install the
`arm64-v8a` one on most modern phones (same architecture as the APK you
originally sent me).

**Tell me exactly what happens** — clean build, or an error — and paste the
error text if any. That confirms whether the rebrand is solid before we add
anything on top of it.
