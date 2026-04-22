import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kimora_app_bar.dart';
import '../../widgets/glassmorphism_container.dart';
import 'trip_view_roadmap_screen.dart';

class TripRoadmapScreen extends StatelessWidget {
  const TripRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const KimoraAppBar(showBack: true),
      body: Stack(
        children: [
          // Map Background Placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.surfaceContainerHigh,
            child: const Center(
              child: Icon(Icons.map, size: 100, color: AppColors.outlineVariant),
            ),
          ),

          // Top Header Card
          Positioned(
            top: 100,
            left: 24,
            right: 24,
            child: GlassmorphismContainer(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('5\nDAYS', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pharaohs & Pyramids', style: AppTypography.titleMedium),
                        Text('Day 2 of 5 • Next: Karnak', style: AppTypography.labelMedium.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action
          Positioned(
            right: 24,
            bottom: 200,
            child: FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: AppColors.primaryContainer,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume Trip'),
            ),
          ),

          // Bottom Timeline
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -10))],
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(24),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final isCompleted = index == 0;
                  final isActive = index == 1;
                  
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TripViewRoadmapScreen()));
                    },
                    child: Row(
                      children: [
                        Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isActive ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                                width: 3,
                              ),
                              color: AppColors.surfaceContainer,
                            ),
                            child: isCompleted 
                              ? const Center(child: Icon(Icons.check, color: AppColors.primaryContainer))
                              : const Icon(Icons.image, color: AppColors.outlineVariant),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            index == 0 ? 'Giza' : index == 1 ? 'Karnak' : 'Luxor',
                            style: AppTypography.labelLarge.copyWith(
                              color: isActive ? AppColors.primaryContainer : AppColors.onSurface,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          Text(
                            isCompleted ? 'Completed' : '10:00 AM',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      if (index < 3)
                        Container(
                          width: 40,
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 32), // align with circles
                          color: isCompleted ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                        ),
                    ],
                  ),
                );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
