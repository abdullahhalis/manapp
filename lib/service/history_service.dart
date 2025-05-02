import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _chapterHistoryKey = 'chapterHistory';
  late final SharedPreferences _prefs;

  HistoryService._privateConstructor();

  static final HistoryService _instance = HistoryService._privateConstructor();

  static HistoryService get instance => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> addChapterToHistory(String slug) async {
    final history = _prefs.getStringList(_chapterHistoryKey) ?? [];
    if (!history.contains(slug)) {
      history.add(slug);
      await _prefs.setStringList(_chapterHistoryKey, history);
    }
  }

  bool isChapterInHistory(String slug) {
    final history = getChaptersHistory();
    return history.contains(slug);
  }

  List<String> getChaptersHistory() {
    return _prefs.getStringList(_chapterHistoryKey) ?? [];
  }
}
