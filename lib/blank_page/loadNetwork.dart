import 'package:dsd/blank_page/color_loader.dart';
import 'package:flutter/material.dart';

loadingImageNetwork(String? url, {BoxFit? fit, double? height, double? width}) {
  if (url == null) url = '';
  return Image.network(
    url,
    fit: BoxFit.cover,
    height: height,
    width: width,
    loadingBuilder: (
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    ) {
      if (loadingProgress == null) return child;
      return Center(
        child:
            loadingProgress.expectedTotalBytes != null
                ? ColorLoader3(radius: 15, dotRadius: 6)
                : Container(),
      );
    },
  );
}
