// News articles provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/article.dart';
import '../../data/repositories/mock_data_repository.dart';

final newsProvider = StateNotifierProvider<NewsNotifier, List<Article>>((ref) {
  return NewsNotifier();
});

class NewsNotifier extends StateNotifier<List<Article>> {
  NewsNotifier() : super(MockDataRepository.getMockArticles());

  void refresh() {
    state = MockDataRepository.getMockArticles();
  }

  List<Article> searchArticles(String query) {
    if (query.isEmpty) return state;

    return state.where((article) {
      return article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.preview.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
