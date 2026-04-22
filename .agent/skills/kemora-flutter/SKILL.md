---
name: kemora-flutter
description: Comprehensive guide for working on the Kemora Flutter mobile app — architecture, layers, entities, providers, screens, design system, performance, and .NET backend integration conventions (updated April 2026).
---

# Kemora Flutter App Skill

## Overview
Kemora is an Egyptian tourism platform. The Flutter app (`kemora_app/`) is the mobile client communicating with the Kemora .NET 10 backend API. The app targets Android (primary) and Web, using Material 3 with a custom "Desert Editorial" design system.

## Project Structure

```
kemora_app/lib/
├── main.dart                    # App entry point, MultiProvider setup
├── core/
│   ├── auth/                    # TokenStorage singleton
│   ├── constants/               # App-wide constants (API routes, sizing, durations)
│   ├── di/                      # GetIt injection container
│   ├── error/                   # Failure classes (dartz)
│   ├── router/                  # GoRouter configuration
│   └── theme/                   # Design system files
│       ├── app_colors.dart      # Material 3 color scheme (Desert palette)
│       ├── app_shadows.dart     # Elevation shadows
│       ├── app_theme.dart       # ThemeData assembly
│       └── app_typography.dart  # TextTheme (Plus Jakarta Sans + Manrope)
├── data/
│   ├── datasources/             # Remote data sources (Dio HTTP calls)
│   ├── local/                   # Local storage / caching
│   ├── models/                  # JSON serializable DTOs (fromJson/toJson)
│   └── repositories/           # Repository implementations
├── domain/
│   ├── entities/                # Pure Dart entities (Equatable)
│   ├── repositories/            # Abstract repository interfaces
│   └── usecases/                # Single-responsibility use cases
├── models/                      # Legacy models (json_serializable)
├── presentation/
│   ├── screens/                 # Feature screens (organized by feature)
│   │   ├── auth/                # LoginScreen, RegisterScreen
│   │   ├── badges/              # BadgesScreen
│   │   ├── explore/             # GovernorateMapView, PlacesScreen, PlaceDetailScreen
│   │   ├── home/                # HomeScreen (hero card, quick actions, top places)
│   │   ├── navigation/          # Bottom navigation shell
│   │   ├── onboarding/          # Onboarding flow
│   │   ├── profile/             # ProfileScreen, SettingsScreen, PublicProfileScreen
│   │   ├── search/              # Global search
│   │   ├── social/              # FeedScreen, PostDetailScreen, ChatListScreen, ChatDetailScreen
│   │   ├── splash/              # SplashScreen
│   │   └── trip/                # TripPlannerScreen, GenerateAiItineraryScreen, AiItineraryResultScreen
│   ├── viewmodels/              # ChangeNotifier ViewModels
│   └── widgets/                 # Reusable widgets
│       ├── editorial_place_card.dart
│       ├── filter_chip_row.dart
│       ├── floating_nav_bar.dart
│       ├── glassmorphism_container.dart
│       ├── itinerary_widgets.dart
│       └── kimora_app_bar.dart
├── providers/                   # AppProvider (locale, misc state)
├── screens/                     # Legacy screens (older pattern — prefer presentation/screens/)
├── services/                    # Standalone services
│   ├── ai_trip_service.dart     # AI trip planning service
│   └── mock_data_service.dart   # Mock data for development
└── l10n/                        # Localization (en, ar)
```

## Technology Stack

