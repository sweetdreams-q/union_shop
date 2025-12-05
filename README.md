# Union Shop

Flutter web app that recreates the University of Portsmouth Students' Union shop experience with responsive navigation, product browsing, sale highlights, gallery, search, and cart flows.

## Features
- Responsive header with drawer navigation for small screens (Home, Collections, About, Sale, Gallery, Print Shack, Search, Cart)
- Hero carousel with CTA buttons, looping slides, and graceful image fallbacks
- Product grid, product detail pages, sale listings, gallery view, search page, cart page, about page, and footer
- Declarative routing via `go_router`
- Basic Firebase Auth dependency scaffolded for future sign-in flows
- Widget tests for homepage navigation, product taps, and footer visibility

## Tech Stack
- Flutter (web-first, mobile-friendly layout)
- Dart
- Routing: `go_router`
- Auth (scaffolded): `firebase_auth`
- State: local widget state/models (`lib/models`)
- Tests: `flutter_test`

## Getting Started
### Prerequisites
- Flutter SDK 3.x (with Dart 3)
- Chrome for web target (recommended) or Edge
- Git
- Windows/macOS/Linux supported by Flutter; ensure `flutter doctor` reports no issues

### Clone and Install
```bash
git clone https://github.com/sweetdreams-q/union_shop.git
cd union_shop
flutter pub get
```

### Run (web, preferred)
```bash
flutter run -d chrome
```
Open Chrome DevTools and toggle the device toolbar to view in mobile dimensions (e.g., Pixel 5) which matches the intended layout.

### Run (desktop/web alternative)
```bash
flutter run -d edge    # or chrome
```

## Usage
- Home: browse hero carousel and featured products; use header icons (search/profile/cart/menu) on small screens.
- Drawer: open via the menu icon to jump to Collections, Sale, About, Gallery, Print Shack, Search, or Cart.
- Products: tap a product title/card to open details; size selection and description are available.
- Sale: discounted products show sale and original prices; layout wraps on small widths.
- Search: use the search page to find items (UI-level in this build).
- Cart: view items and totals (demo logic).
- Footer: scroll to the bottom to view opening hours and links.
- Screenshots/GIFs: add your captures to `docs/` and embed here when available.

## Tests
```bash
flutter test test/widget/home_page_widget_test.dart
```
All homepage widget tests currently pass. Run `flutter test` to execute the full suite.

## Project Structure
```plaintext
lib/
  main.dart              # App entry and router
  models/                # Product/cart models
  views/                 # Pages: about_us_page.dart, cart_page.dart, gallery_page.dart, product_page.dart, sale_page.dart, search_page.dart
  widgets/               # Shared UI: responsive_header.dart, footer.dart
assets/product_images/   # Local product images
test/                    # Widget tests
web/                     # Web entry assets
docs/                    # (optional) screenshots/GIFs for README
```

## Configuration
- Assets are declared in `pubspec.yaml` under `assets/product_images/`.
- Routing is defined in `lib/main.dart` via `GoRouter`.
- Firebase Auth is listed as a dependency but not yet wired; add Firebase config if enabling auth.

## Known Issues / Limitations
- Network images in the hero carousel rely on external URLs; they render a grey fallback on failure.
- Authentication flows are not implemented; `firebase_auth` is present for future work.
- Cart and search are demo-level and do not persist data.
- No offline support; content requires network for remote images.

## Contributing
- Open an issue or submit a PR with a clear description and screenshots/GIFs when UI changes.
- Run `flutter format .` and `flutter test` before opening a PR.
- Follow semantic, focused commits and describe user-facing changes in the PR body.

## Contact
- Maintainer: sweetdreams-q
- GitHub: https://github.com/sweetdreams-q/union_shop
