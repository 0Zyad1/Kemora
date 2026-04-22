import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../../data/local/place_data.dart';
import '../trip/trip_roadmap_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final PlaceInfo place;
  
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.55,
            pinned: true,
            leading: IconButton(
              icon: GlassmorphismContainer(
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(999),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: GlassmorphismContainer(
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(999),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: GlassmorphismContainer(
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(999),
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites!')),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Center(child: Icon(Icons.image, size: 100, color: AppColors.outlineVariant)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(place.category.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.onSecondaryFixed)),
                        ),
                        const SizedBox(height: 16),
                        Text(place.name, style: AppTypography.displayMedium.copyWith(color: Colors.white)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primaryContainer, size: 20),
                            const SizedBox(width: 8),
                            Text(place.location, style: AppTypography.bodyLarge.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surfaceContainerLowest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sticky Tabs Placeholder
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.surfaceContainerHigh)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Info', style: AppTypography.labelLarge.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                        Text('Map', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                        Text('Reviews', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                        Text('Community', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 8),
                                  Text('08:00 - 17:00', style: AppTypography.labelMedium),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: AppColors.tertiary),
                                  const SizedBox(width: 8),
                                  Text('${place.rating}', style: AppTypography.labelMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Text(
                          place.description,
                          style: AppTypography.bodyLarge.copyWith(height: 1.8),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text('Map View Placeholder')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STARTING FROM', style: AppTypography.labelSmall),
                RichText(
                  text: TextSpan(
                    style: AppTypography.titleLarge.copyWith(color: AppColors.onSurface),
                    children: [
                      TextSpan(text: '${place.price} '),
                      TextSpan(text: '/ entry', style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TripRoadmapScreen()),
                );
              },
              child: const Text('Add to trip'),
            ),
          ],
        ),
      ),
    );
  }
}
