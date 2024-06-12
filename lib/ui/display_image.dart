import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inlovewithher/models/image_picker_model.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    Key? key,
    this.image,
    this.placeHolder,
    this.width,
    this.fit,
    this.height,
  }) : super(key: key);
  final ImagesPickerModel? image;
  final Widget? placeHolder;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if ((image?.media ?? "").isNotEmpty) {
      return Image.file(
        File(image!.media!),
        width: width,
        height: height,
        fit: fit ?? BoxFit.fill,
      );
    }
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: image?.url ?? "",
      fit: fit ?? BoxFit.fill,
      placeholder: (_, __) {
        return placeHolderWidget();
      },
      errorWidget: (_, __, ___) {
        return placeHolderWidget();
      },
    );
  }

  Widget placeHolderWidget() {
    return placeHolder ??
        Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.pinkAccent,
          ),
        );
  }
}
