import 'package:flutter/material.dart';

class GalleryViewer {
  static void open(
    BuildContext context, {
    required List<dynamic> gallery,
    int initialIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        PageController controller = PageController(initialPage: initialIndex);

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                controller: controller,
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(
                        gallery[index]['imageUrl'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),

              // ปุ่มปิด
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
