# Solar PV HK Limited — Website (Flutter)

A 5-page responsive corporate website for **Solar PV HK Limited**, built
in Flutter (works on Web, and also compiles fine to Android/iOS/desktop
since it's pure Flutter widgets).

Pages: **Home · About · Products · Why Us · Contact**

## 1. Add your logo

Put your logo file at:

```
assets/images/hk_log.png
```

That's it — `lib/widgets/brand_logo.dart` already points at that path.
Until the file exists, a sun-icon placeholder is shown automatically so
nothing breaks.

## 2. First-time setup (this folder currently has only `lib/`, `assets/`
and `pubspec.yaml` — it's missing the native platform runners)

```bash
flutter create . --project-name solar_pv_hk --platforms=web,android,ios
```

This generates `web/`, `android/`, `ios/` etc. around the existing
`lib/` folder without touching it. Then:

```bash
flutter pub get
```

## 3. Run it

```bash
flutter run -d chrome        # web, fastest way to preview
flutter run                  # any connected device/emulator
```

## 4. Build for release (web)

```bash
flutter build web
```
Output goes to `build/web/` — deploy that folder to any static host
(Netlify, Vercel, Firebase Hosting, GitHub Pages, or your own domain,
e.g. solarpvhk.com).

## Project structure

```
lib/
  core/
    app_theme.dart     # colors, type scale, breakpoints
    responsive.dart     # mobile/tablet/desktop helpers
    content.dart         # ALL site copy — edit text here, not in widgets
  widgets/
    nav_bar.dart, footer.dart, page_scaffold.dart
    cta_button.dart, section.dart, product_card.dart
    sourcing_route.dart # signature graphic: China/Germany/NL -> HK -> Bangladesh
    brand_logo.dart, stat_item_widget.dart, category_icon.dart
  pages/
    home_page.dart, about_page.dart, products_page.dart
    why_us_page.dart, contact_page.dart
  main.dart              # go_router setup
```

## Editing content

Everything text-based — mission, vision, product list, sourcing
countries, phone/email, nav labels — lives in **`lib/core/content.dart`**.
Change it there and it updates everywhere it's used.

## Design tokens

- **Navy** `#0B2545` — primary brand color (trust, B2B credibility)
- **Amber** `#F5A623` — solar/energy accent, used sparingly for CTAs
- **Reed green** `#1B998B` — secondary accent (renewable energy)
- **Type:** Sora (headings) + Manrope (body), via `google_fonts`

## Contact info wired into the site

- Phone: **+852-61880715** (tap-to-call on the Contact page, and a
  circular call/WhatsApp/email icon in the footer)
- Email: `info@solarpvhk.com` (update in `content.dart` if different)

## Making "Send Message" actually deliver email

The Contact page form is wired to send real email to
**kawsar@scube.com.bd** using [Web3Forms](https://web3forms.com) — a
free service that emails form submissions with no backend of your own
required.

**Setup (2 minutes, free):**
1. Go to https://web3forms.com and enter `kawsar@scube.com.bd` — it
   emails you an access key instantly (no account needed).
2. Open `lib/core/content.dart` and paste it in:
   ```dart
   static const String web3FormsAccessKey = 'paste-your-key-here';
   ```
3. Rebuild. Every submission now arrives by email at
   `kawsar@scube.com.bd` automatically — the visitor never leaves the page.

**Until you add a key**, the button still works: it falls back to
opening a pre-filled email draft addressed to `kawsar@scube.com.bd`, so
the form is never broken — it's just one extra click for the visitor
instead of zero.

## What changed in this revision

- **Cards** (sourcing route + highlight cards): icon badges, tighter
  spacing, hover lift, no more dead white space.
- **Sourcing route diagram**: recentred as one compact composition
  instead of stretching across the section with a gap in the middle.
- **Page transitions**: every route now fades + rises in via
  `CustomTransitionPage` in `main.dart`, instead of a hard cut.
- **Footer**: gradient background, amber/reed accent line, circular
  call/email/WhatsApp icons, animated underline nav links.
- **Contact form**: real delivery via Web3Forms (see above), with a
  mailto: fallback so it always works.
# hklimitedweb
