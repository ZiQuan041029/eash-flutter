# eash (Flutter app)

A local-first Flutter bookstore demo app that mimics a real mobile/web app flow without backend services.

## Features

- Local persistence with `Hive` (books, profile, favorites, cart, orders, session state)
- Mock auth flow (login/register/logout)
- Onboarding flow (first launch)
- Product catalog with search, filter, and sort
- Product CRUD simulation (manage products)
- Favorites and cart
- Checkout simulation with order creation
- Mock API delays and optional API error simulation mode
- Local image assets saved in this repo

---

## Tech Stack

- Flutter `3.29.0`
- Dart `3.7.0`
- `go_router`
- `hive_flutter`

> Recommended: Flutter/Dart versions close to the above for consistent behavior.

---

## New developer setup

Use this after Flutter is installed and available in terminal (`flutter --version` succeeds).

### 1) Clone the repository

```bash
git clone <your-repo-url>
cd eash-flutter
```

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Verify project health

```bash
flutter analyze
flutter test
```

### 4) Run the app

```bash
flutter run -d chrome
```

If `flutter` is not recognized, install Flutter and add it to `PATH` (see **Environment Setup** below).

---

## Quick Start

```bash
git clone <your-repo-url>
cd <repo-folder>
flutter pub get
flutter run -d chrome
```

---

## Environment Setup

## macOS Setup

### 1) Install Flutter SDK

Use one of these options:

- Install via [Flutter docs](https://docs.flutter.dev/get-started/install/macos)
- Or download and extract manually, then add `flutter/bin` to `PATH`

Example `~/.zshrc` entry:

```bash
export PATH="/path/to/flutter/bin:$PATH"
```

Reload shell:

```bash
source ~/.zshrc
```

### 2) Verify installation

```bash
flutter --version
dart --version
flutter doctor -v
```

### 3) Optional platform tools

- For iOS/macOS apps: install Xcode and CocoaPods
- For Android apps: install Android Studio + Android SDK
- On Apple Silicon, Flutter may require Rosetta for some tooling:

```bash
sudo softwareupdate --install-rosetta --agree-to-license
```

---

## Windows Setup

### 1) Install Flutter SDK

Follow [Flutter Windows install](https://docs.flutter.dev/get-started/install/windows):

- Download Flutter SDK zip
- Extract to a stable path (example: `C:\src\flutter`)
- Add `C:\src\flutter\bin` to your system `Path`

### 2) Verify installation

Open a new PowerShell and run:

```powershell
flutter --version
dart --version
flutter doctor -v
```

### 3) Optional platform tools

- For Android: install Android Studio + SDK
- For Windows desktop app support: install Visual Studio (Desktop development with C++)

---

## Run the App

From project root (after **`flutter pub get`**):

```bash
flutter run -d chrome
```

Other useful targets:

```bash
flutter devices
flutter run -d macos      # macOS only
flutter run -d windows    # Windows only
flutter run -d android    # if Android SDK/device is available
```

---

## Development Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

---

## Project Structure (High Level)

```text
lib/
  core/
    data/      # seed/mock data
    models/    # app models
    state/     # app state + persistence logic
  features/
    auth/
    catalog/
    cart/
    favorites/
    orders/
    onboarding/
    profile/
  routes/
  shared/
assets/images/  # local image assets used by mock data
```

---

## Troubleshooting

- **`flutter analyze` or `flutter test` fails**
  - Run `flutter doctor -v` and fix anything marked as missing (web target needs Chrome for `flutter run -d chrome`).
- `flutter: command not found`
  - Ensure Flutter is installed and `flutter/bin` is in `PATH`
  - Restart terminal/IDE after updating `PATH`

- `Doctor found issues`
  - Run `flutter doctor -v` and complete missing toolchains
  - Web (`-d chrome`) can run even if mobile toolchains are incomplete

- App changes not reflected
  - Press `R` (hot restart) in running terminal
  - Or stop and rerun `flutter run -d chrome`

---

## Notes

- This app intentionally uses local mock data and simulated latency.
- No backend services are required.

---

