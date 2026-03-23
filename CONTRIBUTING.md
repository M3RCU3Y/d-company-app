# Contributing to D Table

## Local setup

1. Install Flutter and confirm `flutter --version` works on your machine.
2. Run `flutter pub get`.
3. Supply Firebase values with `--dart-define` flags or your IDE run configuration using the keys listed in `.env.example`.
4. Start with `flutter run`.

## Workflow

- Keep `main` stable.
- Use small feature branches such as `feature/auth`, `feature/favorites`, or `feature/restaurant-dashboard`.
- Prefer mock-first repository changes before binding UI directly to Firebase SDK calls.

## Current architecture

- `lib/app/` contains app wiring, environment scaffolding, and service bootstrap.
- `lib/features/` contains customer, restaurant, admin, auth, and profile slices.
- Controllers are `ChangeNotifier` based and depend on repository interfaces.
- Firebase is the planned backend direction, but the UI should continue talking to repositories rather than SDK classes.

## Quality checks

- Run `flutter analyze`
- Run `flutter test`
- Avoid running slow production builds for every UI tweak.

## Design notes

- Keep the warm premium dining direction already established in the app.
- Separate customer, restaurant, and admin experiences clearly.
- Prefer reusable widgets over repeated screen-specific UI blocks.
