import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class InsightsCarousel extends StatelessWidget {
  const InsightsCarousel({
    required this.insights,
    super.key,
  });

  final List<String> insights;

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }
    if (insights.length == 1) {
      return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            insights[0],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return CarouselSlider(
      items: insights.map((insight) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  insight,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 80,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 7),
        // autoPlayAnimationDuration: const Duration(milliseconds: 800),
        // autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        // If you want the carousel to loop infinitely:
        // enableInfiniteScroll: true,
        // Adjust spacing or aspect ratio as desired
      ),
    );
  }
}
