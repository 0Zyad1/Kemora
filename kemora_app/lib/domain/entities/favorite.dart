class Favorite {
  final int id;
  final String userId;
  final String placeId;
  final String placeName;
  final String? placeAddress;
  final String? mainImageUrl;
  final DateTime addedAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.placeName,
    this.placeAddress,
    this.mainImageUrl,
    required this.addedAt,
  });
}
