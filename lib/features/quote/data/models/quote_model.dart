import 'package:equatable/equatable.dart';
import '../../domain/entities/quote_entity.dart';

// Model: Framework-dependent data class
// Handles JSON serialization/deserialization
class QuoteModel extends Equatable {
  final String id;
  final String content;
  final String author;
  final List<String> tags;

  const QuoteModel({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
  });

  // Factory constructor for JSON parsing
  factory QuoteModel.fromJson(dynamic json) {
    final Map<String, dynamic> data = json is List ? json[0] : json;

    return QuoteModel(
      id: DateTime.now().toString(),
      content: data['q'] ?? '',
      author: data['a'] ?? '',
      tags: const [],
    );
  }

  // Convert to JSON (if needed for local storage)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'author': author,
      'tags': tags,
    };
  }

  // Convert Model to Entity
  QuoteEntity toEntity() {
    return QuoteEntity(
      id: id,
      content: content,
      author: author,
      tags: tags,
    );
  }

  @override
  List<Object> get props => [id, content, author, tags];

  @override
  bool get stringify => true;
}