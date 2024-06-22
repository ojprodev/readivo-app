import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/icons.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_grid_item.dart';

class LibraryBooksListScreen extends StatefulWidget {
  final ReadingStatus status;
  const LibraryBooksListScreen({super.key, required this.status});

  @override
  State<LibraryBooksListScreen> createState() => _LibraryBooksListScreenState();
}

class _LibraryBooksListScreenState extends State<LibraryBooksListScreen> {
  late LibraryCubit libraryCubit;
  late AppCubit appCubit;
  List<Book> books = [];
  late ReadingStatus readingStatus;

  @override
  void initState() {
    super.initState();

    readingStatus = widget.status;
    // init cubits
    libraryCubit = LibraryCubit.get(context);
    appCubit = AppCubit.get(context);

    // fetch books list by status
    libraryCubit.getBooks(readingStatus: widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      builder: _booksBuilder,
      listener: _booksStateListener,
    );
  }

  Widget _booksBuilder(BuildContext context, state) {
    return BasicLayout(
      title: 'Books List',
      leading: CustomButton(
        text: 'Back to home',
        styleType: ButtonStyleType.ghost,
        onPressed: () {
          appCubit.previousScreen();
        },
        child: SvgPicture.asset(AppIcons.chevronLeft),
      ),
      titleWidget: const CustomInputField(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        placeholder: 'Search for a book',
        endIcon: Icon(Icons.search),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: getReadingStatuesList().map((bookStatus) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      readingStatus = bookStatus;
                      libraryCubit.getBooks(readingStatus: bookStatus);
                    },
                    child: CustomChip(
                      text: getReadingStatusAsString(bookStatus),
                      backgroundColor: bookStatus == readingStatus
                          ? Colors.black
                          : Colors.grey,
                      textColor: Colors.white,
                      borderRadius: 4.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildBooksList(books: books),
        ],
      ),
    );
  }

  Widget _buildBooksList({required List<Book> books}) {
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
          onTap: () {},
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

  void _booksStateListener(BuildContext context, state) {
    if (state is LibraryFetchedReadingListState) {
      setState(() {
        books = state.books;
      });
    }
  }
}
