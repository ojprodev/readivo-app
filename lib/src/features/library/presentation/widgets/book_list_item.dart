import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';

class BookListItem extends StatelessWidget {
  final BookEntity book;

  const BookListItem({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.6),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 120,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            ),
            child: BookBox(
              coverUrl: book.coverURI,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: book.title,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    CustomText(
                      text: '${book.author}',
                      fontSize: 16.0,
                      color: AppColors.grey,
                      maxLines: 1,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.goldenYellow,
                          size: 20.0,
                        ),
                        Text(
                          '${book.globalRating}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Text(
                      '${book.publishDate}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
