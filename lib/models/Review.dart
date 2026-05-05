class Review {
  final String id;
  final String propertyId;
  final String reviewerId;
  final String reviewerName;
  final String reviewerImage;
  final String comment;
  final String date;
  final double rating;

  Review({
    required this.id,
    required this.propertyId,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerImage,
    required this.comment,
    required this.date,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'].toString(),
      propertyId: json['propertyId'].toString(),
      reviewerId: json['reviewerId'].toString(),
      reviewerName: json['reviewerName'] ?? 'Anonymous',
      reviewerImage: json['reviewerImage'] ?? '',
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}