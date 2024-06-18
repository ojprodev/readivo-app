import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readivo_app/src/core/constants/icons.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

import 'book_box.dart';

class BookGridItem extends StatelessWidget {
  final Book book;
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
              book.title,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
          if (showInfo && book.author != null)
            CustomText(
              '${book.author}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: Colors.grey,
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
          background: Colors.grey,
          coverUri: book.coverURI ?? '',
        ),
        if (showInfo && book.globalRating != null)
          Container(
            margin: const EdgeInsets.only(top: 12.0),
            width: 60,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
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
                    Colors.orange,
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
