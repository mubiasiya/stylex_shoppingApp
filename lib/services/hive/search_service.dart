import 'package:hive/hive.dart';

void saveSearch(String query) {
  final box = Hive.box('search_history');

  if (query.trim().isEmpty) return;

  List history = box.get('items', defaultValue: []);

  history.remove(query);       
  history.insert(0, query);  

  // if (history.length > 10) {
  //   history = history.sublist(0, 10); // limit size
  // }

  box.put('items', history);
}

// fetching hostory
List<String> getSearchHistory() {
  final box = Hive.box('search_history');
  return List<String>.from(box.get('items', defaultValue: []));
}

//deleting history

void deleteSearchItem(String item) {
  final box = Hive.box('search_history');
  List history = box.get('items', defaultValue: []);
  history.remove(item);
  box.put('items', history);
}
