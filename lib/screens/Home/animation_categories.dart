import 'package:flutter/material.dart';

class SmoothCategoryCarousel extends StatefulWidget {
  final List<CategoryItem> items;

  const SmoothCategoryCarousel({super.key, required this.items});

  @override
  State<SmoothCategoryCarousel> createState() => _SmoothCategoryCarouselState();
}

class _SmoothCategoryCarouselState extends State<SmoothCategoryCarousel> {
  late PageController controller;
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      viewportFraction: 0.32, // shows 5 items (2 left, center, 2 right)
      initialPage: 1000,
    );

    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    _autoPlay();
  }

  void _autoPlay() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      controller.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  int realIndex(int i) {
    return i % widget.items.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemBuilder: (_, i) {
          final index = realIndex(i);

          double distance = (currentPage - i).abs();

          // distance = 0 → center
          // distance = 1 → next item
          // distance = 2 → far item

          double scale = 1 - (distance * 0.25); // center bigger
          if (scale < 0.65) scale = 0.65;

          double opacity = 1 - (distance * 0.4);
          if (opacity < 0.3) opacity = 0.3;

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(widget.items[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.items[index].title,
                    style: TextStyle(
                      fontSize: scale > 0.9 ? 16 : 12,
                      fontWeight: scale > 0.9 ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final String image;

  CategoryItem({required this.title, required this.image});
}
