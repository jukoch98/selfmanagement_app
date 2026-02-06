# Self-Management App

A Flutter-based self-management application.

## Features

### Shopping List
- Create, edit, and delete shopping items
- Mark items as completed with checkbox
- Track quantities for each item
- Swipe-to-delete functionality
- Local persistence with SQLite

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
│
├── features/                   # Feature modules (organized by domain)
│   │
│   └── shopping_list/          # Shopping list feature
│       │
│       ├── data/               # Data layer
│       │   ├── datasources/    # SQLite local data source
│       │   ├── models/         # Data models for database mapping
│       │   └── repositories/   # Repository implementations
│       │
│       ├── domain/             # Domain layer (business logic)
│       │   ├── entities/       # Business entities (ShoppingItem)
│       │   └── repositories/   # Repository interfaces/contracts
│       │
│       └── presentation/       # Presentation layer (UI)
│           ├── providers/      # Riverpod state providers
│           ├── screens/        # Full-page screens
│           └── widgets/        # Reusable UI components
│       
└── core/                       # Shared resources across features
    │
    ├── constants/              # App-wide constants (colors, strings, etc.)
    ├── theme/                  # App theme configuration
    ├── utils/                  # Helper functions and utilities
    └── widgets/                # Shared widgets
```

### Tech Stack

- **Framework**: [Flutter](https://docs.flutter.dev/install/quick?_gl=1%2A1r64n38%2A_ga%2AODMxNjM0OTkyLjE3Njk4OTAwMDM.%2A_ga_04YGWK0175%2AczE3NzA0MTcwMTgkbzQkZzAkdDE3NzA0MTcwMTgkajYwJGwwJGgw)
- **Language**: [Dart](https://dart.dev/overview)
- **State Management**: [Riverpod](https://riverpod.dev/docs/introduction/getting_started)
- **Local Database**: [SQLite (sqflite)](https://sqlite.org/about.html)
- **Architecture**: [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Getting Started

### Prerequisites
- Flutter SDK 3.38.9 or higher (includes Dart 3.10.8)


### Installation

1. Clone the repository
```bash
git clone https://github.com/jukoch98/selfmanagement_app.git
cd selfmanagement_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Development Roadmap

You can find the development roadmap [here](https://github.com/users/jukoch98/projects/2).

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Author

Julia Koch - [GitHub](https://github.com/jukoch98)