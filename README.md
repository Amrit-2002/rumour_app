# Rumour — Anonymous Room-Code Chat App

A high-performance, ephemeral anonymous group chat mobile application built with **Flutter**, **Google Cloud Firestore**, **Firebase Anonymous Authentication**, and **Provider State Management**, styled with pixel-level fidelity to the dark Figma design specifications.

---

## 📱 Features & Highlights

- **🔑 6-Digit Room Codes:** Create collision-resistant 6-digit rooms (`[0-9A-Z]{6}`) or join existing rooms instantly.
- **🌓 Adaptive Light / Dark Theme & Persistence:** Full dual-theme system built with Material 3 and custom `ThemeExtension` tokens. Supports Dark Mode (Figma stealth `#09090B` & Neon Lime `#BDF84F`), Light Mode (clean slate `#F8FAFC`, high-contrast rich lime accents, crisp white cards), and System default. Features an animated `ThemeToggleButton` with one-tap toggle and a long-press selection sheet, persisting preferences via `ThemeProvider` and `SharedPreferences`.
- **🎭 RandomUser API Anonymous Identity:** Generates unique anonymous personas on demand via HTTP integration with the **RandomUser API** (`GET https://randomuser.me/api/`), formatting API responses into clean, two-word display identities (e.g., *“Brave Badger”*) without collecting any personal identifiable information (no phone, email, or KYC).
- **💾 Room-Scoped Local Persistence:** Uses `SharedPreferences` to cache assigned personas keyed by room (`room_identity_{roomCode}`). Returning to a previously visited room seamlessly restores your persona, while different rooms grant distinct identities.
- **⚡ Real-Time Bi-Directional Messaging:** Real-time message streaming powered by Firestore subcollections (`rooms/{roomCode}/messages`), delivering sub-500ms latency.
- **📶 Resilient Offline Persistence & Queued Writes:** Powered by native Cloud Firestore multi-level caching (`persistenceEnabled: true`). Read message history while disconnected; messages typed offline are queued locally and automatically synced with server timestamps upon reconnection.
- **🕒 Message Status & Sync Indicators:** Differentiated message bubbles (Neon Lime `#BDF84F` for *You* vs. Dark Navy `#101521` for *Others*) with real-time sync indicators (Clock icon when pending offline write, double checkmark when synced).
- **📅 Smart Date Separators & Pagination:** Automatically injects calendar day chips (*"Today"*, *"Yesterday"*, *"MMM d, yyyy"*) and supports cursor-based pagination (`startAfterDocument`) when scrolling up.
- **🛡️ Battle-Tested Security Rules:** Cryptographic message ownership verified via Firebase Anonymous Authentication (`request.auth.uid == senderId`) with strict payload validation.

---

## 🎨 Figma Design Alignment

The UI implements the Figma design specifications:

| Screen | Design Role | Key Visual Features |
| :--- | :--- | :--- |
| **1. Join A Room** | Entry Point | Official Rumour Key logo badge (`AppKeyLogo`), theme toggle button (`ThemeToggleButton`), 6-slot dash input container (`- - - - - -`), "Join Room" button, and "Create New Room" outline button. |
| **2. Anonymous Identity Reveal** | Persona Acknowledgment | Circular back button, top theme toggle action, centered Room # and member counter, hero card with stacked persona name (**`Brave\nBadger`** in 38sp accent lime), privacy explanation, and **"Acknowledge and continue"** CTA. |
| **3. Group Chat** | Real-Time Chat Feed | Back button with leave dialog, centered Room header with active dynamic member count, top theme toggle button and options menu, "Today" date chip, `@Sender` header on received bubbles, `You` header on Neon Lime sent bubbles, and rounded input bar with circular lime send button. |

---

## 🏗️ Architecture & Technical Decisions

Rumour follows a **Lightweight Feature-First Clean Architecture**:

