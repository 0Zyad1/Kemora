import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kimora_app_bar.dart';
import '../../widgets/editorial_place_card.dart';
import '../../../data/local/place_data.dart';
import '../../../data/local/governorate_data.dart';
import '../explore/place_detail_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  final bool openFilters;
  const GlobalSearchScreen({super.key, this.openFilters = false});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  
  // Filters
  String _selectedGovernorate = 'All';
  final List<String> _selectedCategories = [];
  double _minRating = 0.0;
  double _maxDistance = 100.0;

  final List<String> _categories = ['Ancient Places', 'Museums', 'Hotels', 'Restaurants', 'Others'];

  @override
  void initState() {
    super.initState();
    _showFilters = widget.openFilters;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<PlaceInfo> get _filteredPlaces {
    return placesData.where((place) {
      // 1. Search Query
      if (_searchController.text.isNotEmpty &&
          !place.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
        return false;
      }
      
      // 2. Governorate Filter
      if (_selectedGovernorate != 'All') {
        final govId = governoratesData.firstWhere((g) => g.name == _selectedGovernorate, orElse: () => governoratesData.first).id;
        if (place.governorateId != govId) {
          return false;
        }
      }

      // 3. Category Filter
      if (_selectedCategories.isNotEmpty && !_selectedCategories.contains(place.category)) {
        return false;
      }

      // 4. Rating
      if (place.rating < _minRating) {
        return false;
      }

      // 5. Distance - mock parsing distance
      double dist = double.tryParse(place.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      if (dist > _maxDistance) {
        return false;
      }

      return true;
    }).toList();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedGovernorate = 'All';
      _selectedCategories.clear();
      _minRating = 0.0;
      _maxDistance = 100.0;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredPlaces;

    return Scaffold(
      appBar: const KimoraAppBar(showBack: true),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search destinations...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () => _searchController.clear(),
                            child: const Icon(Icons.close, color: AppColors.outline, size: 16),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _showFilters = !_showFilters),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _showFilters ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
                      border: Border.all(color: _showFilters ? AppColors.primaryContainer : AppColors.outlineVariant.withValues(alpha: 0.5)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.tune,
                      color: _showFilters ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters Section
          if (_showFilters) ...[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Governorate', style: AppTypography.titleMedium),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedGovernorate,
                          items: ['All', ...governoratesData.map((g) => g.name)].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGovernorate = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text('Category', style: AppTypography.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategories.contains(category);
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => _toggleCategory(category),
                          selectedColor: AppColors.primaryContainer.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primaryContainer,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    Text('Minimum Rating: ${_minRating.toStringAsFixed(1)} ★', style: AppTypography.titleMedium),
                    Slider(
                      value: _minRating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 10,
                      activeColor: AppColors.tertiary,
                      onChanged: (value) => setState(() => _minRating = value),
                    ),
                    const SizedBox(height: 24),

                    Text('Max Distance: ${_maxDistance.toInt()} km', style: AppTypography.titleMedium),
                    Slider(
                      value: _maxDistance,
                      min: 0.0,
                      max: 500.0,
                      divisions: 50,
                      activeColor: AppColors.primaryContainer,
                      onChanged: (value) => setState(() => _maxDistance = value),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear All'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _showFilters = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Show ${results.length} results'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ] else ...[
            // Results List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final place = results[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailScreen(place: place),
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: EditorialPlaceCard(
                          title: place.name,
                          category: place.category,
                          location: place.location,
                          rating: place.rating,
                          reviewsCount: place.reviewsCount,
                          price: place.price,
                          distance: place.distance,
                          isFavorite: false,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
