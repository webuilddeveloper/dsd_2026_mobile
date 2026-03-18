import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselBanner<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final double height;

  const CarouselBanner({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 120,
  });

  @override
  State<CarouselBanner<T>> createState() => _CarouselBannerState<T>();
}

class _CarouselBannerState<T> extends State<CarouselBanner<T>> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CarouselSlider(
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  current = index;
                });
              },
            ),
            items:
                widget.items.map((item) {
                  return widget.itemBuilder(context, item);
                }).toList(),
          ),
        ),

        /// DOT INDICATOR
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children:
        //       widget.items.asMap().entries.map((entry) {
        //         return Container(
        //           width: current == entry.key ? 18 : 6,
        //           height: 6,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 3,
        //             vertical: 6,
        //           ),
        //           decoration: BoxDecoration(

        //             borderRadius: BorderRadius.circular(10),
        //             color:
        //                 current == entry.key
        //                     ? Colors.orange
        //                     : Colors.grey.shade300,
        //           ),
        //         );
        //       }).toList(),
        // ),
      ],
    );
  }
}
