import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readivo_app/src/core/constants/icons.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';

class LibraryBookDetailsScreen extends StatelessWidget {
  final Book book;
  const LibraryBookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
      title: book.title,
      titleWidget: CustomText(
        book.title,
        color: Colors.white,
      ),
      isPinned: false,
      centerTitle: true,
      leading: CustomButton(
        text: 'Back',
        styleType: ButtonStyleType.ghost,
        child: SvgPicture.asset(
          AppIcons.chevronLeft,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      appBarBackground: Colors.black,
      body: Column(
        children: [
          _buildHeader(),
          const Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                   TabBar(
                    tabs: [
                      Tab(text: 'Details'),
                      Tab(text: 'Notes'),
                    ],
                  ),
                  Expanded(
                    child:  TabBarView(
                      children: [
                        Center(child: Text('Details')),
                        Center(child: Text('Notes')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    double readingProgress =
        ((book.currentPage ?? 0) * 100) / (book.totalPages ?? 0);
    return CustomContainer(
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      width: double.infinity,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BookBox(
            width: 126,
            height: 190,
            borderRadius: 4,
            coverUri: book.coverURI ?? '',
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  book.title,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                if (book.author != null && book.author!.isNotEmpty)
                  CustomText(
                    book.author ?? '',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                Row(
                  children: [
                    if (book.globalRating != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          CustomText(
                            book.globalRating.toString(),
                            color: Colors.white,
                          )
                        ],
                      ),
                    if (book.publishYear != null &&
                        book.publishYear!.isNotEmpty)
                      CustomText(
                        book.publishYear ?? 'N/A',
                        color: Colors.white,
                      ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          '${book.currentPage ?? 0}/${book.totalPages ?? '-'}',
                          color: Colors.white,
                        ),
                        CustomText(
                          '${readingProgress.toStringAsFixed(1)} %',
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: readingProgress / 100,
                      barRadius: const Radius.circular(4.0),
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.grey,
                      padding: EdgeInsets.zero,
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
