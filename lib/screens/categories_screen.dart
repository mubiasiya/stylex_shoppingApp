import 'package:flutter/material.dart';
import 'package:stylex/screens/productsScreen.dart';
import 'package:stylex/widgets/cartIcon.dart';
import 'package:stylex/widgets/navigation.dart';
import 'package:stylex/widgets/title.dart';
import 'package:stylex/widgets/wishlistIcon.dart';

class CategorySideScreen extends StatefulWidget {
  const CategorySideScreen({super.key});

  @override
  State<CategorySideScreen> createState() => _CategorySideScreenState();
}

class _CategorySideScreenState extends State<CategorySideScreen> {
  List<String> mainCategories = [
    "Women",
    "Men",
    "Kids",
    "Beauty",
    "Accessories",
  ];

  List<String> mainCategoryImages = [
    "assets/images/womens.jpeg",
    "assets/images/mens.webp",
    "assets/images/kids.webp",
    "assets/images/beauty1.webp",
    "assets/images/accessories.webp",
  ];

  // List<String> currentSubCategories = ["Tops", "Sarees", "Jeans", "Kurti"];
  Map<String, Map<String, String>> SubCategories = {
    "Women": {
      "Tops": "assets/images/categories/tops1.webp",
      "Gowns": "assets/images/categories/gown1.webp",
      "Kurtis": "assets/images/categories/kurtis1.webp",
      "Co ords": "assets/images/categories/cords1.webp",
    },
    "Men": {
      "Shirts": "assets/images/categories/shirt1.webp",
      "Pants": "assets/images/categories/pants1.webp",
      "T shirts": "assets/images/categories/tshirt1.webp",
    },
    "Kids": {
      "Frocks": "assets/images/categories/frock1.webp",
      "Co ords": "assets/images/categories/kid-cords.webp",
      "Formals": "assets/images/categories/party.webp",
      "Skirts": "assets/images/categories/skirt.webp",
    },
    "Beauty": {
      "Lipstick": "assets/images/categories/lipstick.webp",
      "Sunscreen": "assets/images/categories/sunscreen.webp",
      "Eye liner": "assets/images/categories/eyeliner.webp",
    },
    "Accessories": {
      "Trolleys": "assets/images/categories/trolly.webp",
      "Bags": "assets/images/categories/bag.webp",
      "Watches": "assets/images/categories/watch.webp",
      "Wallets": "assets/images/categories/wallet.webp",
      "Perfume": "assets/images/categories/perfume.webp",
    },
  };

  List<String> subCategoryImages = [];

  int selectedMainIndex = 0;

  @override
  Widget build(BuildContext context) {
    String selectedCategory = mainCategories[selectedMainIndex];
    List<String> currentSubCategories =
        SubCategories[selectedCategory]!.keys.toList();
    List<String> subCategoryImages =
        SubCategories[selectedCategory]!.values.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: title('Categories'),

        actions: [wishlist(context), cartIcon(context), const SizedBox(width: 8)],
      ),
      body: Row(
        children: [
          // LEFT MAIN CATEGORIES WITH CIRCLE IMAGES
          Container(
            width: 110,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              border: Border(right: BorderSide(color: Colors.black, width: 2)),
            ),
            child: ListView.builder(
              itemCount: mainCategories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedMainIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => selectedMainIndex = index),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          //  borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isSelected
                                      ? const Color.fromARGB(255, 151, 147, 147)
                                      : Colors.orange.shade50,
                            ),
                          ],
                        ),

                        child: Container(
                          height: isSelected ? 80 : 70,
                          width: isSelected ? 80 : 70,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            // color: isSelected ? Colors.white : Colors.red,
                            borderRadius: BorderRadius.circular(25),

                            border:
                                isSelected
                                    ? Border.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    )
                                    : null,

                            image: DecorationImage(
                              image: AssetImage(mainCategoryImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Category Label
                      Text(
                        mainCategories[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSelected ? 15 : 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected ? Colors.deepOrange : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // ← Smaller size
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72, // ← Better shape
              ),
              itemCount: currentSubCategories.length,
              itemBuilder: (context, index) {
                return buildSubCategoryItem(
                  index,
                  currentSubCategories,
                  subCategoryImages,
                  context
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildSubCategoryItem(
  int index,
  List<String> currentSubCategories,
  List<String> subCategoryImages,
  BuildContext context
) {
  return GestureDetector(
    onTap: () {
      String keyword=currentSubCategories[index].substring(0,
            currentSubCategories[index].length-1)
            .replaceAll(' ', '');
           
     navigation(context, productsPage(search:  keyword,
          ));
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ⭐ ROUND IMAGE
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            image: DecorationImage(
              image: AssetImage(subCategoryImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ⭐ TITLE
        Text(
          currentSubCategories[index],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
