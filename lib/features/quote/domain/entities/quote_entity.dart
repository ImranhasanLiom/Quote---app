import 'package:equatable/equatable.dart';

// Entity: Pure business object without any framework dependency
// This is what our business logic understands
class QuoteEntity extends Equatable {
  final String id;
  final String content;
  final String author;
  final List<String> tags;

  const QuoteEntity({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
  });

  @override
  List<Object> get props => [id, content, author, tags];

  @override
  bool get stringify => true;
}