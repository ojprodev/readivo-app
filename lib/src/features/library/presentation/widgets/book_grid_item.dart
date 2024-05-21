import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';

import 'book_box.dart';

class BookGridItem extends StatelessWidget {
  final BookEntity book;
  final double? titleFontSize;
  final double? authorFontSize;
  final double? coverWidth;
  final double? coverHeight;
  final bool showInfo;

  const BookGridItem({
    super.key,
    required this.book,
    this.titleFontSize = 14,
    this.authorFontSize = 12,
    this.coverWidth = 130.0,
    this.coverHeight = 180.0,
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
              text: book.title,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
          if (showInfo)
            CustomText(
              text: '${book.author}',
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
          coverUrl: book.coverURI,
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
                Text('${book.globalRating}'),
              ],
            ),
          )
      ],
    );
  }
}
