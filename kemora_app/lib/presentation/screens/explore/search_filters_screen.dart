import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kemora_app_bar.dart';

class SearchFiltersScreen extends StatelessWidget {
  const SearchFiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KemoraAppBar(
        showBack: false,
        trailing: Text('Reset', style: TextStyle(color: AppColors.primaryContainer)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Ancient Egyptian Temples',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            
            const SizedBox(height: 24),
            Row(
              children: [
                _buildActiveFilterChip('Ancient Places'),
                const SizedBox(width: 8),
                _buildActiveFilterChip('Luxor'),
                const SizedBox(width: 8),
                _buildActiveFilterChip('4+ Stars'),
              ],
            ),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Category', style: AppTypography.titleLarge),
                Text('SELECT MULTIPLE', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryContainer)),
              ],
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildCategoryBento('Ancient Places', Icons.account_balance, true),
                _buildCategoryBento('Hotels', Icons.hotel, false),
                _buildCategoryBento('Restaurants', Icons.restaurant, false),
                _buildCategoryBento('Museums', Icons.museum, false),
              ],
            ),
            
            const SizedBox(height: 32),
            Text('Reviews', style: AppTypography.titleLarge),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(5, (index) => Icon(
                      Icons.star,
                      color: index < 4 ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                    )),
                  ),
                  Text('4.0 & Up', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        color: AppColors.surfaceContainerLowest,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(child: Text('Clear All', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold))),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.labelMedium.copyWith(color: Colors.white)),
          const SizedBox(width: 4),
          const Icon(Icons.close, size: 14, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildCategoryBento(String title, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: isActive ? Colors.white : AppColors.onSurfaceVariant),
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: isActive ? Colors.white : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
