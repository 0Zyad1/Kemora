import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/review.dart';
import '../repositories/i_review_repository.dart';

class CreateReviewUseCase {
  final IReviewRepository repository;

  CreateReviewUseCase(this.repository);

  Future<Either<Failure, Review>> call(String placeId, int rating, String text) {
    return repository.createReview(placeId, rating, text);
  }
}

class GetPlaceReviewsUseCase {
  final IReviewRepository repository;

  GetPlaceReviewsUseCase(this.repository);

  Future<Either<Failure, List<Review>>> call(String placeId) {
    return repository.getPlaceReviews(placeId);
  }
}

class DeleteReviewUseCase {
  final IReviewRepository repository;

  DeleteReviewUseCase(this.repository);

  Future<Either<Failure, void>> call(int reviewId) {
    return repository.deleteReview(reviewId);
  }
}
