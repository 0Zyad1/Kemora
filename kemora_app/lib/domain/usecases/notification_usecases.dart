import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/notification.dart';
import '../repositories/i_notification_repository.dart';

class GetMyNotificationsUseCase {
  final INotificationRepository repository;

  GetMyNotificationsUseCase(this.repository);

  Future<Either<Failure, List<Notification>>> call({int page = 1, int pageSize = 20}) {
    return repository.getMyNotifications(page: page, pageSize: pageSize);
  }
}

class GetUnreadCountUseCase {
  final INotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getUnreadCount();
  }
}

class MarkAsReadUseCase {
  final INotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(int notificationId) {
    return repository.markAsRead(notificationId);
  }
}

class MarkAllAsReadUseCase {
  final INotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.markAllAsRead();
  }
}
