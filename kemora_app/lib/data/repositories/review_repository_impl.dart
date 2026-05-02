import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/i_review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Review>> createReview(String placeId, int rating, String text) async {
    try {
      final review = await remoteDataSource.createReview(placeId, rating, text);
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getPlaceReviews(String placeId) async {
    try {
      final reviews = await remoteDataSource.getPlaceReviews(placeId);
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(int reviewId) async {
    try {
      await remoteDataSource.deleteReview(reviewId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
