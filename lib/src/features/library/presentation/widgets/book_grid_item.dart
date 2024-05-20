import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';

import 'book_box.dart';

class BookGridItem extends StatelessWidget {
  final double? titleFontSize;
  final double? authorFontSize;
  final double? coverWidth;
  final double? coverHeight;
  final String? coverUrl;
  final String? coverPath;
  final bool showInfo;

  const BookGridItem({
    super.key,
    this.titleFontSize = 14,
    this.authorFontSize = 12,
    this.coverWidth = 130.0,
    this.coverHeight = 180.0,
    this.coverUrl,
    this.coverPath,
    this.showInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookBoxWithRating(),
          if (showInfo)
            CustomText(
              text: 'Book Title',
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
          if (showInfo)
            CustomText(
              text: 'Author Name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColors.grey,
              fontSize: authorFontSize,
            ),
        ],
      ),
    );
  }

  Widget _buildBookBoxWithRating() {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        BookBox(
          width: coverWidth,
          height: coverHeight,
          background: AppColors.lightGrey,
          coverUrl: coverUrl,
          coverPath: coverPath,
        ),
        if (showInfo)
          Container(
            margin: const EdgeInsets.only(top: 12.0),
            width: 60,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  AppIcons.microStar,
                  colorFilter: const ColorFilter.mode(
                    AppColors.goldenYellow,
                    BlendMode.srcIn,
                  ),
                ),
                const Text('4.3/5'),
              ],
            ),
          )
      ],
    );
  }
}
