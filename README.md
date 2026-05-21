# FluxPay — Global Remittance & FX Exchange Platform

FluxPay is a production-inspired fintech Flutter application built as part of an advanced engineering assessment focused on architecture, scalability, state management, UI craftsmanship, and real-world fintech workflows.

The application simulates a modern remittance and foreign exchange experience inspired by platforms such as Wise, Revolut, and Stripe.

---

# Features

## Live Exchange Rate Dashboard

* Real-time FX exchange flow
* Dynamic currency conversion
* Reverse calculation support
* Live fluctuation simulation
* Dynamic fee calculation engine
* Rate expiry handling
* Currency swap animation
* Precision-safe currency calculations

## Premium Fintech UI

* Modern fintech-inspired design system
* Glassmorphism and gradient styling
* Animated transitions and micro-interactions
* Dark mode support
* Responsive layouts
* Premium dashboard experience

## Beneficiary Management

* Add/manage beneficiaries
* Duplicate detection
* Dynamic form validation
* Country and bank metadata support
* Recent transfer indicators

## Transaction Timeline

* Offline persistence using Hive
* Transaction grouping by date
* Search and smart filtering
* Status tracking:

  * Pending
  * Processing
  * Completed
  * Failed
  * Refunded

## Security & Session Management

* PIN lock
* Biometric authentication
* Secure storage integration
* Session restoration flow
* App lock handling
* Sensitive data masking

## Realtime FX Simulation

* Simulated live exchange fluctuations
* Stream-based rate updates
* Responsive UI updates

## Analytics Dashboard

* Fintech-style analytics widgets
* Transaction visualizations
* Dashboard KPI cards
* Graph-based summaries

Analytics data is currently simulated for assignment scope while maintaining scalable architecture for future backend integration.

---

# Architecture

FluxPay follows a scalable feature-first architecture using BLoC and repository pattern principles.

## Core Architecture Decisions

* flutter_bloc for state management
* Repository pattern
* Dependency Injection using GetIt
* Feature modularization
* Separation of:

  * UI
  * Business Logic
  * Data Layer
  * Services
  * Networking

## Folder Structure

```text
lib/
├── app/
├── core/
├── features/
│   ├── auth/
│   ├── exchange/
│   ├── beneficiaries/
│   ├── transactions/
│   ├── analytics/
│   ├── settings/
│   └── splash/
└── injection_container.dart
└── main.dart
```

---

# State Management

FluxPay uses flutter_bloc for:

* predictable state flow
* rebuild optimization
* async event handling
* feature isolation
* scalable business logic

Important flows implemented:

* Authentication lifecycle
* Session restoration
* App lock/unlock
* Exchange calculation flow
* Transaction filtering/pagination
* Settings persistence

---

# Networking

## Exchange Rate API

FluxPay integrates with:

* Frankfurter API
* https://www.frankfurter.app

The API is used for:

* currency conversion
* live exchange rates
* rate refresh handling

---

# Local Persistence

FluxPay uses:

* Hive for offline transaction persistence
* Flutter Secure Storage for security-sensitive data

Persisted data includes:

* transactions
* settings
* auth session metadata
* security preferences

---

# Security

Implemented security mechanisms:

* PIN authentication
* Biometric authentication
* App lock handling
* Secure token/session storage
* Sensitive information masking

---

# Performance Optimizations

Implemented optimizations include:

* Bloc rebuild minimization
* BlocSelector usage
* Lazy list rendering
* Pagination-ready transaction architecture
* Const widget optimization
* Reduced unnecessary widget rebuilds

---

# UI/UX Focus

Special focus was placed on:

* fintech-inspired polish
* animation smoothness
* spacing consistency
* typography hierarchy
* responsive layouts
* dark mode experience

---

# Engineering Tradeoffs

## Analytics

Analytics currently uses simulated data for assignment scope while maintaining extensible architecture for future backend aggregation.

## Websocket Simulation

Local stream simulation was used instead of a real websocket implementation to prioritize stability and deterministic UI behavior.

## Token Refresh Architecture

Interceptor/token refresh scaffolding was initially explored but removed to avoid introducing unnecessary incomplete authentication complexity for the current assignment scope.

---

# Known Limitations

* No backend authentication server
* Simulated analytics data
* Simulated live FX fluctuations
* No production payment gateway integration
* No multi-user backend synchronization

---

# Packages Used

## State Management

* flutter_bloc

## Networking

* dio

## Dependency Injection

* get_it

## Local Storage

* hive
* hive_flutter

## Security

* flutter_secure_storage
* local_auth

## Utilities

* equatable
* connectivity_plus

---
# How To Run

## 1. Clone Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

Example:

```bash
git clone https://github.com/yourusername/fluxpay.git
```

---

## 2. Navigate Into Project

```bash
cd fluxpay
```

---

## 3. Install Dependencies

```bash
flutter pub get
```

---

## 4. Run Code Generation (If Required)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 5. Run Application

```bash
flutter run
```

---

# Recommended Flutter Version

```text
Flutter 3.22+
Dart 3+
```

---

# Tested Platforms

* Android
* iOS (UI compatible)
* Emulator & Physical Devices

---

# Build APK

```bash
flutter build apk
```

---

# Build Release APK

```bash
flutter build apk --release
```

---

# Walkthrough

A 3–5 minute walkthrough video is included covering:

* architecture decisions
* feature flows
* state management
* security handling
* engineering tradeoffs

---

# Final Notes

FluxPay was developed with a strong emphasis on:

* production-style architecture
* maintainability
* UI quality
* engineering discipline
* scalable feature organization

The project intentionally prioritizes architectural quality and stability over excessive feature expansion.
