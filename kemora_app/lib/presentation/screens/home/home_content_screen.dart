import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/editorial_place_card.dart';
import '../../../data/local/place_data.dart';
import '../explore/place_detail_screen.dart';
import '../search/global_search_screen.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/tap_scale.dart';
import '../../../core/router/page_transitions.dart';

class HomeContentScreen extends StatefulWidget {
  final Function(int)? onSwitchTab;

  const HomeContentScreen({super.key, this.onSwitchTab});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Odyssey', 'Ancient Ruins', 'Nile Cruises', 'Desert Safari'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 110, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Greeting label
          FadeSlideIn(
            delayMs: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'WELCOME BACK',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Greeting name
          FadeSlideIn(
            delayMs: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                text: TextSpan(
                  style: AppTypography.headlineLarge.copyWith(color: AppColors.onSurface),
                  children: const [
                    TextSpan(text: 'Good morning, '),
                    TextSpan(
                      text: 'Zaki',
                      style: TextStyle(color: AppColors.primaryContainer),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Floating Search Island
          FadeSlideIn(
            delayMs: 160,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, FadePageRoute(child: const GlobalSearchScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        child: Text(
                          'Where to next?',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.outline),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, FadePageRoute(child: const GlobalSearchScreen(openFilters: true)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.tune, color: AppColors.onSurface, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Filters
          FadeSlideIn(
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

          const SizedBox(height: 32),

          // The Modern Archivist section header
          FadeSlideIn(
            delayMs: 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Modern Archivist', style: AppTypography.titleLarge),
                  Row(
                    children: [
                      Text(
                        'View All',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.primaryContainer),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.primaryContainer, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Place cards carousel
          FadeSlideIn(
            delayMs: 400,
            child: SizedBox(
              height: 380,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: placesData.length > 5 ? 5 : placesData.length,
                itemBuilder: (context, index) {
                  final place = placesData[index];
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
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Community Stories section
          FadeSlideIn(
            delayMs: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Community Stories', style: AppTypography.titleLarge),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryContainer, width: 2),
                              ),
                              child: const Center(
                                child: Icon(Icons.add, color: AppColors.primaryContainer),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Your Story', style: AppTypography.labelSmall),
                          ],
                        ),
                        const SizedBox(width: 16),
                        ...List.generate(4, (index) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainer,
                                  border: Border.all(color: AppColors.outlineVariant, width: 2),
                                ),
                                child: const Icon(Icons.person, color: AppColors.outline),
                              ),
                              const SizedBox(height: 8),
                              Text('Traveler', style: AppTypography.labelSmall),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Explore by Region Card
          FadeSlideIn(
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
                      const Center(child: Icon(Icons.map, size: 64, color: AppColors.outlineVariant)),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'CARTOGRAPHY',
                                style: AppTypography.labelSmall.copyWith(color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Explore by Region',
                              style: AppTypography.headlineSmall.copyWith(color: AppColors.onSurface),
                            ),
                            Text(
                              'Discover the 27 Governorates',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
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
                          child: const Icon(Icons.arrow_forward, color: AppColors.onPrimary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
