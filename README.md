**Version:** 1.0.7  
**Last Updated:** May 29, 2025


# ConnectMyTask - Flutter Frontend
A Flutter-based mobile application for outsourcing tasks, connecting users with service providers.

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

* [Flutter SDK 3.29.3](https://flutter.dev/docs/get-started/install)
* Dart 3.7.2 or higher
* VSCode
* A physical Android device or emulator

---

## Getting Started

### 1. Clone the repository and switch to the dev branch

```bash
git clone https://github.com/MattNandavong/TAP-ConnectMyTask.git
cd connectmytask
git checkout dev
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

## Folder Structure

```bash
lib/
├── image/                       # Logos, badges, icons (PNG, SVG)
│   ├── connectmytask_logo.png
│   ├── Bronze.png
│   ├── Gold.png
│   ├── Platinum.png
│   ├── Silver.png
│   ├── login.svg
│   ├── task.svg
│   ├── mytask.svg
│   ├── notification.svg
│   └── message.svg
├── model/                       # Data models
│   ├── bid.dart
│   ├── chat_message.dart
│   ├── chat_preview.dart
│   ├── local_notifications.dart
│   ├── Location.dart
│   ├── Review.dart
│   ├── task.dart
│   └── user.dart
├── translation/                 # Localization files
│   ├── en.json
│   ├── lo.json
│   └── th.json
├── utils/                       # Utility classes and services
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── connection_helper.dart
│   ├── firebase_service.dart
│   ├── global_country_map.dart
│   ├── location_input.dart
│   ├── review_service.dart
│   ├── socket_service.dart
│   ├── task_card_helpers.dart
│   ├── task_service.dart
│   ├── theme_notifier.dart
│   └── voice_service.dart
├── widget/                      # UI components and feature screens
│   ├── bid/
│   ├── browse_task/
│   ├── login/
│   ├── my_task/
│   │   ├── mytask_card.dart
│   │   ├── myTask_details.dart
│   │   └── provider_task_detail.dart
│   ├── notification/
│   ├── screen/
│   │   ├── browsetask_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── edit_task_screen.dart
│   │   ├── language_setting.dart
│   │   ├── login.dart
│   │   ├── map_screen.dart
│   │   ├── messages.dart
│   │   ├── mytask_screen.dart
│   │   ├── post_task.dart
│   │   ├── profile_screen.dart
│   │   └── splash_screen.dart
│   ├── task_detail/
│   ├── drawer_menu.dart
│   ├── filter_sorting_task.dart
│   ├── top_bar.dart
│   └── bottom_bar.dart
├── main.dart                    # App entry point
```


---

## Authentication

* Supports login via email/password and Google Sign-In
* Separate user roles: `user` and `provider`
* Uses JWT token stored in SharedPreferences
* Auto-redirect via SplashScreen

---

## API Integration

The frontend interacts with a Node.js backend via REST APIs. Key services include:

* `TaskService` — fetch, create, update tasks and offers
* `AuthService` — user registration and login
* `FirebaseService` — FCM setup and message handling
* `ChatService`, `SocketService` — for real-time messaging

Endpoints are hardcoded in `utils/` files. Adjust URLs as needed for deployment.

---

## Notifications

* Uses Firebase Cloud Messaging (FCM) for push
* In-app display with `local_notifications.dart`
* Stored in `SharedPreferences` for persistent display

---

## Localization

* Supports English, Lao, and Thai via `easy_localization`
* Translation files:

  * `translation/en.json`
  * `translation/lo.json`
  * `translation/th.json`
* Switching via `language_setting.dart`

---

## Assets

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

### Final Handover Package Includes:
- Flutter source code (in `dev` branch)
- Release APK (`app-release.apk`) download from: https://drive.google.com/drive/folders/1yYi4mHZhUy94wlsVDgIgZRT-B0YMIE7j?usp=drive_link
- Firebase config (`google-services.json`) download from: https://drive.google.com/drive/folders/1yYi4mHZhUy94wlsVDgIgZRT-B0YMIE7j?usp=drive_link
- README documentation (this file)

---

## Contact

For any issues or queries during deployment or testing, please contact:

**Developer:** Chidpasong Nandavong
**Email:** [nandavong1900@gmail.com](mailto:nandavong1900@gmail.com)
**Project:** Swinburne University – ConnectMyTask

---

Thank you for using ConnectMyTask! 

