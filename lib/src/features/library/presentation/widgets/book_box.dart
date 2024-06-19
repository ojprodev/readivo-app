import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/icons.dart';

/// Widget representing a book box cover.
class BookBox extends StatelessWidget {
  /// URI of the cover image.
  final String coverUri;

  /// Rating of the book.
  final double? rating;

  // Cover height
  final double? height;

  // Cover width
  final double? width;

  // Empty Book Cover Background
  final Color? background;

  /// Custom Empty Cover icon
  final Widget? icon;

  /// Change default icon size, default: 40.0
  final double? iconSize;

  // Border Radius, default 8.0
  final double borderRadius;

  // Border color, default transparent
  final Color borderColor;

  /// Constructor for BookBoxCover.
  const BookBox({
    super.key,
    this.coverUri = '',
    this.rating,
    this.height = 200.0,
    this.width = 150.0,
    this.background = Colors.white,
    this.icon,
    this.borderRadius = 8.0,
    this.iconSize = 40.0,
    this.borderColor = AppColors.lightGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1
        ),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    Uri uri = Uri.parse(coverUri);
    if (uri.isScheme('http') || uri.isScheme('https')) {
      return _buildNetworkImage();
    } else if (uri.isScheme('file') && File(uri.path).existsSync()) {
      return _buildLocalImage(uri.path);
      // TODO: temp
    } else if (coverUri.isNotEmpty) {
      return _buildLocalImage(uri.path);
    }else{
      return _buildPlaceholderImage();
    }
  }

  Widget _buildNetworkImage() {
    return Image.network(
      coverUri,
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

  Widget _buildLocalImage(String path) {
    return Image.file(
      File(path),
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
      color: background,
      child: Center(
        child: icon ??
            SvgPicture.asset(
              AppIcons.photo,
              width: iconSize,
              colorFilter:
                  const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
      ),
    );
  }
}
