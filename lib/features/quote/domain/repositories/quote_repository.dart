  import 'package:dartz/dartz.dart';
  import '../../../../core/error/failures.dart';
  import '../entities/quote_entity.dart';

  // Repository interface/contract
  // Domain layer depends on this abstraction, not implementation
  abstract class QuoteRepository {
    Future<Either<Failure, QuoteEntity>> getRandomQuote();

  // Why use Either?
  // Left = Failure, Right = Success
  // Helps handle errors in a functional way
  }