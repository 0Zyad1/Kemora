import 'package:dio/dio.dart';
import '../models/notification_model.dart';
import '../../core/error/exceptions.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getMyNotifications(int page, int pageSize);
  Future<int> getUnreadCount();
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getMyNotifications(int page, int pageSize) async {
    try {
      final response = await dio.get(
        '/api/v1/notifications',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final List<dynamic> data = response.data['data'] ?? response.data['items'] ?? []; // Adjust based on PagedResult structure
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to fetch notifications',
      );
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get('/api/v1/notifications/unread-count');
      return response.data as int? ?? 0;
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to get unread count',
      );
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await dio.put('/api/v1/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to mark notification as read',
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dio.put('/api/v1/notifications/read-all');
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to mark all as read',
      );
    }
  }
}
