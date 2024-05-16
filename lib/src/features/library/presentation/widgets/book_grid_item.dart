import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';

import 'book_box.dart';

class BookGridItem extends StatelessWidget {
  final double? titleFontSize;
  final double? authorFontSize;
  final double? coverWidth;
  final double? coverHeight;

  const BookGridItem({
    super.key,
    this.titleFontSize = 14,
    this.authorFontSize = 12,
    this.coverWidth = 130.0,
    this.coverHeight = 170.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookBoxWithRating(),
          const SizedBox(height: 4.0),
           Text(
            'Book Title',
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
          ),
           Text(
            'Author Name',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: authorFontSize,
              // fontSize: 12,
            ),
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
        ),
        Container(
          margin: const EdgeInsets.only(top: 12.0),
          width: 60,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                AppIcons.microStar,
                colorFilter: ColorFilter.mode(
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
