import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/quote_service.dart';

class QuoteState {
  final String quote;
  final String source;

  const QuoteState({
    this.quote = 'Your word is your reputation.',
    this.source = 'Kept',
  });
}

class QuoteViewModel extends Notifier<QuoteState> {
  final _quoteService = QuoteService();
  Timer? _timer;

  @override
  QuoteState build() {
    _startQuoteRotation();
    ref.onDispose(() => _timer?.cancel());
    return const QuoteState();
  }

  void _startQuoteRotation() {
    _fetchNewQuote();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchNewQuote();
    });
  }

  Future<void> _fetchNewQuote() async {
    final result = await _quoteService.getMotivationalQuote();
    state = QuoteState(
      quote: result['quote'] ?? 'Your word is your reputation.',
      source: result['source'] ?? 'Kept',
    );
  }
}

final quoteViewModelProvider =
NotifierProvider<QuoteViewModel, QuoteState>(
  QuoteViewModel.new,
);