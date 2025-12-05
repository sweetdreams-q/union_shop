# Requirements

## Purpose
- Deliver a Flutter web-first experience that mirrors the Union Shop with responsive navigation, product browsing, sale highlights, gallery, search, cart, and supporting pages.
- Prioritize mobile-friendly layouts; desktop should remain functional.

## Supported Platforms
- Development: Windows, macOS, or Linux with Flutter 3.x and Dart 3.x.
- Runtime targets: Web (Chrome recommended), Edge optional. Desktop targets are for development convenience only.

## Tooling
- Flutter SDK 3.x (run `flutter doctor` until clean).
- Dart (bundled with Flutter 3.x).
- Git for version control.
- Chrome (preferred) or Edge for running the web build.

## Dependencies (pubspec.yaml)
- Direct: `flutter`, `go_router`, `firebase_auth` (auth not wired yet).
- Dev: `flutter_test`, `flutter_lints`.
- Assets: `assets/product_images/` declared under `flutter.assets`.

## Setup
- Clone: `git clone https://github.com/sweetdreams-q/union_shop.git && cd union_shop`.
- Install packages: `flutter pub get`.
- Verify environment: `flutter doctor` (must report no unresolved issues).

## Running
- Web (preferred): `flutter run -d chrome` (enable device toolbar in DevTools for mobile sizing).
- Alternate web: `flutter run -d edge`.

## Testing
- Run all tests: `flutter test`.
- Targeted: `flutter test test/widget/home_page_widget_test.dart`.

## Project Structure (summary)
- `lib/main.dart`: Entry point and router (`GoRouter`).
- `lib/models/`: Product/cart models.
- `lib/views/`: Pages (about, cart, gallery, product, sale, search, etc.).
- `lib/widgets/`: Shared UI (responsive header, footer, etc.).
- `assets/product_images/`: Local images.
- `test/`: Widget tests (homepage focus).
- `web/`: Web entry assets.
- `docs/` (optional): Place screenshots/GIFs for documentation.

## Functional Expectations
- Navigation available via responsive header and drawer on small screens.
- Product cards open product detail pages.
- Sale page shows sale and original prices with wrapping on narrow widths.
- Footer visible after scrolling; contains opening hours/info.
- Search page and cart page present UI-level flows (no persistence).

## Non-Functional Expectations
- Responsiveness: layouts adapt to narrow widths (mobile-first) and remain usable on desktop.
- Reliability: tests in `test/widget/home_page_widget_test.dart` must pass.
- Error handling: network images should render graceful fallbacks.
- Accessibility: ensure tappable targets are reachable in narrow layouts (menu/search/cart icons via header/drawer).

## Coding Standards
- Follow Flutter style; prefer `flutter format .` before commits.
- Use small, focused commits with clear messages.
- Keep routing changes centralized in `lib/main.dart`.
- Add widget tests for navigation or layout regressions when altering header/footer/home flows.

## Known Limitations
- Authentication not implemented; `firebase_auth` is present for future wiring.
- Cart and search are demo-level and non-persistent.
- Network images rely on external URLs; offline fallback is a grey placeholder.
- No offline mode; network required for remote imagery.

## Future Improvements (suggested)
- Wire Firebase Auth and persistent cart/search history.
- Add analytics/telemetry hooks (opt-in).
- Expand widget test coverage across all pages and flows.
- Add screenshots/GIFs to `docs/` and embed in README.

## Contacts
- Maintainer: sweetdreams-q
- GitHub: https://github.com/sweetdreams-q/union_shop