| Concern | Package | Notes |
|---------|---------|-------|
| State Management | `provider` (ChangeNotifier) | ViewModels extend ChangeNotifier |
| Dependency Injection | `get_it` | All deps in injection_container.dart |
| HTTP Client | `dio` (5.x) | JWT interceptor + LogInterceptor |
| Routing | `go_router` (13.x) | Declarative routing, ShellRoute for nav |
| Error Handling | `dartz` (Either) | Left(Failure) / Right(T) pattern |
| Equality | `equatable` | All entities extend Equatable |
| Fonts | `google_fonts` | Plus Jakarta Sans (headlines) + Manrope (body) |
| Maps | `google_maps_flutter` | Interactive Egypt map |
| Images | `cached_network_image`, `image_picker` | Network image caching |
| Google Auth | `google_sign_in` | OAuth2 with server client ID |
| JSON | `json_annotation` + `json_serializable` | Code-gen DTOs |
| Time | `timeago` | Relative time formatting |
| SVG | `flutter_svg` | Vector asset rendering |
| URLs | `url_launcher` | External links |
| Storage | `shared_preferences` | Token & settings persistence |
| Localization | `flutter_localizations` + `intl` | EN + AR |

## Architecture: Clean Architecture (3 layers)

### 1. Domain Layer (`lib/domain/`)
Pure Dart, no Flutter/external dependencies. Contains:

#### Entities (Equatable classes):
- **User**: id, email, fullName, profilePictureUrl?, country?, bio?, token?, refreshToken?, earnedBadgesCount, preferences?
- **UserPreferences**: budget, pace, vibe, tourismTypes
- **Place**: id, name, description, category, imageUrl, latitude, longitude, rating
- **Governorate**: id, name, imageUrl?, region?
- **Trip**: id, title, startDate, endDate, plannedPlaces
- **Post**: id, authorId, authorName, authorProfilePicture, content, imageUrl?, locationId?, locationName?, createdAt, likesCount, commentsCount, isLikedByMe, recommendedTripId?, recommendedTripTitle?
- **Comment**: id, postId, authorId, authorName, authorProfilePicture, content, createdAt, parentCommentId?, replies
- **AIItinerary**: title, duration, days → TripDay → ItineraryItem
- **Badge**: id, name, description, iconUrl, criteria, pointsReward, isEarned
- **Chat entities**: Conversation, ChatMessage

#### Repository Interfaces:
- `IAuthRepository` — login, register, googleLogin, updateProfile, uploadPicture, changePassword, changeEmail, updatePreferences
- `IPlaceRepository` — getPlaces, getPlacesByCategory, getTopPlaces, getGovernorates, getPlacesByGovernorate
- `ITripRepository` — getUserTrips, createTripPlan, generateAiItinerary, swapPlace, saveAiPlan
- `IPostRepository` — getFeed, createPost, toggleLike, addComment, getPostComments
- `IBadgeRepository` — getUserBadges, getAllBadges
- `IChatRepository` — getConversations, getMessages, sendMessage, markAsRead

#### Use Cases (single-responsibility):
- Auth: LoginUseCase, RegisterUseCase, GoogleLoginUseCase, UpdatePreferencesUseCase, ChangePasswordUseCase, ChangeEmailUseCase, UpdateProfileUseCase, UploadProfilePictureUseCase
- Places: GetPlacesUseCase, GetPlacesByCategoryUseCase, GetTopPlacesUseCase, GetGovernoratesUseCase, GetPlacesByGovernorateUseCase
- Trips: GetUserTripsUseCase, CreateTripPlanUseCase, GenerateAiItineraryUseCase, SwapPlaceUseCase, SaveAiPlanUseCase
- Posts: GetFeedUseCase, CreatePostUseCase, ToggleLikeUseCase, AddCommentUseCase, GetPostCommentsUseCase
- Badges: GetUserBadgesUseCase, GetAllBadgesUseCase
- Chat: GetConversationsUseCase, GetConversationMessagesUseCase, SendChatMessageUseCase, MarkChatAsReadUseCase

### 2. Data Layer (`lib/data/`)

