# KakiLima Voice Terminal

A production-ready, low-latency mobile client designed for street vendors and small-medium enterprises (SMEs) to facilitate cross-lingual commerce. Built with Flutter, this terminal processes localized automated speech recognition (ASR) and neural machine translation (NMT) entirely on-device, ensuring 100% offline operational resilience without recurring cloud infrastructure costs or API dependencies.

## Key Architectural Capabilities

* **Asynchronous Tri-Linguistic Matrix:** Supports seamless 3-way translation vectors across Indonesian (ID), English (EN), and Japanese (JA).
* **On-Device Neural Execution:** Integrates edge AI translation models utilizing Google ML Kit's on-device translation subsystem, eliminating network latency and data ingress/egress costs.
* **Dynamic Acoustic Pipeline:** Orchestrates runtime speech-to-text streams that adjust input locale configurations (`id_ID`, `en_US`, `ja_JP`) on the fly based on the user's selected source language matrix.
* **Reactive Fluid UI:** Implements adaptive layout constraints engineered to handle dynamic text expansion and prevent rendering overflows (`RenderFlex` constraints) across diverse iOS and Android hardware form factors.

---

## Technical Stack & Dependencies

* **Framework:** Flutter SDK (Declarative UI Pattern)
* **Programming Language:** Dart (Strongly typed, Sound null safety)
* **Edge AI Infrastructure:** `google_mlkit_translation` (On-Device Neural Machine Translation)
* **Acoustic Processing Peripheral:** `speech_to_text` (Localized Automated Speech Recognition)

---

## Architectural Breakdown

The repository adheres to a decoupled layered architecture ensuring clean separation of concerns:

- lib/
  - controllers/
    - speech_controller.dart (Manages microphone channels and STT lifecycles)
    - translation_controller.dart (Manages neural language models and translation execution)
  - views/
    - main_translation_screen.dart (High-fidelity dashboard handling reactive states)

### Performance & Memory Optimization Matrix
1. **Dynamic Resource Disposal:** The translation engine invokes `.close()` registries dynamically during context switching to prevent memory leaks and minimize active RAM footprints on low-tier mobile hardware.
2. **Idempotent Local Fetching:** Model downloads use predictive verification checkpoints (`isModelDownloaded`) before executing remote pull requests to preserve storage read/write performance.
3. **Adaptive Dropdowns:** Layout matrices leverage explicit width allocations with `TextOverflow.ellipsis` constraints, ensuring complete layout compliance under extreme textual expansion variants (such as complex Japanese script structures).

---

## Local Setup & Implementation Blueprint

### Prerequisites

* Flutter SDK installed and configured globally.
* CocoaPods dependency manager (for iOS deployments).
* Physical iOS/Android device or Emulator/Simulator.

### Installation Sequence

1. Clone the repository into your local production environment:
   ```bash
   git clone [https://github.com/sunyflo05/Your-Repository-Name.git](https://github.com/Wwulan/POCKET-TRANSLATOR.git)
   cd Your-Repository-Name

2. Fetch pub dependencies:
   ```bash
   flutter pub get

3. Initialize native iOS dependencies (if developing on macOS for iOS targets):
   ```bash
    cd ios
    pod install
    cd ..

4. Compile and launch the application on the active subsystem device:
   ```bash
   flutter run

## Production Execution Notes
Upon the initial boot sequence, the engine will automatically run a background evaluation script to download and structure the offline neural dictionaries ('id', 'en', and 'ja'). This synchronous onboarding process occurs exactly once. Subsequent initializations boot instantly with zero data footprint required.