# Changelog

## Session: Kemora UX Refinement (Global UI Polish & Interactions)
- **Global Theme**: Replaced blue rating stars with `AppColors.ratingGold` (`#D4A03C`) across all place cards and detail screens.
- **Home Screen**: Removed the standalone `GlobalSearchScreen` and integrated a sticky, live-search `TextField` directly into `HomeContentScreen` along with an animated inline filter panel. Fixed bottom overflow issues.
- **Explore Screen**: Implemented SharedPreferences to persist the last selected city on the `GovernoratesMapScreen`. Added breadcrumb navigation (e.g., `Explore > Cairo`) to `GovernorateDetailScreen` and `PlaceDetailScreen`.
- **Trip Planner**: Deprecated the static "Add to Trip" navigation and replaced it with a dynamic drag-and-drop bottom sheet integrated with `TripLocalProvider`. Added long-press context menu on trip inspiration cards for toggle/delete capabilities.
- **Social/Community Module**: Upgraded `StoryViewerScreen` to handle interactions. Added likes, `isLikedByMe`, and comments fields to `CommunityStory` data models, and added Love & Comment overlay on stories.
## Session: Frontend Integration Refinement
- **State Management**: Introduced `CommunityProvider`, `TripLocalProvider`, and `VoucherProvider` to simulate a fully connected backend.
- **Home Tab**: Refactored to `CustomScrollView` to support a sticky floating search bar. Integrated shared `CommunityProvider` stories.
- **Explore Tab**: Added `GovernorateDetailScreen` with categorized place rows (Museums, Cultural, etc.) and unified sticky search. Updated `GovernoratesMapScreen` layout with bottom sheet overflow.
- **Trip Planner**: Built `TripDetailScreen` to showcase an interactive day-by-day vertical roadmap. Wired "Recent Drafts" entry points.
- **Community Tab**: Rewrote `FeedScreen` to rely on `CommunityProvider`. Created `CommentBottomSheet` for inline replies. Converted `CreatePostScreen` to stateful with a mock image picker.
- **Profile Tab**: Integrated `VoucherProvider` to drive point redemption logic and connected it to `RedeemedVouchersScreen` for an end-to-end interactive mock experience.
- **Global Components**: Enhanced `FloatingNavBar` with shadow stack for blurry edges. Removed menu icon from `KemoraAppBar` on main screens. Replaced all gray placeholders with assets from `assets/images/mocked/`.

## Session: Documentation & Architectural Alignment
- **Agent Context**: Updated `.agent` folder to accurately reflect the hybrid state management (Clean Arch ViewModels + Integration Providers).
- **Workflows**: Added `frontend-mock-integration.md` to guide the current development phase.
- **Skill Alignment**: Synchronized `SKILL.md` with the new screen structure (`GovernorateDetailScreen`, `TripDetailScreen`) and updated directory tree.
