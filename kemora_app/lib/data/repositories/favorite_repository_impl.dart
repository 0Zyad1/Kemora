import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/i_favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl implements IFavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addFavorite(String placeId) async {
    try {
      await remoteDataSource.addFavorite(placeId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String placeId) async {
    try {
      await remoteDataSource.removeFavorite(placeId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Favorite>>> getMyFavorites() async {
    try {
      final favorites = await remoteDataSource.getMyFavorites();
      return Right(favorites);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkFavorite(String placeId) async {
    try {
      final isFavorited = await remoteDataSource.checkFavorite(placeId);
      return Right(isFavorited);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
