import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_grid_item.dart';

class LibraryShelfScreen extends StatefulWidget {
  final Shelf shelf;
  const LibraryShelfScreen({super.key, required this.shelf});

  @override
  State<LibraryShelfScreen> createState() => _LibraryShelfScreenState();
}

class _LibraryShelfScreenState extends State<LibraryShelfScreen> {
  List<Book> books = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    books = widget.shelf.books.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
      title: widget.shelf.name,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: CustomInputField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  books = widget.shelf.books
                      .where((book) => book.title
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
              placeholder: 'Find books in this shelf',
            ),
          ),
          Expanded(child: _buildShelfBooksList(books: books)),
        ],
      ),
    );
  }

// TODO: DRY
  Widget _buildShelfBooksList({required List<Book> books}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 0,
          crossAxisSpacing: 8.0,
          mainAxisExtent: 310,
        ),
        padding: const EdgeInsets.all(8.0),
        itemCount: books.length,
        itemBuilder: (gridContext, index) => GestureDetector(
          onTap: () {
            // appCubit.changeScreen(LibraryAddBookScreen(
            //   book: books[index],
            // ));
          },
          child: BookGridItem(
            book: books[index],
            coverWidth: 180,
            coverHeight: 240,
            titleFontSize: 16,
            authorFontSize: 14,
          ),
        ),
      ),
    );
  }
}
