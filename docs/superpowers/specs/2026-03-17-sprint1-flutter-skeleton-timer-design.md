# Sprint 1 Design Spec: Flutter Web Skeleton + Focus Timer

> Date: 2026-03-17
> Status: Approved
> Prerequisites: Sprint 0 complete (all sprite sheets exported)

---

## 1. Overview

Sprint 1 establishes the Flutter Web project foundation with a working focus timer.
Three steps follow Mock-First methodology: UI & Mock → State & Logic → Firebase Integration.

**Key deliverables:**
- Flutter Web project with full folder structure (CLAUDE.md Section 4.2)
- Home screen with glassmorphism HUD overlay + mock data
- Focus screen with countdown timer + cancel safeguard
- TimerController with 3-tier Grace Period
- Firebase Auth (Google Sign-in) + Firestore integration
- i18n (繁體中文 + English) from day one

---

## 2. Design Decisions

### 2.1 Navigation: Minimal HUD (No Tab Bar)

- Home screen is immersive pixel room with HUD overlay
- Profile (🐭) and Settings (⚙) are glassmorphism icon buttons on HUD bottom row
- Focus screen is a full-screen overlay pushed from Home when START is tapped
- Gacha accessed from profile screen (Sprint 3)
- No bottom navigation bar — preserves Tamagotchi aesthetic

### 2.2 i18n: From Day One

- All UI strings through `AppLocalizations` (flutter_localizations + ARB)
- `l10n/app_en.arb` + `l10n/app_zh_TW.arb`
- Default locale: zh_TW
- No hardcoded user-facing strings in widget code

### 2.3 Checkpoint Strategy: Local-Frequent, Cloud-Sparse (PM Feedback)

**Problem:** Original spec called for 30-second Firestore writes. A 100-min Flow session = 200 writes. At scale this burns Firebase quota fast.

**Solution:**
- **localStorage**: 30-second interval (zero cost, crash recovery)
- **Firestore**: Event-driven + 5-minute background sync
  - Event triggers: `session_start`, `session_complete`, `session_abandon`, `grace_period_penalty`, `visibility_error`
  - Background: every 5 minutes while session active (~20 writes per 100-min session, 10x reduction)
- Recovery priority: Firestore → localStorage → fresh state

**Constants:**
```
localCheckpointSeconds = 30
cloudSyncSeconds = 300
cloudEventTriggers = [session_start, session_complete, session_abandon, grace_period_penalty, visibility_error]
```

### 2.4 Auth Architecture: Web3-Ready (PM Feedback)

**MVP:** Google Sign-in only via Firebase Auth.

