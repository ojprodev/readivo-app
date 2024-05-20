import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({
    super.key,
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
            child: const BookBox(),
          ),
          const SizedBox(width: 16.0),
           const Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               mainAxisSize: MainAxisSize.max,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'Book Title',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 18.0,
                       ),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                     Text(
                       'Author name',
                       style: TextStyle(
                         fontSize: 16.0,
                         color: AppColors.grey,
                       ),
                     ),
                   ],
                 ),
                 Row(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.star,
                           color: AppColors.goldenYellow,
                           size: 20.0,
                         ),
                         Text(
                           '4.5',
                           style: TextStyle(fontSize: 16.0),
                         ),
                       ],
                     ),
                     Text(
                       '1997',
                       style: TextStyle(
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

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: AppColors.lightGrey, // Use grey color for badges
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: AppColors.grey,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
