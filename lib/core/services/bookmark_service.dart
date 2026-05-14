import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'bookmarked_appointments';

  Future<Set<int>> getBookmarked() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => int.parse(e)).toSet();
  }

  Future<void> toggleBookmark(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarked = await getBookmarked();

    if (bookmarked.contains(id)) {
      bookmarked.remove(id);
    } else {
      bookmarked.add(id);
    }

    await prefs.setStringList(
      _key,
      bookmarked.map((e) => e.toString()).toList(),
    );
  }

  Future<bool> isBookmarked(int id) async {
    final bookmarked = await getBookmarked();
    return bookmarked.contains(id);
  }
}
