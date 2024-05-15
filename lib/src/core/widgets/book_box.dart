import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/constants.dart';

/// Widget representing a book box cover.
class BookBox extends StatelessWidget {
  /// URL of the cover image.
  final String? coverUrl;

  /// Local path of the cover image file.
  final String? coverPath;

  /// Rating of the book.
  final double? rating;

  // Cover height
  final double? height;

  // COver width
  final double? width;

  /// Constructor for BookBoxCover.
  const BookBox({
    super.key,
    this.coverUrl,
    this.coverPath,
    this.rating,
    this.height = 200.0,
    this.width = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (coverUrl != null && coverUrl!.isNotEmpty) {
      return _buildNetworkImage();
    } else if (coverPath != null && File(coverPath!).existsSync()) {
      return _buildLocalImage();
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildNetworkImage() {
    return Image.network(
      coverUrl!,
      fit: BoxFit.fill,
      height: height,
      width: width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildLocalImage() {
    return Image.file(
      File(coverPath!),
      fit: BoxFit.fill,
      height: height,
      width: width,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: height,
      width: width,
      color: AppColors.lightGrey,
      child: Center(
        child: SvgPicture.asset(
          AppIcons.photo,
          width: 40,
          colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),
        ),
      ),
    );
  }
}
