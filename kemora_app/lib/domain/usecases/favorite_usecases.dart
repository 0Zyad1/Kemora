import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/favorite.dart';
import '../repositories/i_favorite_repository.dart';

class AddFavoriteUseCase {
  final IFavoriteRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String placeId) {
    return repository.addFavorite(placeId);
  }
}

class RemoveFavoriteUseCase {
  final IFavoriteRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String placeId) {
    return repository.removeFavorite(placeId);
  }
}

class GetMyFavoritesUseCase {
  final IFavoriteRepository repository;

  GetMyFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Favorite>>> call() {
    return repository.getMyFavorites();
  }
}

class CheckFavoriteUseCase {
  final IFavoriteRepository repository;

  CheckFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String placeId) {
    return repository.checkFavorite(placeId);
  }
}
