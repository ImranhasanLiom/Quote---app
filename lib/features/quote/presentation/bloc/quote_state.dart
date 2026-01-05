import 'package:equatable/equatable.dart';

import '../../domain/entities/quote_entity.dart';

// States: Different UI states based on business logic
abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

// State 1: Initial state (when app starts)
class QuoteInitial extends QuoteState {
  const QuoteInitial();
}

// State 2: Loading state (when fetching data)
class QuoteLoading extends QuoteState {
  const QuoteLoading();
}

// State 3: Loaded state (when data is successfully fetched)
class QuoteLoaded extends QuoteState {
  final QuoteEntity quote;

  const QuoteLoaded(this.quote);

  // Equatable compares 'quote' object
  // If quote is same as previous, UI won't rebuild
  @override
  List<Object> get props => [quote];
}

// State 4: Error state (when something goes wrong)
class QuoteError extends QuoteState {
  final String message;

  const QuoteError(this.message);

  @override
  List<Object> get props => [message];
}