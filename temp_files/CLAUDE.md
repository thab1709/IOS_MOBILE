# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**evnmobile** is a Flutter mobile application for electrical power grid management and inspection. It supports three distinct operational modules within a single APK, selectable at runtime based on configuration.

- **Flutter Version**: 3.7.12 (managed via FVM)
- **Dart SDK**: >=2.7.0 <3.0.0
- **State Management**: GetX (v4.6.5)
- **Package Name**: com.example.evnmobile

## Build & Development Commands

### Flutter Version Management
```bash
# The project uses FVM to lock Flutter version
fvm use 3.7.12
fvm flutter [command]  # Use this prefix for all flutter commands
```

### Common Commands
```bash
# Get dependencies
fvm flutter pub get

# Run the app (debug mode)
fvm flutter run

# Build APK (release)
fvm flutter build apk --release

# Build App Bundle
fvm flutter build appbundle --release

# Run linter
fvm flutter analyze

# Clean build artifacts
fvm flutter clean
```

### Android Signing
The app uses release signing configured via `android/key.properties` (not in repo). Required properties:
- `storeFile`: Path to keystore (upload-keystore.jks exists in root)
- `storePassword`, `keyPassword`, `keyAlias`

### Running Tests
```bash
# No test suite is currently configured in this project
# Tests would run with: fvm flutter test
```

## Architecture

### Multi-Module Structure

The app supports three distinct business modules, selected at runtime via `AppShared.instance.getAppType()`:

1. **HTLD** (`lib/src/htld/`) - Power Grid Daily Inspection
   - Periodic inspection planning and ticket management
   - Equipment checklists for substations and lines

2. **HTDCT** (`lib/src/htdct/`) - Power Grid Daily/Night Check Testing
   - Transformer and line testing workflows
   - Equipment testing by category (capacitors, cutting machines, etc.)
   - Test plan logging and abnormal alerts

3. **QLTNKD** (`lib/src/qltnkd/`) - Verification Reports & Quality Control
   - Report creation and approval workflows
   - Workload/work request distribution
   - Offline-first with sync capability

**Common shared code**: `lib/src/app_common/` (authentication, networking, utilities)

### State Management Pattern

**GetX** is used throughout with the following conventions:

```dart
// Controllers extend GetxController
class ExampleController extends GetxController {
  final data = ModelClass().obs;  // Observable reactive variables
  final count = 0.obs;
  RxBool isLoading = false.obs;
}

// Bindings for dependency injection
class ExampleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExampleController>(() => ExampleController());
  }
}

// Tagged instances for multiple controllers
Get.put(controller, tag: 'uniqueTag');
final controller = Get.find<ExampleController>(tag: 'uniqueTag');
```

### Navigation

All routes defined in `lib/routes.dart` as static constants and GetX pages:

```dart
// Navigation examples
Get.toNamed(Routes.ticketScreen, arguments: {'id': ticketId});
Get.until((route) => route.settings.name == Routes.homeDCT);
Get.to(() => ScreenWidget());
```

Module-specific routes are prefixed (e.g., `/homeDCT`, `/reportMain`, `/ticketScreen`).

### Data Layer Architecture

**Networking** (`lib/src/app_common/networking/api_provider.dart`):
- Singleton `ApiProvider.shared` for all HTTP requests
- Bearer token auto-injection from `AppShared.instance.token`
- Methods: `get()`, `post()`, `put()`, `delete()`, multipart upload
- Progress HUD shown by default (disable with `backgroundMode: true`)
- Timeout: 360 seconds

**Local Persistence**:
1. **SharedPreferences** - `AppShared` singleton for auth/user data
2. **Hive** - Offline data storage for work queues, reports, equipment
   - Initialized in `main.dart`: `await LocalDataManager.shared.initHive()`
   - Database boxes: `RDatabaseBoxName.listWork`, `.listReport`, etc.