**Extensibility for Solana wallet (Phase 2):**
- `AuthRepository` abstract interface — never call Firebase Auth directly from controllers/UI
- Firestore documents keyed by Firebase UID (stable, won't change)
- Future wallet flow: Cloud Function verifies Solana signature → `admin.auth().createCustomToken(walletAddress)` → `signInWithCustomToken`
- Account linking: `linkWithCredential` to bind Google + Wallet to same UID
- `AuthRepository` interface includes `linkProvider()` method placeholder (not implemented in MVP)

```dart
abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> authStateChanges();
  // Phase 2: Web3 wallet linking
  Future<void> linkProvider(AuthCredential credential);
}
```

### 2.5 Focus Cancel Safeguard (PM Feedback)

**Problem:** Accidental cancel on 50/100-min sessions causes massive frustration.

**Solution — tiered by mode:**
- **Short (25 min):** Confirmation dialog — "確定要放棄嗎？已專注 XX 分鐘"
- **Deep / Flow (50/100 min):** Long-press 3 seconds with circular progress indicator (like power-off button). Release cancels the cancel.
- Cancel button positioned at screen edge (top-left), not center
- **Partial reward:** Sessions >80% complete still award proportional rewards if abandoned

---

## 3. Step 1-1: UI & Mock

### 3.1 Project Setup
- `flutter create pixelrats --platforms web`
- pubspec.yaml dependencies:
  - `flame`, `flutter_riverpod`, `riverpod_annotation`, `freezed_annotation`, `json_annotation`
  - `intl` (for i18n)
  - dev: `riverpod_generator`, `build_runner`, `freezed`, `json_serializable`, `flutter_test`
- Full folder structure per CLAUDE.md Section 4.2
- Copy `docs/ui-reference/app_theme.dart` → `lib/utils/app_theme.dart`

### 3.2 Enums (`lib/models/enums.dart`)
```dart
enum FocusMode { short, deep, flow }  // 25, 50, 100 min
enum MoodState { sad, bored, neutral, happy, ecstatic }
enum TrustLevel { stranger, friend, partner, family, soulBond }
enum Rarity { common, rare, epic, legend }
enum RatAnimationState { idle, studying, eating, confused, sad, happy, sleeping, walking }
```

### 3.3 Home Screen (`lib/screens/home_screen.dart`)
- Full-screen Stack layout (mobile-first, 9:19.5 aspect ratio on desktop)
- Background: `AppColors.bgPrimary` solid color placeholder (Flame room in Sprint 2)
- Static rat PNG centered (`assets/sprites/previews/rat_idle.gif` or first frame PNG)
- HUD Overlay (glassmorphism panels):
  - **Top-left:** Cheese counter — 🧀 1,240 (hardcoded)
  - **Top-right:** Mood bar — ❤ 72% "Happy" (hardcoded)
  - **Mid-top center:** Streak 🔥 7 + Trust ⭐ Friend badges (hardcoded)
  - **Bottom:** Timer pills (25/50/100 min, selectable) + START button
  - **Bottom-left:** Profile button (🐭 icon, navigates to placeholder)
  - **Bottom-right:** Settings button (⚙ icon, navigates to placeholder)
- Vignette overlay (radial gradient, cosmetic)

### 3.4 Focus Screen (`lib/screens/focus_screen.dart`)
- Full-screen overlay (pushed route, dark background)
- Countdown timer display (large mm:ss, pixel font)
- Current mode label ("Deep Focus — 50 min")
- Placeholder area for rat animation
- Cancel mechanism:
  - Short mode: icon button → confirmation dialog
  - Deep/Flow mode: long-press button with circular progress (3 sec)
- Session complete → placeholder success overlay (Sprint 3 adds rewards)

### 3.5 i18n Setup
- `l10n.yaml` configuration
- `app_en.arb`: ~20 strings (timer labels, button text, mood states, HUD labels)
- `app_zh_TW.arb`: corresponding Traditional Chinese translations

### 3.6 Commit
```
feat: home screen + focus timer UI with mock data (Sprint 1-1)
```

---

## 4. Step 1-2: State & Logic

### 4.1 TimerController (`lib/controllers/timer_controller.dart`)
- Riverpod `@riverpod` Notifier
- State: `TimerState` (mode, remainingSeconds, isRunning, isPaused, leaveEvents)
- Methods: `start(FocusMode)`, `pause()`, `resume()`, `cancel()`, `tick()`
- Web `visibilitychange` via `package:web` (NOT dart:html)
- 3-tier Grace Period:
  - ≤15s away: no penalty
  - 16-60s away: warning event, rat confused
  - >60s away: penalty event, mood loss = `floor((awaySeconds - 60) / 30) * 2`
- localStorage checkpoint every 30s (leave_time + session state)
- Restore from localStorage on page visible

### 4.2 MockFirestoreRepository
- Implements `FirestoreRepository` interface (CLAUDE.md Section 4.3)
- In-memory Map storage
- Used for all Step 1-2 testing

### 4.3 Unit Tests (per CLAUDE.md Section 6.2)
```
TimerController Tests:
  ✅ 15s return → no penalty, no event
  ✅ 45s return → warning event, rat confused, no mood loss
  ✅ 90s return → penalty event, mood -2
  ✅ 180s return → penalty event, mood -8
  ✅ Multiple leaves accumulate correctly
  ✅ Browser kill → recover leaveTime from localStorage
```

### 4.4 Commit
```
feat: timer controller + grace period logic + tests (Sprint 1-2)
```

---

## 5. Step 1-3: Firebase Integration

### 5.1 Firebase Setup
- Firebase Web project configuration
- Packages: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_remote_config`
- `FirebaseFirestoreRepository` implements `FirestoreRepository`
- `FirebaseAuthRepository` implements `AuthRepository`

### 5.2 Google Sign-in
- Firebase Auth with Google provider
- Auth gate: unauthenticated → sign-in screen, authenticated → home screen
- Simple sign-in screen (Google button + PixelRats logo)

### 5.3 Checkpoint Strategy Implementation
- localStorage: 30-second Timer (existing from 1-2)
- Firestore: event-driven writes (session_start, session_complete, session_abandon, grace_period_penalty)
- Firestore: 5-minute background sync Timer
- Recovery: check Firestore timestamp vs localStorage, use newer

### 5.4 Remote Config
- Load on app start with fallback defaults (CLAUDE.md Section 7 `RCDefaults`)
- Timer-related values only for Sprint 1

### 5.5 Firestore Security Rules
- Deploy rules from CLAUDE.md Section 10

### 5.6 Commit
```
feat: firebase auth + firestore + remote config integration (Sprint 1-3)
```

---

## 6. Out of Scope (Later Sprints)

- Flame engine / pixel room rendering (Sprint 2)
- Rat animation state machine (Sprint 2)
- Accessory overlay system (Sprint 2)
- Mood/Trust calculation (Sprint 3)
- Cheese economy + Gacha (Sprint 3)
- Streak system (Sprint 3)
- White noise / audio (Sprint 2)
- PWA manifest + service worker (Sprint 4+)
- AdSense (Sprint 4+)
- Solana wallet integration (Phase 2)
