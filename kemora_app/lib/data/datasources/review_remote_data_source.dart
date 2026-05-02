import 'package:dio/dio.dart';
import '../models/review_model.dart';
import '../../core/error/exceptions.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewModel> createReview(String placeId, int rating, String text);
  Future<List<ReviewModel>> getPlaceReviews(String placeId);
  Future<void> deleteReview(int reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReviewModel> createReview(String placeId, int rating, String text) async {
    try {
      final response = await dio.post(
        '/api/v1/places/$placeId/reviews',
        data: {'rating': rating, 'text': text},
      );
      return ReviewModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to create review',
      );
    }
  }

  @override
  Future<List<ReviewModel>> getPlaceReviews(String placeId) async {
    try {
      final response = await dio.get('/api/v1/places/$placeId/reviews');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => ReviewModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to get reviews',
      );
    }
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    try {
      await dio.delete('/api/v1/places/0/reviews/$reviewId'); // The backend route seems to not strictly need placeId for delete if reviewId is global. Verify later. Assuming standard route for now.
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to delete review',
      );
    }
  }
}
