import 'package:flutter/material.dart';
import 'package:stylex/screens/productsScreen.dart';
import 'package:stylex/services/hive/search_service.dart';
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/navigation.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  String? search;
  SearchScreen({super.key, search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> recentSearches = [];
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    recentSearches = getSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backArrow(context),

        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.2),
        title: SearchBar(),
        actions:
            isTyping
                ? null
                : [
                  _optionButton(icon: Icons.mic, title: "Voice Search"),
                  const SizedBox(width: 5),
                  _optionButton(
                    icon: Icons.photo_camera,
                    title: "Voice Search",
                  ),
                  const SizedBox(width: 3),
                ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isTyping ? _showRecentSearches() : null,
      ),
    );
  }

  Widget SearchBar() {
    return Container(
      height: 45,

      child: TextField(
        controller: _controller,
        style: TextStyle(color: Colors.black, fontSize: 16),

        onChanged: (value) {
          setState(() {
            isTyping = true;
          });
        },

        onTap: () {
          setState(() {
            isTyping = true;
          });
        },
        autofocus: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
          saveSearch(value);
          navigation(context, productsPage(search: _controller.text));

          // List<Product> list=await SearchApi.searchProducts(query: _controller.text);
          // print(list);
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
          hintText: "Explore Products",
          suffixIcon:
              _controller.text.isEmpty
                  ? null
                  : TextButton(
                    onPressed:
                        () => setState(() {
                          _controller.text = '';
                        }),
                    child: Icon(Icons.close, color: Colors.black),
                  ),

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusColor: Colors.black,
          contentPadding: const EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  // RECENT SEARCH LIST
  Widget _showRecentSearches() {
    List<String?> matched_searches;

    if (_controller.text.isEmpty) {
      matched_searches = recentSearches;
    } else {
      matched_searches =
          recentSearches.where((e) {
            return e.toLowerCase().contains(_controller.text.toLowerCase());
          }).toList();
    }
    if (matched_searches.isEmpty) {
      return Text('');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _controller.text.isEmpty
            ? Text(
              "Recent Searches",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
            : Text(''),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            itemCount:
                matched_searches.length > 7 ? 7 : matched_searches.length,
            itemBuilder: (context, index) {
              return _historyItem(matched_searches[index]!);
            },
          ),
        ),
      ],
    );
  }

  // SINGLE HISTORY ROW
  Widget _historyItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              String search_string = text.replaceAll(' ', '');
              navigation(
                context,
                productsPage(search: search_string),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black87),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap:
                () => setState(() {
                  deleteSearchItem(text);
                  recentSearches = getSearchHistory();
                }),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.remove_circle,
                color: Colors.deepOrange[300],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionButton({required IconData icon, required String title}) {
    return IconButton(
      onPressed: () {},
      tooltip: title,
      icon: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepOrange.withOpacity(0.15),
          // border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(child: Icon(icon, size: 18, color: Colors.black)),
      ),
    );
  }
}
