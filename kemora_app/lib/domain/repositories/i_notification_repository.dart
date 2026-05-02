import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/notification.dart';

abstract class INotificationRepository {
  Future<Either<Failure, List<Notification>>> getMyNotifications({int page = 1, int pageSize = 20});
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, void>> markAsRead(int notificationId);
  Future<Either<Failure, void>> markAllAsRead();
}
