import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';

class OverflowBookBox extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;
  final bool isNetworkImage;
  final double width;
  final double height;
  final double heightPadding;
  final bool showInfo;
  final bool horizontalLayout;

  const OverflowBookBox({
    super.key,
    required this.title,
    required this.author,
    required this.imagePath,
    this.isNetworkImage = true,
    this.width = 140,
    this.height = 200,
    this.heightPadding = 0,
    this.showInfo = true,
    this.horizontalLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    return horizontalLayout ? _buildHorizontalLayout() : _buildVerticalLayout();
  }

  Widget _buildVerticalLayout() {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background container
          Container(
            margin: EdgeInsets.only(top: height * 0.4),
            padding: const EdgeInsets.only(bottom: 4.0),
            width: width,
            height: showInfo ? height * 0.6 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: showInfo
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'by $author',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          // Book cover image
          Positioned(
            top: heightPadding,
            child: Container(
              width: width * 0.72,
              height: height * 0.76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: isNetworkImage
                      ? NetworkImage(imagePath)
                      : AssetImage(imagePath) as ImageProvider,
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // Handle image loading error
                    debugPrint('Failed to load image: $error');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Container(
      clipBehavior: Clip.none,
      height: height * .86,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: OverflowBox(
        maxHeight: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.9,
              height: height * 0.94,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: isNetworkImage
                      ? NetworkImage(imagePath)
                      : AssetImage(imagePath) as ImageProvider,
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // Handle image loading error
                    debugPrint('Failed to load image: $error');
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              height: height * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(
                      title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                      Text(
                        'by $author',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LinearPercentIndicator(
                        width: width * 1.4,
                        lineHeight: 8.0,
                        percent: 0.35,
                        animation: true,
                        animationDuration: 800,
                        barRadius: const Radius.circular(8.0),
                        backgroundColor: Colors.grey,
                        progressColor: Colors.green,
                      ),
                      const SizedBox(width: 8.0),
                      const Text('35%', textAlign: TextAlign.right),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomButton(
                        width: 180,
                        text: 'Continue Reading',
                        color: Colors.grey,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.sticky_note_2,
                          size: 36,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
