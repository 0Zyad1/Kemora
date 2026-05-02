import 'package:flutter/material.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/usecases/favorite_usecases.dart';

enum FavoriteState { initial, loading, loaded, error }

class FavoriteViewModel extends ChangeNotifier {
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final GetMyFavoritesUseCase getMyFavoritesUseCase;
  final CheckFavoriteUseCase checkFavoriteUseCase;

  FavoriteViewModel({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getMyFavoritesUseCase,
    required this.checkFavoriteUseCase,
  });

  FavoriteState _state = FavoriteState.initial;
  FavoriteState get state => _state;

  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;

  final Map<String, bool> _favoritedStatus = {};

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool isFavorited(String placeId) => _favoritedStatus[placeId] ?? false;

  Future<void> loadFavorites() async {
    _state = FavoriteState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getMyFavoritesUseCase();
    result.fold(
      (failure) {
        _state = FavoriteState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (favoritesList) {
        _favorites = favoritesList;
        for (var fav in favoritesList) {
          _favoritedStatus[fav.placeId] = true;
        }
        _state = FavoriteState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> checkStatus(String placeId) async {
    final result = await checkFavoriteUseCase(placeId);
    result.fold(
      (failure) => null,
      (isFav) {
        if (_favoritedStatus[placeId] != isFav) {
          _favoritedStatus[placeId] = isFav;
          notifyListeners();
        }
      },
    );
  }

  Future<void> toggleFavorite(String placeId) async {
    final currentlyFavorited = isFavorited(placeId);
    
    // Optimistic UI update
    _favoritedStatus[placeId] = !currentlyFavorited;
    if (currentlyFavorited) {
      _favorites.removeWhere((f) => f.placeId == placeId);
    }
    notifyListeners();

    if (currentlyFavorited) {
      final result = await removeFavoriteUseCase(placeId);
      result.fold(
        (failure) {
          // Revert optimistic update
          _favoritedStatus[placeId] = true;
          _errorMessage = failure.message;
          notifyListeners();
        },
        (_) => null,
      );
    } else {
      final result = await addFavoriteUseCase(placeId);
      result.fold(
        (failure) {
          // Revert optimistic update
          _favoritedStatus[placeId] = false;
          _errorMessage = failure.message;
          notifyListeners();
        },
        (_) {
          // Reload to get the new favorite item with proper ID and date
          loadFavorites();
        },
      );
    }
  }
}
