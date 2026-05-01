import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kemora_app_bar.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/trip_view_model.dart';
import '../../../domain/entities/trip_plan_request.dart';
import 'ai_itinerary_result_screen.dart';

class AiStepQuestionsScreen extends StatefulWidget {
  const AiStepQuestionsScreen({super.key});

  @override
  State<AiStepQuestionsScreen> createState() => _AiStepQuestionsScreenState();
}

class _AiStepQuestionsScreenState extends State<AiStepQuestionsScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  String? _selectedDestination;
  int? _selectedDays;
  String? _selectedBudget;
  final Set<String> _selectedInterests = {};
  String? _selectedCompanions;

  void _nextStep() async {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Generate itinerary
      final tripVM = context.read<TripViewModel>();
      final request = TripPlanRequest(
        latitude: 30.0444, // Cairo default
        longitude: 31.2357,
        location: _selectedDestination ?? '',
        durationDays: _selectedDays ?? 1,
        budget: _selectedBudget ?? 'Mid-Range',
        preferences: '${_selectedCompanions ?? "Solo"}, ${_selectedInterests.join(', ')}',
      );

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.primaryContainer)),
      );

      await tripVM.generateAiItinerary(request);

      if (mounted) {
        Navigator.pop(context); // close dialog
        if (tripVM.state == TripState.loaded && tripVM.currentPlan != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => AIItineraryResultScreen(
                itinerary: tripVM.currentPlan!,
                request: request,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tripVM.errorMessage ?? 'Failed to generate plan')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KemoraAppBar(showBack: true),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  _buildSingleChoiceStep('Where do you want to go?', ['Cairo', 'Luxor', 'Aswan', 'Sharm El-Sheikh', 'Alexandria', 'Hurghada', 'Siwa'], _selectedDestination, (val) => setState(() => _selectedDestination = val)),
                  _buildSingleChoiceStep('How many days?', ['1 Day', '2 Days', '3 Days', '5 Days', '7 Days'], _selectedDays?.toString() ?? '', (val) => setState(() => _selectedDays = int.tryParse(val.split(' ')[0]))),
                  _buildSingleChoiceStep('What\'s your budget?', ['Budget', 'Mid-Range', 'Luxury'], _selectedBudget, (val) => setState(() => _selectedBudget = val)),
                  _buildMultiSelectStep('What are you interested in?', ['History', 'Adventure', 'Beach', 'Culinary', 'Culture', 'Nature', 'Shopping']),
                  _buildSingleChoiceStep('Who are you traveling with?', ['Solo', 'Couple', 'Family', 'Friends', 'Group Tour'], _selectedCompanions, (val) => setState(() => _selectedCompanions = val)),
                ],
              ),
            ),
            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: Text(_currentStep == _totalSteps - 1 ? 'Generate My Trip' : 'Next Step'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: return _selectedDestination != null;
      case 1: return _selectedDays != null;
      case 2: return _selectedBudget != null;
      case 3: return _selectedInterests.isNotEmpty;
      case 4: return _selectedCompanions != null;
      default: return false;
    }
  }

  Widget _buildSingleChoiceStep(String question, List<String> options, String? selectedValue, ValueChanged<String> onSelect) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTypography.headlineMedium),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selectedValue == option;
                return GestureDetector(
                  onTap: () => onSelect(option),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.1) : AppColors.surfaceContainerLowest,
                      border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option, style: AppTypography.titleMedium.copyWith(color: isSelected ? AppColors.primaryContainer : AppColors.onSurface)),
                        if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryContainer),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectStep(String question, List<String> options) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTypography.headlineMedium),
          const SizedBox(height: 32),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: options.map((option) {
                final isSelected = _selectedInterests.contains(option);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(option);
                      } else {
                        _selectedInterests.add(option);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
                      border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(option, style: AppTypography.titleMedium.copyWith(color: isSelected ? AppColors.onPrimary : AppColors.onSurface)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
