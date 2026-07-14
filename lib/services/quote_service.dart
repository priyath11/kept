import 'package:dio/dio.dart';

class QuoteService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final String _apiKey = 'AIzaSyDwoHtueNJU98m7fsSNcYrAnSIminM3eFo';

  Future<Map<String, String>> getMotivationalQuote() async {
    try {
      final response = await _dio.post(
        '/models/gemini-pro:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {
                  'text': 'Give me one short powerful quote about discipline, consistency, or follow-through. Draw inspiration from books like Atomic Habits, Think and Grow Rich, The 5 AM Club, Deep Work, Can\'t Hurt Me, or Extreme Ownership. Maximum 15 words. Return ONLY in this exact format with no extra text:\nQUOTE: [the quote here]\nSOURCE: [book name or author name only]',
                }
              ]
            }
          ]
        },
      );

      final text =
      response.data['candidates'][0]['content']['parts'][0]['text']
      as String;

      final lines = text.trim().split('\n');
      String quote = '';
      String source = '';

      for (final line in lines) {
        if (line.startsWith('QUOTE:')) {
          quote = line.replaceFirst('QUOTE:', '').trim();
        } else if (line.startsWith('SOURCE:')) {
          source = line.replaceFirst('SOURCE:', '').trim();
        }
      }

      if (quote.isEmpty) return _fallback();

      return {'quote': quote, 'source': source};
    } on DioException catch (_) {
      return _fallback();
    }
  }

  Map<String, String> _fallback() {
    final fallbacks = [
      {
        'quote': 'You do not rise to your goals. You fall to your systems.',
        'source': 'Atomic Habits'
      },
      {
        'quote': 'Do the hard thing first. The rest gets easier.',
        'source': 'Deep Work'
      },
      {
        'quote': 'Stop waiting for the right moment. This is it.',
        'source': 'Can\'t Hurt Me'
      },
      {
        'quote':
        'Every action is a vote for the person you want to become.',
        'source': 'Atomic Habits'
      },
      {
        'quote': 'Motivation gets you started. Discipline keeps you going.',
        'source': 'Think and Grow Rich'
      },
      {
        'quote': 'Small habits make a big difference. Win the day first.',
        'source': 'The 5 AM Club'
      },
      {
        'quote': 'Extreme ownership means no excuses — only results.',
        'source': 'Extreme Ownership'
      },
    ];
    fallbacks.shuffle();
    return fallbacks.first;
  }
}