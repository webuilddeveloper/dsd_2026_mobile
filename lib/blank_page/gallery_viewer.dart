import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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

class GalleryViewerAsset {
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
                      child: Image.asset(
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

class AssetImageViewer {
  static void open(BuildContext context, {required String imagePath}) {
    showDialog(
      context: context,
      builder:
          (_) => Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
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
          ),
    );
  }
}

class PdfViewerDialog {
  static void open(BuildContext context, {required String pdfUrl}) {
    showDialog(
      context: context,
      barrierColor: Colors.black87, // สีด้านหลัง Dialog
      useSafeArea: false,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                      backgroundColor: Colors.black,
                      // progressBarColor: AppColors.primary,
                    ),
                    child: SfPdfViewer.network(pdfUrl),
                  ),
                ),

                Positioned(
                  top: 40,
                  right: 20,
                  child: Material(
                    color: AppColors.backgroundMain,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
