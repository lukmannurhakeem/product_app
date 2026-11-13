# Product Catalog App

A Flutter mobile application for browsing, searching, viewing, and favouriting products. The application supports infinite scrolling, offline fallback, persistent local storage, and recent search history.

## Project Overview

| Information | Details |
|---|---|
| Project | Product Catalog App |
| Platform | Flutter |
| Version | 1.0 |
| Requirements Version | 12 November 2026 |

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

## Getting Started

### Prerequisites

- Flutter SDK
- [Flutter Version Management (FVM)](https://fvm.app/)
- Dart SDK
- Android Studio or Visual Studio Code

### Installation

Clone the repository:

```bash
git clone https://github.com/lukmannurhakeem/product_app.git
```

Navigate to the project directory:

```bash
cd product_app
```

Install dependencies:

```bash
fvm flutter pub get
```

### Environment Configuration

The application uses environment-specific JSON configuration files located in the `env/` directory.

```text
env/
├── dev.json
├── staging.json
└── prod.json
```

### Running the Application

**Development**

```bash
fvm flutter run --dart-define-from-file=env/dev.json
```

**Staging**

```bash
fvm flutter run --dart-define-from-file=env/staging.json
```

### Building the Application

**Production APK**

```bash
fvm flutter build apk --dart-define-from-file=env/prod.json
```

The generated APK can be found at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

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

---

**Platform:** Flutter  
**Requirements Document:** User Requirements Specification v1.0  
**Last Updated:** 12 November 2026