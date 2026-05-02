import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/editorial_place_card.dart';
import '../../../data/local/place_data.dart';
import '../explore/place_detail_screen.dart';

import '../../widgets/fade_slide_in.dart';
import '../../widgets/tap_scale.dart';
import '../../../core/router/page_transitions.dart';
import '../trip/ai_step_questions_screen.dart';


class HomeContentScreen extends StatefulWidget {
  final Function(int)? onSwitchTab;

  const HomeContentScreen({super.key, this.onSwitchTab});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  int _selectedFilterIndex = 0;
  String _searchQuery = '';
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  final List<String> _filters = [
    'All Odyssey',
    'Ancient Ruins',
    'Nile Cruises',
    'Desert Safari'
  ];

  List<PlaceInfo> get _filteredPlaces {
    List<PlaceInfo> places = placesData;
    if (_selectedFilterIndex == 1) places = places.where((p) => p.category == 'Ancient Places').toList();
    if (_selectedFilterIndex == 2) places = places.where((p) => p.category == 'Hotels' || p.category == 'Restaurants').toList();
    if (_selectedFilterIndex == 3) places = places.where((p) => p.category == 'Others').toList();
    
    if (_searchQuery.isNotEmpty) {
      places = places.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return places;
  }

  String get _sectionTitle {
    switch (_selectedFilterIndex) {
      case 0: return 'The Modern Archivist';
      case 1: return 'Ancient Wonders';
      case 2: return 'Nile Experiences';
      case 3: return 'Desert Adventures';
      default: return 'The Modern Archivist';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
        
        // Greeting
        SliverToBoxAdapter(
          child: FadeSlideIn(
            delayMs: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WELCOME BACK',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: AppTypography.headlineLarge
                          .copyWith(color: AppColors.onSurface),
                      children: const [
                        TextSpan(text: 'Good morning, '),
                        TextSpan(
                          text: 'Zaki',
                          style: TextStyle(color: AppColors.primaryContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Sticky Search Bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickySearchDelegate(
            controller: _searchController,
            showFilters: _showFilters,
            onSearchChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            onFilterTapped: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Filters
        SliverToBoxAdapter(
          child: FadeSlideIn(
            delayMs: 240,
            child: FilterChipRow(
              chips: _filters,
              selectedIndex: _selectedFilterIndex,
              onSelected: (index) {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // The Modern Archivist section header
        SliverToBoxAdapter(
          child: FadeSlideIn(
            delayMs: 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_sectionTitle, style: AppTypography.titleLarge),
                  Row(
                    children: [
                      Text(
                        'View All',
                        style: AppTypography.labelLarge
                            .copyWith(color: AppColors.primaryContainer),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded,
                          color: AppColors.primaryContainer, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Place cards carousel
        SliverToBoxAdapter(
          child: FadeSlideIn(
            delayMs: 400,
            child: SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filteredPlaces.length > 5 ? 5 : _filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = _filteredPlaces[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 260,
                      child: TapScale(
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(
                              child: PlaceDetailScreen(place: place),
                            ),
                          );
                        },
                        child: EditorialPlaceCard(
                          title: place.name,
                          category: place.category,
                          location: place.location,
                          rating: place.rating,
                          reviewsCount: place.reviewsCount,
                          price: place.price,
                          distance: place.distance,
                          isFavorite: index == 0,
                          imageAsset: place.imageAsset,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Removed Community Stories section

        // Explore by Region Card
        SliverToBoxAdapter(
          child: FadeSlideIn(
            delayMs: 600,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TapScale(
                onTap: () {
                  if (widget.onSwitchTab != null) {
                    widget.onSwitchTab!(1);
                  }
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                          child: Icon(Icons.map,
                              size: 64, color: AppColors.outlineVariant)),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'CARTOGRAPHY',
                                style: AppTypography.labelSmall
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Explore by Region',
                              style: AppTypography.headlineSmall
                                  .copyWith(color: AppColors.onSurface),
                            ),
                            Text(
                              'Discover the 27 Governorates',
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: AppColors.onPrimary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        
        // AI Trip Builder Card
        SliverToBoxAdapter(
          child: FadeSlideIn(
            delayMs: 700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TapScale(
                onTap: () {
                  Navigator.push(context, SlidePageRoute(child: const AiStepQuestionsScreen()));
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Make Your Trip with AI',
                              style: AppTypography.titleLarge.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Personalized itinerary in seconds',
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }


}

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;
  final bool showFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTapped;

  _StickySearchDelegate({
    required this.controller,
    required this.showFilters,
    required this.onSearchChanged,
    required this.onFilterTapped,
  });

  @override
  double get minExtent => showFilters ? 260.0 : 80.0;
  @override
  double get maxExtent => showFilters ? 260.0 : 80.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface, // Matches background to hide content scrolling behind
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primaryContainer, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Where to next?',
                          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outline),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onFilterTapped,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: showFilters ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tune,
                          color: showFilters ? AppColors.onPrimary : AppColors.onSurface,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Inline Filters
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: showFilters ? 180 : 0,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minimum Rating', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) => const Icon(
                          Icons.star,
                          color: AppColors.ratingGold,
                          size: 24,
                        )),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: onFilterTapped,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: onFilterTapped,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickySearchDelegate oldDelegate) {
    return oldDelegate.showFilters != showFilters;
  }
}
