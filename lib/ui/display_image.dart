import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inlovewithher/models/image_picker_model.dart';

import '../colors.dart';

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
      // memCacheHeight: height is num ? ((height ?? 0) * 0.75).toInt() : null,
      // memCacheWidth: width is num ? ((width ?? 0) * 0.75).toInt() : null,
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
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: defaultAvatar,
          ),
          child: const Icon(
            Icons.person,
            color: grayTextColor3,
            size: 50,
          ),
        );
  }
}
