// Model class cho Quote
class QuoteModel {
  final String id;
  final String content;
  final String author;
  final List<String> tags;
  final String authorSlug;
  final int length;
  final String dateAdded;
  final String dateModified;

  QuoteModel({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
    required this.authorSlug,
    required this.length,
    required this.dateAdded,
    required this.dateModified,
  });

  // Hàm fromJson để chuyển đổi từ JSON sang object
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      authorSlug: json['authorSlug'] ?? '',
      length: json['length'] ?? 0,
      dateAdded: json['dateAdded'] ?? '',
      dateModified: json['dateModified'] ?? '',
    );
  }

  // Hàm toJson để chuyển đổi từ object sang JSON (optional, nhưng hay có)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'author': author,
      'tags': tags,
      'authorSlug': authorSlug,
      'length': length,
      'dateAdded': dateAdded,
      'dateModified': dateModified,
    };
  }
}
