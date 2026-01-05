import 'package:equatable/equatable.dart';

// Events: User actions that trigger state changes
abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  // Why Equatable?
  // 1. Automatically implements == operator and hashCode
  // 2. Prevents unnecessary rebuilds by comparing props
  // 3. Makes testing easier
  @override
  List<Object> get props => [];
}

// Event: User requests a new quote
class GetRandomQuoteEvent extends QuoteEvent {
  const GetRandomQuoteEvent();
}

// Event: User manually requests another quote
class RefreshQuoteEvent extends QuoteEvent {
  const RefreshQuoteEvent();
}