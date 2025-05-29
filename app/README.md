# ConnectMyTask - Flutter Frontend

ConnectMyTask is a task outsourcing mobile application built with Flutter. It enables users to post tasks, receive bids from service providers, manage assignments, and communicate via in-app messaging. This README provides detailed guidance for setup, configuration, and usage of the frontend.

---

## Features

* User and Provider Registration/Login
* Multi-step Task Posting Flow
* Browse and Filter Tasks
* Submit and Manage Bids
* Real-time Chat (via WebSockets)
* Notification Center with Push and In-App Alerts
* Profile Drawer and Settings
* Multi-language support (English, Lao, Thai)

---

## Prerequisites

Ensure the following are installed:

* [Flutter SDK 3.x](https://flutter.dev/docs/get-started/install)
* Dart 2.19 or higher
* Android Studio or VSCode
* A physical Android device or emulator
* Xcode (optional for iOS testing)
* An iOS Simulator (optional for iOS testing)

---

## Getting Started

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd connectmytask
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase (if using FCM for push notifications)

* Place your `google-services.json` in `android/app/`
* Ensure Firebase is set up and FCM enabled

### 4. Run the application

```bash
flutter run
```

### 5. Build APK

```bash
flutter build apk --release
```

APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

---

## 🧩 Folder Structure

```
lib/
├── image/                     # Logos, badges, icons (PNG, SVG)
│   ├── connectmytask_logo.png
│   ├── Bronze.png / Gold.png / Platinum.png / Silver.png
│   ├── login.svg / task.svg / mytask.svg / notification.svg / message.svg
├── model/                    # Data models
│   ├── bid.dart / task.dart / user.dart / Review.dart
│   ├── chat_message.dart / chat_preview.dart / local_notifications.dart
│   └── Location.dart
├── translation/              # Localization files
│   ├── en.json / lo.json / th.json
├── utils/                    # Utility classes and services
│   ├── auth_service.dart / task_service.dart / review_service.dart
│   ├── chat_service.dart / socket_service.dart / firebase_service.dart
│   ├── connection_helper.dart / location_input.dart
│   ├── global_country_map.dart / theme_notifier.dart / voice_service.dart
│   └── task_card_helpers.dart
├── widget/                   # UI screens and components
│   ├── login/                # Login & registration widgets
│   ├── browse_task/          # Browsing UI
│   ├── bid/                  # Offer-related components
│   ├── notification/         # Notification screen components
│   ├── my_task/
│   │   ├── mytask_card.dart / myTask_details.dart / provider_task_detail.dart
│   ├── screen/
│   │   ├── splash_screen.dart / post_task.dart / login.dart / profile_screen.dart
│   │   ├── edit_task_screen.dart / mytask_screen.dart / chat_screen.dart
│   │   ├── messages.dart / browsetask_screen.dart / map_screen.dart
│   ├── task_detail/          # Task detail views
│   ├── drawer_menu.dart
│   ├── filter_sorting_task.dart
│   ├── top_bar.dart / bottom_bar.dart
├── main.dart                 # App entry point
```

---

## 🔐 Authentication

* Supports login via email and password
* Separate user roles: `user` and `provider`
* Uses JWT token stored in SharedPreferences
* Auto-redirect via SplashScreen

---

## 📡 API Integration

The frontend interacts with a Node.js backend via REST APIs. Key services include:

* `TaskService` — fetch, create, update tasks and offers
* `AuthService` — user registration and login
* `FirebaseService` — FCM setup and message handling
* `ChatService`, `SocketService` — for real-time messaging

Endpoints are hardcoded in `utils/` files. Adjust URLs as needed for deployment.

---

## 🔔 Notifications

* Uses Firebase Cloud Messaging (FCM) for push
* In-app display with `local_notifications.dart`
* Stored in `SharedPreferences` for persistent display

---

## 🌍 Localization

* Supports English, Lao, and Thai via `easy_localization`
* Translation files:

  * `translation/en.json`
  * `translation/lo.json`
  * `translation/th.json`
* Switching via `language_setting.dart`

---

## 🧪 Testing Checklist

| Feature        | Expected Outcome                           |
| -------------- | ------------------------------------------ |
| Login/Register | Navigates to home screen                   |
| Post Task      | Creates new task with 5-step form          |
| Browse Task    | Loads tasks, tap opens details             |
| Make Offer     | Bottom modal for price & time input        |
| My Tasks       | Lists posted or assigned tasks             |
| View Bids      | Lists all bids on a task                   |
| Accept Bid     | Confirms and assigns task                  |
| Chat           | Loads messages, allows real-time messaging |
| Notifications  | Displays push and in-app alerts            |

---

## 📸 Assets

Ensure the following are present in `lib/image/`:

* `connectmytask_logo.png`
* Badges: `Bronze.png`, `Silver.png`, `Gold.png`, `Platinum.png`
* Icons: `login.svg`, `task.svg`, `mytask.svg`, `message.svg`, `notification.svg`

Declare them in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - lib/image/
```

---

## 🧹 Notes for Handover

* API base URL: Update in `auth_service.dart`, `task_service.dart`, etc.
* Make sure `google-services.json` is included in `android/app/`
* Clean up debug prints and unused imports
* Deliver as zipped package: `source code + build APK + README`

---

## 🧑‍💻 Contact

For any issues or queries during deployment or testing, please contact:

**Developer:** Chidpasong Nandavong
**Email:** [chidpasong@example.com](mailto:chidpasong@example.com)
**Project:** Swinburne University – ConnectMyTask

---

Thank you for using ConnectMyTask! 🎉
