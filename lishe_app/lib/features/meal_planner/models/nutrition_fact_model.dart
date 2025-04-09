import '../../home/models/nutritionist_model.dart';

class NutritionFact {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final DateTime publishedDate;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isBookmarked;
  final Nutritionist? nutritionist;

  const NutritionFact({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedDate,
    required this.tags,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.nutritionist,
  });

  NutritionFact copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? source,
    DateTime? publishedDate,
    List<String>? tags,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isBookmarked,
    Nutritionist? nutritionist,
  }) {
    return NutritionFact(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      publishedDate: publishedDate ?? this.publishedDate,
      tags: tags ?? this.tags,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      nutritionist: nutritionist ?? this.nutritionist,
    );
  }
}
