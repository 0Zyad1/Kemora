import '../../domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  FavoriteModel({
    required super.id,
    required super.userId,
    required super.placeId,
    required super.placeName,
    super.placeAddress,
    super.mainImageUrl,
    required super.addedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as int,
      userId: json['userId'] as String,
      placeId: json['placeId'] as String,
      placeName: json['placeName'] as String,
      placeAddress: json['placeAddress'] as String?,
      mainImageUrl: json['mainImageUrl'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'placeName': placeName,
      'placeAddress': placeAddress,
      'mainImageUrl': mainImageUrl,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
