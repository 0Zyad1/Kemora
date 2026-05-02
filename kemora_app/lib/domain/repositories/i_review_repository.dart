import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/review.dart';

abstract class IReviewRepository {
  Future<Either<Failure, Review>> createReview(String placeId, int rating, String text);
  Future<Either<Failure, List<Review>>> getPlaceReviews(String placeId);
  Future<Either<Failure, void>> deleteReview(int reviewId);
}
