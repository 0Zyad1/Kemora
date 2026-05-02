import 'package:dio/dio.dart';
import '../models/favorite_model.dart';
import '../../core/error/exceptions.dart';

abstract class FavoriteRemoteDataSource {
  Future<void> addFavorite(String placeId);
  Future<void> removeFavorite(String placeId);
  Future<List<FavoriteModel>> getMyFavorites();
  Future<bool> checkFavorite(String placeId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final Dio dio;

  FavoriteRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> addFavorite(String placeId) async {
    try {
      await dio.post('/api/v1/favorites/$placeId');
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to add favorite',
      );
    }
  }

  @override
  Future<void> removeFavorite(String placeId) async {
    try {
      await dio.delete('/api/v1/favorites/$placeId');
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to remove favorite',
      );
    }
  }

  @override
  Future<List<FavoriteModel>> getMyFavorites() async {
    try {
      final response = await dio.get('/api/v1/favorites');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => FavoriteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to get favorites',
      );
    }
  }

  @override
  Future<bool> checkFavorite(String placeId) async {
    try {
      final response = await dio.get('/api/v1/favorites/$placeId/check');
      return response.data['isFavorited'] as bool? ?? false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return false;
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to check favorite status',
      );
    }
  }
}
