import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.id,
    required super.authorName,
    required super.rating,
    required super.text,
    required super.placeId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['reviewID'] ?? json['id'] ?? 0,
      authorName: json['authorName'] ?? '',
      rating: json['rating'] ?? 0,
      text: json['text'] ?? '',
      placeId: json['placeID'] ?? json['placeId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewID': id,
      'authorName': authorName,
      'rating': rating,
      'text': text,
      'placeID': placeId,
    };
  }
}
