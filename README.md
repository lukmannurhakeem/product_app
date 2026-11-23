# Product Catalog App

A Flutter mobile application for browsing, searching, viewing, and favouriting products. It supports infinite scrolling, offline fallback, persistent local storage, and recent search history.

## Project Overview

| Information | Details |
|---|---|
| Project | Product Catalog App |
| Platform | Flutter (managed with FVM) |
| Architecture | MVVM + Repository pattern |
| State Management | Provider (`ChangeNotifier`) |
| Version | 1.0 |
| Requirements Version | 12 November 2026 |

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [Running the Application](#running-the-application)
- [Building the Application](#building-the-application)
- [Documentation](#documentation)
- [Functional Requirements](#functional-requirements)
- [Non-Functional Requirements](#non-functional-requirements)
- [Acceptance Criteria](#acceptance-criteria)
- [Future Improvements](#future-improvements)

## Features

### 1. Product Listing
- Display product image, name, price, and rating.
- Display image placeholders when images fail to load.
- Support infinite scrolling.
- Load 20 products per page.
- Prevent duplicate products.
- Stop pagination when all products are loaded.

### 2. Product Search
- Search products by name.
- Debounced search with approximately 400 ms delay.
- Prevent outdated search results from appearing.
- Support pagination within search results.
- Display recent searches.

### 3. Product Details
- Display product images.
- Display product description.
- Display product price.
- Display available stock.
- Support adding and removing favourites.

### 4. Favourites / Wishlist
- Add or remove products from favourites.
- Synchronize favourite states across product listing, details, and wishlist.
- Persist favourites across application restarts.
- Immediately remove unfavourited products from the wishlist.
- Display an empty state when no favourites exist.

### 5. Offline Support
- Display previously cached products when internet connectivity is unavailable.
- Show an offline notification.
- Display an error with a Retry option if no cached data exists.
- Replace the product list cache after each successful page-1 fetch.

### 6. Recent Searches
- Store the last 5 searches.
- Display the newest search first.
- Move duplicate searches to the top.
- Allow users to select a previous search.
- Provide an option to clear search history.
- Persist search history across application restarts.

### 7. Loading and Error States
- Loading spinner or skeleton.
- Empty search results.
- Network error messages.
- Retry functionality.
- Pull-to-refresh to reload the first page.

## Architecture

The app follows **MVVM (Model–View–ViewModel)** with the **Repository pattern**. Business logic is kept out of widgets, and each layer depends only on the layer beneath it.

```text
┌──────────────────────────────────────────────┐
│ View (Widgets / Screens)                     │
│ Renders state, forwards user actions         │
└───────────────┬──────────────────────────────┘
                │ context.watch / context.read
┌───────────────▼──────────────────────────────┐
│ ViewModel (ChangeNotifier)                   │
│ Holds UI state, handles logic, notifies View │
└───────────────┬──────────────────────────────┘
                │ calls
┌───────────────▼──────────────────────────────┐
│ Repository (abstract in domain, impl in data)│
│ Single source of truth for data              │
└───────┬───────────────────────┬──────────────┘
        │                       │
┌───────▼────────┐     ┌────────▼─────────────┐
│ Remote Source  │     │ Local Source         │
│ (REST API)     │     │ (cache, favourites,  │
│                │     │  recent searches)    │
└────────────────┘     └──────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Must not |
|---|---|---|
| **Model** | Immutable data classes (`Product`, etc.) and JSON serialization. | Contain UI or business logic. |
| **View** | Widgets and screens. Observe the ViewModel and send user events to it. | Call repositories or contain business logic. |
| **ViewModel** | Holds screen state (loading, data, error, offline), exposes actions (`loadMore`, `search`, `toggleFavourite`), and calls `notifyListeners()`. | Import Flutter widgets or use `BuildContext`. |
| **Repository** | Decides between remote and local data, handles caching and offline fallback, returns `Result` types. | Know about the UI. |
| **Data Source** | Remote API client and local storage access. | Contain business rules. |

### ViewModels

| ViewModel | Screen | Responsibilities |
|---|---|---|
| `ProductListViewModel` | Product listing | Pagination (20 per page), duplicate prevention, concurrent request guard, pull-to-refresh, offline fallback. |
| `SearchViewModel` | Search | 400 ms debounce, stale-result protection, search pagination, recent searches. |
| `ProductDetailViewModel` | Product details | Loads product details, exposes stock and description. |
| `FavouritesViewModel` | Wishlist (app-wide) | Single source of truth for favourites, persistence, cross-screen sync, instant removal. |

`FavouritesViewModel` is provided at the app root, so listing, details, and wishlist all react to the same state (FR-07, NFR-02).

### Data Flow

1. The **View** triggers an action, such as scrolling to the end of the list.
2. The **ViewModel** updates its state (for example `loading`) and calls the repository.
3. The **Repository** fetches from remote, falls back to the local cache on failure, and returns a `Result`.
4. The **ViewModel** maps the result to state (`success`, `empty`, `error`, `offline`) and calls `notifyListeners()`.
5. The **View** rebuilds from the new state.

## Getting Started

### Prerequisites

- [Flutter Version Management (FVM)](https://fvm.app/)
- Flutter SDK (installed through FVM)
- Dart SDK (bundled with Flutter)
- Android Studio or Visual Studio Code

### Installation

```bash
git clone https://github.com/lukmannurhakeem/product_app.git
cd product_app
fvm install
fvm flutter pub get
```

## Environment Configuration

The application uses environment-specific JSON configuration files in the `env/` directory.

```text
env/
├── dev.json
├── staging.json
└── prod.json
```

Values are injected at build time with `--dart-define-from-file`.

## Running the Application

| Environment | Command |
|---|---|
| Development | `fvm flutter run --dart-define-from-file=env/dev.json` |
| Staging | `fvm flutter run --dart-define-from-file=env/staging.json` |
| Production | `fvm flutter run --dart-define-from-file=env/prod.json` |

## Building the Application

**Production APK**

```bash
fvm flutter build apk --dart-define-from-file=env/prod.json
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Documentation

Each requirement is documented on the branch where it was implemented.

| ID | Requirement | Documentation |
|---|---|---|
| FR-01 | Product listing | [FR-01.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-01/docs/FR-01.md) |
| FR-02 | Infinite scrolling | [FR-02.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-02/docs/FR-02.md) |
| FR-03 | Product search | [FR-03.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-03/docs/FR-03.md) |
| FR-04 | Product details | [FR-04.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-04/docs/FR-04.md) |
| FR-05 | Application states | [FR-05.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-05/docs/FR-05.md) |
| FR-06 | Offline fallback | [FR-06.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-06/docs/FR-06.md) |
| FR-07 | Favourites | [FR-07.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-06/docs/FR-07.md) |
| FR-08 | Wishlist | [FR-08.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-06/docs/FR-08.md) |
| FR-09 | Recent searches | [FR-09.md](https://github.com/lukmannurhakeem/product_app/blob/feature/FR-06/docs/FR-09.md) |

## Functional Requirements

| ID | Requirement | Acceptance Criteria |
|---|---|---|
| FR-01 | Product listing | Every product card displays image, name, price, and rating. |
| FR-02 | Infinite scrolling | Loads 20 items per page without duplicates or repeated concurrent requests. |
| FR-03 | Product search | Searches after approximately 400 ms and prevents stale results. |
| FR-04 | Product details | Displays images, description, price, stock, and favourite button. |
| FR-05 | Application states | Supports loading, empty, error, retry, and pull-to-refresh states. |
| FR-06 | Offline fallback | Displays cached products when offline, if available. |
| FR-07 | Favourites | Favourite state persists and synchronizes across screens. |
| FR-08 | Wishlist | Displays all favourited products and supports instant removal. |
| FR-09 | Recent searches | Stores the latest 5 searches and supports clearing history. |

## Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR-01 | Smooth scrolling with cached and lazy-loaded images. |
| NFR-02 | Single source of truth for favourites and recent searches using shared state and local storage. |
| NFR-03 | Product list cache is stored locally and replaced after every successful page-1 fetch. |
| NFR-04 | User-friendly error messages and no crashes during network loss. |

## Acceptance Criteria

- [ ] Product listing displays all required product information.
- [ ] Infinite scrolling loads 20 products per page.
- [ ] Duplicate product IDs are prevented.
- [ ] Search supports debounce and stale-result protection.
- [ ] Product details display all required information.
- [ ] Loading, empty, and error states are implemented.
- [ ] Pull-to-refresh reloads the first page.
- [ ] Offline fallback displays cached products.
- [ ] Favourites persist across application restarts.
- [ ] Favourite states synchronize across all screens.
- [ ] Wishlist supports adding and removing favourites.
- [ ] Recent searches retain the latest 5 searches.
- [ ] Recent searches persist across application restarts.

## Future Improvements

### Localisation (i18n / l10n)
Support more users and markets, which matters for an e-commerce app.

- **Multi-language UI**: use `flutter_localizations` and `intl` with ARB files (e.g. English, Bahasa Melayu, Chinese, Tamil).
- **Locale-aware formatting**: prices, currency, numbers, and dates formatted per locale.
- **Multi-currency pricing**: display prices in the user's currency.
- **Language switcher**: in-app language selection, persisted locally and defaulting to the device locale.
- **RTL support**: layouts that adapt for right-to-left languages such as Arabic.
- **Localised error and empty-state messages**: move all user-facing strings out of the widgets.

### Other Ideas
- Sorting and filtering (category, price range, rating).
- Dark mode.
- Unit, widget, and integration test coverage reporting in CI.

---

**Platform:** Flutter  
**Requirements Document:** User Requirements Specification v1.0  
**Last Updated:** 23 November 2026