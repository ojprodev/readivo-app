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
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Author name',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Icon(
                          // TODO: either use MU icons or Heroicons
                          Icons.star,
                          color: AppColors.goldenYellow,
                          size: 20.0,
                        ),
                        const SizedBox(width: 4.0),
                        const Text(
                          '4.5',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    )),
                    Text(
                      '1997',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.grey,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryBadge('Finance'),
                      _buildCategoryBadge('Communication'),
                      _buildCategoryBadge('Self Development'),
                      _buildCategoryBadge('Marketing'),
                      _buildCategoryBadge('Sci-Fiction'),
                    ],
                  ),
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
        style: TextStyle(
          color: AppColors.grey, // Text color for badges
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    // Assuming rating is out of 5
    final stars = List<Widget>.generate(
      5,
      (index) => Icon(
        index < rating.floor() ? Icons.star : Icons.star_border,
        color: AppColors.goldenYellow,
      ),
    );

    return Row(children: stars);
  }
}