**Repository Pattern**:
Each module has repositories handling all API/data operations:
- HTDCT: `TransformerRepository`, `LineRepository`, `TestPlanRepository`
- QLTNKD: `ReportRepository`, `WorkloadRepository`, `CertificateRepository`
- HTLD: `TicketRepository`, `InspectionRepository`

### Offline Support & Synchronization

**Critical for QLTNKD module:**

```dart
// Sync manager monitors connectivity
RSyncManager.instance  // Singleton initialized in main.dart

// When connection restored, auto-sync triggered
doAutoSync()  // Syncs pending reports, work data, images
```

Network monitoring in `app.dart` listens to connectivity changes and triggers sync when transitioning offline → online.

**Data flow**:
1. User fills forms offline → Saved to Hive
2. Network detected → `RSyncManager.doAutoSync()` triggered
3. Pending data uploaded, local cache updated
4. UI notified via GetX observables

### Firebase Integration

**Services configured:**
- **Firebase Messaging**: Push notifications with background handler
- **Firebase Crashlytics**: Error tracking (automatic via `FlutterError.onError`)
- **Firebase Analytics**: Event tracking

**Notification Deep Linking** (`app.dart`):
- Background handler: `_firebaseMessagingBackgroundHandler`
- Notification payload parsed and routes to appropriate screens
- Types: `'report'`, `'feed_back'` with module-specific handling

## Code Style & Linting

Strict linting enforced via `analysis_options.yaml` (based on `package:pedantic`):

**Key rules:**
- Prefer `const` constructors and final fields
- Avoid print statements (use debugPrint or logging)
- Always declare return types
- Prefer collection literals
- No unnecessary `new` or `this` keywords

**Run linter before commits:**
```bash
fvm flutter analyze
```

## Project-Specific Patterns

### Model Serialization
Models typically include:
```dart
class ExampleModel {
  factory ExampleModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### UI Loading States
Use `ProgressHUD` for loading indicators:
```dart
ProgressHUD.show();
// ... async operation
ProgressHUD.dismiss();
```

### Error Handling
Network errors handled in `ApiProvider` with automatic user-facing dialogs. Repository methods return data or throw exceptions caught by controllers.

### Image Handling
- **WeChat Assets Picker** (`wechat_assets_picker` - custom fork in `/wechat_assets_picker`)
- **Image Picker** for camera/gallery access
- Images compressed via `flutter_native_image` before upload

### Location Services
Background location tracking for field operations (used in HTLD/HTDCT modules):
```dart
LocationBackgroundService  // Initialized in module screens
```

## Module Entry Points

- **HTLD**: Home screen at `lib/src/htld/screens/home/home.dart`
- **HTDCT**: Home screen at `lib/src/htdct/screens/home/home.dart`
- **QLTNKD**: Report main at `lib/src/qltnkd/screens/verification_report/report_main.dart`

App initialization in `main.dart` determines which module to display based on stored `AppType`.

## Important Files

- `lib/main.dart` - App initialization, Firebase setup, error handling
- `lib/app.dart` - Root widget, navigation, notification handling, connectivity monitoring
- `lib/routes.dart` - All route definitions and GetX page bindings
- `lib/src/app_common/shared/app_shared.dart` - Global app state singleton
- `lib/src/app_common/networking/api_provider.dart` - HTTP client wrapper

## Common Gotchas

1. **Always use FVM prefix** for Flutter commands due to version lock (3.7.12)
2. **GetX tags are critical** for multiple controller instances - check for existing tags before creating new ones
3. **Background mode for API calls** - Set `backgroundMode: true` to prevent progress dialogs during auto-sync
4. **Module-specific SharedPreferences** - Each module has its own (`AppShared`, `MAppShared`)
5. **Offline sync only works for QLTNKD** - HTLD/HTDCT use different data persistence strategies
6. **Firebase config required** - `google-services.json` must be present in `android/app/`
