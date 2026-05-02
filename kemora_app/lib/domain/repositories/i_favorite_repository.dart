import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/favorite.dart';

abstract class IFavoriteRepository {
  Future<Either<Failure, void>> addFavorite(String placeId);
  Future<Either<Failure, void>> removeFavorite(String placeId);
  Future<Either<Failure, List<Favorite>>> getMyFavorites();
  Future<Either<Failure, bool>> checkFavorite(String placeId);
}
