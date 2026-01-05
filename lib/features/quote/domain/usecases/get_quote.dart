import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// UseCase: Specific business logic action
// Each UseCase should do only one thing (Single Responsibility)
class GetRandomQuote {
  final QuoteRepository repository;

  GetRandomQuote(this.repository);

  // Callable class - can be called like a function
  Future<Either<Failure, QuoteEntity>> call() async {
    return await repository.getRandomQuote();
  }
}