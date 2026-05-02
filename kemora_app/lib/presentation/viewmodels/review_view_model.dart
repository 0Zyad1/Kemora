import 'package:flutter/material.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/review_usecases.dart';

enum ReviewState { initial, loading, loaded, error }

class ReviewViewModel extends ChangeNotifier {
  final CreateReviewUseCase createReviewUseCase;
  final GetPlaceReviewsUseCase getPlaceReviewsUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;

  ReviewViewModel({
    required this.createReviewUseCase,
    required this.getPlaceReviewsUseCase,
    required this.deleteReviewUseCase,
  });

  ReviewState _state = ReviewState.initial;
  ReviewState get state => _state;

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadReviews(String placeId) async {
    _state = ReviewState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getPlaceReviewsUseCase(placeId);
    result.fold(
      (failure) {
        _state = ReviewState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (reviewsList) {
        _reviews = reviewsList;
        _state = ReviewState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> createReview(String placeId, int rating, String text) async {
    _state = ReviewState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await createReviewUseCase(placeId, rating, text);
    result.fold(
      (failure) {
        _state = ReviewState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (review) {
        _reviews = [review, ..._reviews];
        _state = ReviewState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> deleteReview(int reviewId) async {
    final result = await deleteReviewUseCase(reviewId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _reviews.removeWhere((r) => r.id == reviewId);
        notifyListeners();
      },
    );
  }
}
