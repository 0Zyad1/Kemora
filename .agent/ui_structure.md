# Kemora App - Architecture & UI Structure

> [!NOTE]
> This document details the visual and structural architecture of the Kemora Flutter app. As of May 2026, the app is in a **Functional Mock / Integration Phase**, where UI is wired to local providers to simulate a full backend experience.


## Core Design Philosophy
- **Desert Editorial**: Kemora follows a high-end editorial visual style.
- **Tokens**: Centralized under `core/theme/` (`AppColors`, `AppTypography`, `AppShadows`). Do not use ad-hoc colors or padding; use these tokens.
- **Assets**: All mockup images are stored in `assets/images/mocked/`. No generic gray boxes; always supply fallback icons only if assets fail to load.

## State Management
Kemora utilizes a hybrid state management approach during this integration phase:

### 1. Presentation ViewModels (Clean Architecture)
Located in `presentation/viewmodels/`, these are designed for final API integration using `GetIt` for dependency injection.
- **`AuthViewModel`**: Manages user session, JWT tokens, and login/register states.
- **`PlacesViewModel`**: Manages place details and category filtering.
- **`TripViewModel`**: Handles itinerary generation and trip management.
- **`PostViewModel`**: Handles community feed and social interactions.

### 2. Integration Providers (Frontend-Only Mode)
Located in `providers/`, these provide the immediate "source of truth" for the current interactive mock experience.
- **`CommunityProvider`**: Shared data for stories, posts, likes, and comments.
- **`TripLocalProvider`**: Drafts, saved trips, and "Recent Inspiration" cards.
- **`VoucherProvider`**: Point system, rewards catalog, and redemption logic.
- **`AppProvider`**: Global app settings (e.g., Theme, Locale).

## Services Layer
- **`AiTripService`**: Currently a mock service simulating AI-based itinerary generation with realistic delays and content logic.
- **`MockDataService`**: Centralized utility for generating varied Egyptian-themed mockup data.


## Navigation Structure
- **Global**: `MainNavigator` acts as the root orchestrator.
- **Top Bar**: `KemoraAppBar` manages contextual UI. The menu icon is hidden on primary tabs.
- **Bottom Bar**: `FloatingNavBar` provides global navigation with a radial blurry glow effect for depth.

## Key Screens & Components
1. **Home**: `CustomScrollView` with sticky, live-search `TextField` island via `SliverPersistentHeader` and an animated inline `FilterChipRow` panel.
2. **Explore**: Contains `GovernorateDetailScreen` with breadcrumb navigation, and `GovernoratesMapScreen` (SVG interactive map) with persisted city selection. `PlaceDetailScreen` features a drag-and-drop "Add to Trip" bottom sheet.
3. **Trip Planner**: Vertical roadmap view (`TripDetailScreen`) with interactive timeline dots. `TripPlannerEntryScreen` features long-press context menus on inspiration cards.
4. **Community**: `FeedScreen` with interactive `FeedPostCard`s, a stateful `CreatePostScreen`, and a fully interactive `StoryViewerScreen` with likes and comments.
5. **Profile**: `PublicProfileScreen` with bento-style achievements and `RedeemedVouchersScreen`.

## Localization & Internationalization
- **Path**: `lib/l10n/`
- **Supported**: English (`en`), Arabic (`ar`).
- **Convention**: Use `AppLocalizations.of(context)!` for all UI text.