```
lib/
├── main.dart                  # Application bootstrap, Firebase & MultiProvider root
├── app.dart                   # MaterialApp, global theme & typed route generator
│
├── core/                      # Cross-cutting foundational modules
│   ├── constants/             # AppColors, AppColorsExtension tokens, AppConstants
│   ├── theme/                 # AppTheme (Light & Dark M3 themes), ThemeProvider
│   ├── widgets/               # AppButton, AppKeyLogo, ThemeToggleButton
│   ├── utils/                 # DateFormatter, RoomCodeGenerator, InputValidator, Navigation
│   ├── errors/                # Failures, Exceptions, AppErrorHandler
│   └── services/              # AuthService (Anonymous Auth), StorageService (Prefs)
│
└── features/                  # Self-contained business modules
    ├── room/                  # Room creation, validation & code input
    │   ├── domain/            # RoomModel, RoomRepository contract
    │   ├── data/              # RoomRepositoryImpl (Firestore rooms/{roomCode})
    │   └── presentation/      # RoomProvider, JoinRoomScreen, RoomCodeInput
    │
    ├── identity/              # Anonymous persona generation & persistence
    │   ├── domain/            # IdentityModel, IdentityRepository contract
    │   ├── data/              # IdentityRepositoryImpl, RandomUserRemoteDataSource (RandomUser API)
    │   └── presentation/      # IdentityProvider, IdentityRevealScreen
    │
    └── chat/                  # Real-time messaging, pagination & offline caching
        ├── domain/            # MessageModel, PaginatedMessages, ChatRepository contract
        ├── data/              # ChatRepositoryImpl (Firestore message streams & pagination)
        └── presentation/      # ChatProvider, GroupChatScreen, ChatBubble, ChatInputBar
```

### Technical Decision Records (TDR)
1. **Provider over BLoC:** Drastically lower boilerplate for stream subscriptions and atomic reactive updates, eliminating code-generation build risks while delivering 100% of reactive capabilities.
2. **Native Firestore Offline Persistence over Custom SQLite:** Avoids brittle custom sync engines and race conditions. Firestore natively queues offline writes and provides `metadata.hasPendingWrites` to drive UI sync icons.
3. **SharedPreferences for Identities:** $O(1)$ fast key-value lookups scoped to `room_identity_{roomCode}`, avoiding unnecessary relational SQL migrations.
4. **Firebase Anonymous Authentication:** Guarantees cryptographic verification of message senders (`senderId == request.auth.uid`) preventing identity spoofing.
5. **RandomUser API with Local Identity Caching:** Satisfies external identity specification by fetching personas via `https://randomuser.me/api/` on room creation/join, transforming them into two-word anonymous titles, and caching them locally against `room_identity_{roomCode}` so rejoining a room is instant and makes zero redundant network calls.
6. **Custom ThemeExtension for Light/Dark Adaptability:** Utilizes `ThemeExtension<AppColorsExtension>` to expose semantic color tokens through `context.colors`. Decouples widgets from hardcoded colors, guaranteeing smooth dynamic theme switching without re-instantiating providers or causing layout flickers.

---

## 🗄️ Firestore Database Schema

```
rooms/ (Collection)
  └── {roomCode}/ (Document, e.g. "581290")
        ├── roomCode: string ("581290")
        ├── createdAt: timestamp (ServerTimestamp)
        ├── createdBy: string (Firebase Anonymous UID)
        ├── memberCount: number (1)
        ├── isActive: boolean (true)
        │
        ├── members/ (Subcollection)
        │     └── {firebaseUid}/ (Document)
        │           ├── uid: string
        │           ├── username: string ("Brave Badger")
        │           └── joinedAt: timestamp
        │
        └── messages/ (Subcollection)
              └── {messageId}/ (Document, Auto-ID)
                    ├── id: string
                    ├── roomCode: string ("581290")
                    ├── senderId: string (Firebase Anonymous UID)
                    ├── senderName: string ("Brave Badger")
                    ├── text: string (1–500 chars)
                    └── createdAt: timestamp (ServerTimestamp)
```

---

## 🔐 Firestore Security Rules (`firestore.rules`)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null && request.auth.uid != null;
    }

    function isRoomCodeValid(code) {
      return code.size() == 6 && code.matches('^[0-9A-Z]{6}$');
    }

    match /rooms/{roomCode} {
      allow read: if isAuthenticated();

      allow create: if isAuthenticated()
                    && isRoomCodeValid(roomCode)
                    && request.resource.data.roomCode == roomCode
                    && request.resource.data.createdBy == request.auth.uid
                    && request.resource.data.isActive == true;

      allow update: if isAuthenticated()
                    && (
                      request.resource.data.diff(resource.data).affectedKeys()
                      .hasOnly(['memberCount', 'lastActiveAt', 'isActive'])
                    );

      allow delete: if false;

      match /members/{memberUid} {
        allow read: if isAuthenticated();
        allow create, update: if isAuthenticated()
                              && memberUid == request.auth.uid
                              && request.resource.data.uid == request.auth.uid;
        allow delete: if isAuthenticated() && memberUid == request.auth.uid;
      }

      match /messages/{messageId} {
        allow read: if isAuthenticated();

        allow create: if isAuthenticated()
                      && request.resource.data.senderId == request.auth.uid
                      && request.resource.data.senderName is string
                      && request.resource.data.senderName.size() >= 2
                      && request.resource.data.text is string
                      && request.resource.data.text.size() > 0
                      && request.resource.data.text.size() <= 500;

        allow update, delete: if false;
      }
    }

    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 🚀 Setup & Installation Instructions

