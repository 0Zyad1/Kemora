---
description: How to add or extend functional mock features using the Provider pattern during the integration phase.
---

# Frontend-Mock Integration Workflow

Use this workflow when you want to add interactive features that rely on shared state (e.g., likes, comments, saved items) before the backend API is ready.

## 1. Define the Data Model
- If it's a new entity, create it in `lib/data/local/` (e.g., `feature_mock_data.dart`).
- Include a `seedData` list to provide immediate visual content.

## 2. Create the Integration Provider
- Create a new provider in `lib/providers/` (e.g., `feature_provider.dart`).
- Extend `ChangeNotifier`.
- Use local lists initialized from your `seedData`.
- Implement methods for state changes (e.g., `addItem`, `toggleLike`, `updateStatus`).
- Always call `notifyListeners()` after mutations.

## 3. Register the Provider
- Open `lib/main.dart`.
- Add your provider to the `MultiProvider` list.
```dart
ChangeNotifierProvider(create: (context) => FeatureProvider()),
```

## 4. Wire the UI
- **Read-only**: Use `context.watch<FeatureProvider>().items` in the `build` method.
- **Actions**: Use `context.read<FeatureProvider>().performAction()` in callbacks (onTap, etc.).
- **Specific Rebuilds**: Use `Selector<FeatureProvider, T>` if the widget only depends on a small part of the state.

## 5. Mock Services (Optional)
- If the feature involves complex logic (like AI or heavy calculations), create a service in `lib/services/`.
- Use `Future.delayed` to simulate network latency for a more realistic UX.

## 6. Migration Path to Clean Architecture
When the backend API is ready:
1. Move the data model to `lib/domain/entities/` and `lib/data/models/`.
2. Create the Repository and UseCases as per `add-flutter-feature.md`.
3. Migrate the logic from the Provider to a `ViewModel` in `lib/presentation/viewmodels/`.
4. Update `lib/main.dart` to use the `GetIt` registered ViewModel instead of the temporary Provider.

## Best Practices
- **Images**: Use assets from `assets/images/mocked/`.
- **Delays**: Use `await Future.delayed(Duration(milliseconds: 800))` to show loading states (Shimmers).
- **Feedback**: Always show a `SnackBar` or visual feedback after a mock action is completed.