#### Remote Data Sources (Dio HTTP):
- `AuthRemoteDataSource` → /api/auth/*, /api/profile/*
- `PlacesRemoteDataSource` → /api/places/*
- `TripRemoteDataSource` → /api/trips/*, /api/places/trip-plan
- `PostRemoteDataSource` → /api/posts/*, /api/reactions/*, /api/comments/*
- `BadgeRemoteDataSource` → /api/badges/*
- `ChatRemoteDataSource` → /api/chats/*

#### Models (JSON serializable):
- `UserModel` (extends/maps to User entity)
- `PlaceModel`, `TripModel`, `PostModel`, `BadgeModel`, `ChatModel`, `AIItineraryModel`

#### Repository Implementations:
Each impl takes a RemoteDataSource, calls it, and maps Model → Entity.
Error handling wraps DioExceptions into Left(Failure).

### 3. Presentation Layer (`lib/presentation/`)

#### ViewModels (ChangeNotifier):
- **AuthViewModel**: login, register, googleLogin, updateProfile, changePassword, changeEmail, uploadPicture, updatePreferences. Manages `User? currentUser`, loading states.
- **PlacesViewModel**: getPlaces, getPlacesByCategory, getTopPlaces, getGovernorates, getPlacesByGovernorate. Manages `List<Place>`, `List<Governorate>`.
- **TripViewModel**: getUserTrips, createTripPlan, generateAiItinerary, swapPlace, saveAiPlan. Manages `List<Trip>`, `AIItinerary?`.
- **PostViewModel**: getFeed, createPost, toggleLike, addComment, getPostComments. Manages `List<Post>`, `List<Comment>`.
- **BadgeViewModel**: getUserBadges, getAllBadges. Manages badge lists.
- **ChatViewModel**: getConversations, getMessages, sendMessage, markAsRead.

#### Screens (organized by feature):
- **Auth**: LoginScreen, RegisterScreen
- **Onboarding**: 4-screen flow before login
- **Splash**: SplashScreen (branding + auto-auth check)
- **Home**: HomeScreen (hero card, quick actions, top places carousel)
- **Explore**: GovernorateMapView, PlacesScreen, PlaceDetailScreen, GovernorateplacesScreen
- **Social**: FeedScreen, PostDetailScreen, ChatListScreen, ChatDetailScreen
- **Profile**: ProfileScreen (settings, badges, favorites), PublicProfileScreen, SettingsScreen
- **Trip Planner**: TripPlannerScreen, GenerateAiItineraryScreen, AiItineraryResultScreen
- **Badges**: BadgesScreen (gamification)
- **Search**: Global search screen
- **Navigation**: Bottom navigation shell

#### Reusable Widgets:
- `EditorialPlaceCard` — Premium card with editorial styling
- `FilterChipRow` — Horizontally scrollable filter chips
- `FloatingNavBar` — Custom bottom navigation bar
- `GlassmorphismContainer` — Frosted glass effect
- `ItineraryWidgets` — AI trip itinerary display components
- `KimoraAppBar` — Custom branded app bar

## Dependency Injection (GetIt)
All dependencies registered in `core/di/injection_container.dart`:
- Dio singleton with base URL `http://localhost:5299` (dev) / HTTPS for prod
- JWT interceptor auto-attaches Bearer token from `TokenStorage`
- LogInterceptor for debugging
- Feature registrations follow: ViewModel → UseCases → Repository → DataSource

## Routing (GoRouter)
```
/login          → LoginScreen
/signup         → RegisterScreen
/map            → ExploreScreen (ShellRoute with bottom nav)
  /map/ai-planner       → GenerateAiItineraryScreen
    /map/ai-planner/result → AiItineraryResultScreen
  /map/places            → PlacesScreen
    /map/places/details  → PlaceDetailScreen
/community      → FeedScreen
/profile        → ProfileScreen
```

## Design System (Desert Editorial — 2026)

### Color Palette (Material 3 Dynamic)
```dart
// Primary — Burnt Desert Orange
primary           = Color(0xFF9b4500)
primaryContainer  = Color(0xFFf17720)

// Secondary — Amber Gold
secondary         = Color(0xFF885200)
secondaryContainer = Color(0xFFfea52f)

// Tertiary — Nile Blue
tertiary          = Color(0xFF00658a)
tertiaryContainer = Color(0xFF00a5de)

// Surface
surface           = Color(0xFFf9f9f9)
surfaceContainerLowest = Color(0xFFffffff)
```

### Typography
- **Headings**: Plus Jakarta Sans (ExtraBold/Bold)
- **Body/Labels**: Manrope (Regular/Medium/SemiBold)
- Material 3 TextTheme fully mapped

### Design Tokens
- Card border radius: 20dp
- Button shape: Pill (9999dp radius)
- Input border radius: 12dp
- Material 3 elevation: 0 (flat cards with surface tint)
- Transparent app bars

### Legacy Color Aliases (backward compatibility)
```dart
primaryGold  → AppColors.primaryContainer  // 0xFFf17720
primaryBlue  → AppColors.secondary         // 0xFF885200
primarySand  → AppColors.surfaceContainerLow
accentOasis  → AppColors.tertiary          // 0xFF00658a
```

## .NET Backend Integration

### API Base URL
- Development (Flutter Web/Chrome): `http://localhost:5299`
- Development (Android emulator): `http://10.0.2.2:5299`
- Production: `https://localhost:7210` (or deployed URL)
- API version prefix: `/api/v1/`

### Backend Endpoints by Feature
| Feature | Backend Route | Flutter DataSource |
|---------|---------------|-------------------|
| Auth | `/api/auth/*`, `/api/profile/*` | AuthRemoteDataSource |
| Places | `/api/places/*` | PlacesRemoteDataSource |
| Trips | `/api/trips/*`, `/api/places/trip-plan` | TripRemoteDataSource |
| Posts | `/api/posts/*`, `/api/reactions/*`, `/api/comments/*` | PostRemoteDataSource |
| Badges | `/api/badges/*` | BadgeRemoteDataSource |
| Chat | `/api/chats/*` | ChatRemoteDataSource |
| Favorites | `/api/favorites/*` | (extend PlacesRemoteDataSource) |
| Images | `/api/images/*` | (upload utility) |
| Notifications | `/api/notifications/*` | (future NotificationDataSource) |

### Authentication Flow
1. User registers/logs in → Backend returns JWT + RefreshToken
2. `TokenStorage` persists tokens via `shared_preferences`
3. Dio interceptor attaches `Authorization: Bearer <jwt>` to every request
4. On 401 → interceptor attempts token refresh via `/api/auth/refresh-token`
5. On refresh fail → clear tokens, redirect to login

### DTO ↔ Entity Mapping Convention
```
Backend JSON → data/models/XxxModel.fromJson() → domain/entities/Xxx (via toEntity())
```
- **Never** expose raw JSON or DTOs to the presentation layer
- Models handle serialization; entities handle business logic

### Error Handling Pattern
```dart
// In Repository Implementation:
try {
  final model = await dataSource.getData();
  return Right(model.toEntity());
} on DioException catch (e) {
  return Left(ServerFailure(e.response?.data?['message'] ?? 'Server error'));
}
```

### Real-Time (Future)
Backend exposes SignalR at `/hubs/notifications`. Flutter integration via `signalr_netcore` package (planned).

## Google Sign-In Setup
- Android package: `com.example.kemora`
- `AuthViewModel` reads `GOOGLE_WEB_CLIENT_ID` via Dart define
- Run: `flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=<id>.apps.googleusercontent.com`
- Common Android failure `ApiException: 10`: OAuth mismatch (package name, SHA-1, or wrong client type)

## Performance Best Practices (2026)

### Widget Performance
1. **`const` constructors**: Always use where possible — reduces widget rebuilds
2. **`RepaintBoundary`**: Wrap complex/animating widgets to isolate repaints
3. **`TickerMode`**: Pause off-screen animations to save CPU/battery
4. **`IndexedStack`**: Preserve child state while showing only one tab
5. **Avoid deep nesting**: Extract widgets into separate classes at 4+ levels

### State Management
1. Use `context.watch<VM>()` for reactive rebuilds (in `build()` methods only)
2. Use `context.read<VM>()` for one-off actions (in callbacks, `initState`)
3. Use `Selector<VM, T>()` to rebuild only on specific field changes
4. Use `Consumer<VM>()` to limit rebuild scope within a widget tree

### Color Operations
- **Always** use `withValues()` instead of `withOpacity()` (deprecated in Flutter 3.x+)
- Example: `color.withValues(alpha: 0.5)` not `color.withOpacity(0.5)`

### Image Optimization
- Use `CachedNetworkImage` for all remote images
- Provide `memCacheWidth`/`memCacheHeight` to avoid decoding full-res images
- Use `fadeInDuration: Duration(milliseconds: 200)` for smooth loading

### Layout
- Prefer `SizedBox` over `Container` when only size is needed
- Use `Expanded`/`Flexible` carefully in Row/Column — avoid overflow
- Use `LayoutBuilder` for responsive layouts, not hardcoded widths
- Use `MediaQuery.sizeOf(context)` instead of `MediaQuery.of(context).size` to avoid unnecessary rebuilds

### Recommended Performance Packages (2026)
- `flutter_animate` — Declarative animation chains
- `shimmer` — Skeleton loading placeholders
- `flex_color_scheme` — Simplified Material 3 theming

## Conventions & Rules

### Code Style
1. PascalCase for classes, camelCase for methods/variables, snake_case for file names
2. Use `const` constructors wherever possible
3. Use `withValues()` instead of `withOpacity()` for colors
4. Avoid deep widget nesting — extract into separate classes
5. Use `dartz` Either for error handling (no uncontrolled exceptions)
6. Favour atomic, reusable themed widgets

### File Organization
1. One public class per file (matching filename)
2. Feature screens in `presentation/screens/<feature>/`
3. Shared widgets in `presentation/widgets/`
4. New features go in `presentation/screens/` (not legacy `screens/`)

### Imports
1. Dart SDK imports first, then Flutter, then packages, then relative imports
2. Use package imports (`package:kemora/...`) for cross-feature references

## Common Patterns When Adding a New Feature

### Full-stack feature (backend already exists):
1. **Entity**: Create in `domain/entities/`
2. **Repository interface**: Create in `domain/repositories/`
3. **Use cases**: Create in `domain/usecases/`
4. **Model**: Create in `data/models/` (with fromJson/toJson + toEntity())
5. **Data source**: Create in `data/datasources/` (Dio HTTP calls)
6. **Repository impl**: Create in `data/repositories/`
7. **ViewModel**: Create in `presentation/viewmodels/`
8. **Register all** in `core/di/injection_container.dart`
9. **Add provider** to MultiProvider in `main.dart`
10. **Screen**: Create in `presentation/screens/`
11. **Route**: Add to `core/router/app_router.dart`

### Adding a new screen:
1. Create screen widget in appropriate feature folder
2. Add GoRoute in `app_router.dart`
3. Wire up ViewModel via `context.read<VM>()` or `context.watch<VM>()`
4. Follow Desert Editorial theme (AppColors, AppTypography)
5. Use `const` constructors, avoid deep nesting

### Connecting a new backend endpoint:
1. Add method to the relevant `RemoteDataSource` (abstract + impl)
2. Add method to the relevant repository interface (domain) and impl (data)
3. Create a UseCase wrapping the repository call
4. Add method to the relevant ViewModel
5. Wire up in screen using `context.read<VM>().method()`

### Creating reusable widgets:
1. Place in `presentation/widgets/`
2. Accept data via constructor parameters (no direct ViewModel access)
3. Use `const` constructor
4. Apply theme tokens from `AppColors`, `AppTypography`
5. Support both light and dark modes via `Theme.of(context)`
