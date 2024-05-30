import 'package:flutter/material.dart';

/// Widget representing a book with a cover and pages.
class BookCover extends StatelessWidget {
  /// Width of the book.
  final double width;

  /// Height of the book.
  final double height;

  /// Child widget to be placed inside the book (e.g., book cover).
  final Widget child;

  /// Constructor for BookWidget.
  const BookCover({
    super.key,
    required this.child,
    this.width = 200,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // Bottom layer (representing the right side of the book)
            Container(
              width: width + 5,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[400],
              ),
            ),
            // Top layer (representing the book cover)
            Container(
              width: width + 5,
              height: height + 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            // Middle layer (representing book pages)
            Positioned(
              top: 0,
              bottom: 2,
              left: 0,
              child: Container(
                width: width - 3,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(2, 1),
                    ),
                  ],
                ),
                child: child, // Child widget placed inside the book
              ),
            ),
          ],
        ),
      ),
    );
  }
}
