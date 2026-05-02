import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kemora_app_bar.dart';
import '../../../data/local/trip_mock_data.dart';
import '../../../data/local/place_data.dart';
import '../explore/place_detail_screen.dart';

/// Vertical roadmap view of a trip, divided by days.
class TripDetailScreen extends StatelessWidget {
  final LocalTrip trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KemoraAppBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YOUR EXPEDITION',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primaryContainer)),
            const SizedBox(height: 8),
            Text(trip.title, style: AppTypography.displaySmall),
            const SizedBox(height: 4),
            Text('${trip.durationDays} Days • ${trip.governorate}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 32),
            ...trip.days.map((day) => _buildDaySection(context, day)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(BuildContext context, TripDay day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('${day.dayNumber}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Text('Day ${day.dayNumber} — ${day.title}', style: AppTypography.titleLarge),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Timeline stops
        ...List.generate(day.stops.length, (index) {
          final stop = day.stops[index];
          final isLast = index == day.stops.length - 1;
          return _buildTimelineStop(context, stop, isLast);
        }),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTimelineStop(BuildContext context, TripStop stop, bool isLast) {
    // Find actual PlaceInfo
    final place = placesData.where((p) => p.id == stop.placeId).firstOrNull;
    final categoryIcon = _categoryIcon(stop.category);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stop.isCompleted
                        ? AppColors.primaryContainer
                        : AppColors.surfaceContainerHigh,
                    border: Border.all(
                      color: stop.isCompleted
                          ? AppColors.primaryContainer
                          : AppColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: stop.isCompleted
                      ? const Icon(Icons.check, size: 8, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: stop.isCompleted
                          ? AppColors.primaryContainer
                          : AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
              ],
            ),
          ),
          // Stop card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  if (place != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)));
                  }
                },
                onLongPress: () => _showStopInfo(context, stop),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: place?.imageAsset != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(place!.imageAsset!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(categoryIcon, color: AppColors.outlineVariant)),
                              )
                            : Icon(categoryIcon, color: AppColors.outlineVariant),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stop.name, style: AppTypography.titleMedium),
                            const SizedBox(height: 2),
                            Text(stop.time,
                                style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      if (stop.isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Done',
                              style: AppTypography.labelSmall
                                  .copyWith(color: AppColors.primaryContainer)),
                        )
                      else
                        const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStopInfo(BuildContext context, TripStop stop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stop.name, style: AppTypography.headlineSmall),
            const SizedBox(height: 16),
            // Review score
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.ratingGold, size: 20),
                const SizedBox(width: 8),
                Text('${stop.reviewScore}/5.0',
                    style: AppTypography.titleMedium
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('Review Score',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 16),
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stop.tags
                  .map((tag) => Chip(
                        label: Text(tag, style: AppTypography.labelMedium),
                        backgroundColor: AppColors.surfaceContainer,
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Ancient Places':
        return Icons.account_balance;
      case 'Museums':
        return Icons.museum;
      case 'Hotels':
        return Icons.hotel;
      case 'Restaurants':
        return Icons.restaurant;
      default:
        return Icons.place;
    }
  }
}