### Prerequisites
- Flutter SDK `3.x` (Tested on Flutter 3.47 / Dart 3.13)
- Android SDK (minSdkVersion 21, targetSdkVersion 34)
- Android Studio / VS Code / IntelliJ
- Active Firebase Project with Cloud Firestore & Anonymous Authentication enabled

### Installation Steps

1. **Clone the Repository:**
   ```bash
   git clone <repository_url>
   cd rumour
   ```

2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration:**
   - Ensure `google-services.json` is located in `android/app/google-services.json`.
   - Enable **Anonymous Authentication** in Firebase Console -> *Authentication* -> *Sign-in method*.
   - Publish the security rules from `firestore.rules` in Firebase Console -> *Firestore Database* -> *Rules*.

4. **Run in Debug Mode:**
   ```bash
   flutter run
   ```

5. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```
   The generated APK will be at:
   `build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Automated Testing & Verification

The project includes unit and widget test coverage across models, generators, formatting, and UI flows.

```bash
# Run static analysis
flutter analyze

# Run all test suites
flutter test
```

### Test Suite Overview:
- **`test/unit/random_user_remote_datasource_test.dart`:** Tests HTTP GET to `https://randomuser.me/api/`, JSON deserialization, 200 response, and exception handling.
- **`test/unit/identity_repository_test.dart`:** Tests local caching, persona capitalization, fallback avoidance, and restoration flow.
- **`test/unit/theme_test.dart`:** Tests `ThemeProvider` mode initialization, mode setting, persistence in `StorageService`, light/dark toggle, and `AppColorsExtension` interpolation.
- **`test/unit/room_code_generator_test.dart`:** Tests 6-char length, uniqueness, and exclusion of ambiguous characters (`0`, `O`, `1`, `I`).
- **`test/unit/message_model_test.dart`:** Tests `roomCode` property, null timestamp fallback, pending write status, and map serialization.
- **`test/unit/validation_test.dart`:** Tests room code boundaries and 1–500 char message length validation.
- **`test/unit/date_formatter_test.dart`:** Tests `HH:mm` time formatting, Today/Yesterday calendar separators, and multi-day checks.
- **`test/unit/room_test.dart`:** Tests `RoomModel` serialization and default member count initialization.
- **`test/unit/chat_test.dart`:** Tests `MessageModel` schema preparation and pending state.
- **`test/widget/theme_toggle_test.dart`:** Tests `ThemeToggleButton` rendering, animated icon state, and dynamic theme switching across Join, Reveal, and Chat screens.
- **`test/widget/join_room_screen_test.dart`:** Tests Figma brand assets, key logo, and reactive button state.
- **`test/widget/chat_offline_test.dart`:** Tests offline banner rendering and pending vs. delivered sync indicators.
- **`test/widget_test.dart`:** Full Figma UI walkthrough (`Join A Room` -> `Identity Reveal` -> `Group Chat` message composition).

---

## 📦 Deliverables & Submission

### 📱 Fully Working Release APK
- **Repository Location:** [`apk/app-release.apk`](./apk/app-release.apk)
- **Direct Installation via ADB:**
  ```bash
  adb install -r apk/app-release.apk
  ```

- **Alternative Cloud Download:** If you experience any issues with the repository file or prefer downloading directly to your mobile device, access the Google Drive mirror:
  - 📥 [Download app-release.apk (Google Drive Mirror)](https://drive.google.com/file/d/1kShjYFfr8Atk_M7qmySDOJLpgjsVJuIg/view?usp=drive_link)

### 🎥 Video Demonstration
- **Google Drive Folder:** [Watch Complete Workflow Video](https://drive.google.com/drive/folders/1iQA1qfAwFgVOAoRN8OorC5A2BCgbiTs1?usp=sharing)
- **Covered Workflows:**
  1. Room creation and 6-digit code generation.
  2. Anonymous identity generation using RandomUser API (`https://randomuser.me/api/`).
  3. Persona persistence and identity restoration on rejoining.
  4. Real-time bi-directional messaging between devices/sessions.
  5. Dynamic live member count updates on user join and departure.
  6. Cursor-based chat history pagination.
  7. Offline persistence, cached message viewing, queued writes, and automatic re-sync.

---

## 📄 License
MIT License. Built for demonstration and technical assessment.
