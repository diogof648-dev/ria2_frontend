# RIA2 Frontend

Flutter frontend for the RIA2 project. The app fetches a widget catalog from a backend API and opens each selected widget inside an in-app WebView.

## What This App Does

- Loads available widgets from the backend.
- Displays widgets in a simple list.
- Fetches the selected widget URL on demand.
- Embeds the target page in a WebView.
- Handles loading and error states with retry actions.

## Tech Stack

- Flutter (Material UI)
- Provider (dependency injection and state wiring)
- HTTP package (REST calls)
- webview_flutter (embedded browser)
- Mockito + flutter_test (unit testing)

## Architecture Overview

The app follows a simple layered flow:

1. UI (`Home`, `WidgetEmbedPage`) reacts to `WidgetViewModel`.
2. `WidgetViewModel` coordinates loading and selection state.
3. `WidgetRepository` abstracts data access.
4. `WidgetService` performs HTTP calls.

Key folders:

- `lib/pages`: Screens.
- `lib/viewmodels`: UI state and presentation logic.
- `lib/repositories`: Repository abstraction.
- `lib/services`: HTTP integration.
- `lib/models`: Domain models.
- `lib/core/di`: Provider registration.
- `lib/widgets`: Reusable UI components.
- `test/services`: Service unit tests.

## API Contract

The app expects these backend endpoints:

### `GET /widgets`

Returns a JSON object where keys are widget IDs and values are widget names.

Example:

```json
{
	"abc": "Clock",
	"def": "Weather"
}
```

### `GET /widgets/:id`

Returns a JSON string with the widget embed URL.

Example:

```json
"https://example.com/widget/abc"
```

## Prerequisites

- Flutter SDK compatible with Dart `^3.10.8`
- Android Studio (for Android builds/emulator)
- Xcode (for iOS builds on macOS)

Verify your environment:

```bash
flutter doctor
```

## Setup

Install dependencies:

```bash
flutter pub get
```

## Configuration

The API base URL is injected at compile time using `--dart-define`.

Required define:

- `API_BASE_URL`: backend base URL (for example `https://api.example.com`)

If missing, API calls will fail because the app will use an empty base URL.

## Run The App

### Android / iOS

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Testing

Run all tests:

```bash
flutter test
```

Generate/update Mockito mocks if test annotations change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Build

### Android APK (release)

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
```

### iOS (release)

```bash
flutter build ios --release --dart-define=API_BASE_URL=https://api.example.com
```

## Notes And Known Constraints

- The domain model class is named `Widget` and should be imported with an alias in non-UI layers to avoid conflicts with Flutter's `Widget` type.
- `EmbedWebView` accepts only valid URLs with a scheme and host.
- Android WebView mixed content mode is explicitly enabled.

## Troubleshooting

- Empty list or request failures:
	- Confirm `API_BASE_URL` is set and reachable from the device/emulator.
- Build issues after dependency updates:
	- Run `flutter clean && flutter pub get`.
- Failing tests due to stale mocks:
	- Re-run `build_runner` command shown above.


