import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_quote.dart';
import 'quote_event.dart';
import 'quote_state.dart';

// BLoC: Business Logic Component
// Manages state based on events
class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetRandomQuote getRandomQuote;

  QuoteBloc({required this.getRandomQuote}) : super(const QuoteInitial()) {
    // Register event handlers
    on<GetRandomQuoteEvent>(_onGetRandomQuote);
    on<RefreshQuoteEvent>(_onRefreshQuote);
  }

  // Handler for initial quote load
  Future<void> _onGetRandomQuote(
      GetRandomQuoteEvent event,
      Emitter<QuoteState> emit,
      ) async {
    emit(const QuoteLoading());

    final result = await getRandomQuote();

    result.fold(
      // Left: Failure
          (failure) => emit(QuoteError(failure.message)),
      // Right: Success
          (quote) => emit(QuoteLoaded(quote)),
    );
  }

  // Handler for manual refresh
  Future<void> _onRefreshQuote(
      RefreshQuoteEvent event,
      Emitter<QuoteState> emit,
      ) async {
    // If already in loading state, don't emit again
    if (state is! QuoteLoading) {
      emit(const QuoteLoading());
    }

    final result = await getRandomQuote();

    result.fold(
          (failure) => emit(QuoteError(failure.message)),
          (quote) => emit(QuoteLoaded(quote)),
    );
  }
}