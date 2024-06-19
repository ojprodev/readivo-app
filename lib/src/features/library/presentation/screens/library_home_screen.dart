import 'package:card_swiper/card_swiper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/icons.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_list_item.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_add_book_screen.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_pdf_reader_screen.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_search_screen.dart';
import 'package:readivo_app/src/features/library/presentation/screens/reading_session_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({super.key});

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  late AppCubit appCubit;
  late LibraryCubit libraryCubit;
  List<Book> readingList = [];
  List<Shelf> shelvesItems = [];

  @override
  void initState() {
    super.initState();
    appCubit = AppCubit.get(context);
    libraryCubit = LibraryCubit.get(context);

    libraryCubit.getReadingBooks();
    libraryCubit
        .fetchShelvesWithBooks()
        .whenComplete(() => null)
        .then((list) => shelvesItems = list);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      builder: _buildHomeScreen,
      listener: _buildListener,
    );
  }

  // Build methods
  Widget _buildHomeScreen(context, state) {
    return BasicLayout(
      title: 'Home Screen',
      titleWidget: const CustomText(
        'Good morning',
        color: Colors.white,
      ),
      showBackButton: false,
      isPinned: false,
      extendBody: false,
      appBarBackground: Colors.grey,
      actions: [
        _buildAddButton(),
      ],
      body: _buildMainLayout(),
    );
  }

  Widget _buildMainLayout() {
    return CustomContainer(
      color: Colors.grey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                const SizedBox(height: 24.0),
                _buildContinueReadingSection(),
                const SizedBox(height: 64.0),
                _buildDailyQuoteSection(),
                const SizedBox(height: 36.0),
                _buildBooksShelvesSection(),
                const SizedBox(height: 64.0),
                _buildBooksOverviewList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return CustomButton(
      text: 'Library Add Button',
      styleType: ButtonStyleType.ghost,
      width: 40,
      height: 40,
      borderRadius: 20,
      child: SvgPicture.asset(
        AppIcons.add,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      onPressed: () {
        CustomBottomSheet.show(
          context: context,
          bottomSheetItems: homeScreenBottomSheetItems(),
        );
      },
    );
  }

  List<BottomSheetItem> homeScreenBottomSheetItems() {
    // List of bottom sheet items
    return [
      BottomSheetItem(
        icon: const Icon(Icons.search),
        label: 'Search',
        borderColor: Colors.grey.withOpacity(0.4),
        onTap: () {
          // close the bottom sheet
          Navigator.pop(context);

          // redirect to the Search Screen
          appCubit.changeScreen(const LibrarySearchScreen());
        },
      ),
      BottomSheetItem(
        icon: const Icon(Icons.qr_code_scanner_outlined),
        label: 'Scan ISBN',
        borderColor: Colors.grey.withOpacity(0.3),
        onTap: () {
          // close the bottom sheet
          Navigator.pop(context);
        },
      ),
      BottomSheetItem(
        icon: const Icon(Icons.edit_note_outlined),
        label: 'Add manually',
        borderColor: Colors.grey.withOpacity(0.4),
        onTap: () {
          // Handle add manually
        },
      ),
    ];
  }

  Widget _buildContinueReadingSection() {
    return SizedBox(
      height: 300.0,
      child: Column(
        children: [
          _buildContinueReadingHeader(),
          const SizedBox(height: 16.0),
          _buildContinueReadingList(),
        ],
      ),
    );
  }

  Widget _buildContinueReadingHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            'Continue Reading',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            'See all',
            fontSize: 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueReadingList() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 240,
      width: MediaQuery.sizeOf(context).width,
      child: ConditionalBuilder(
        condition: readingList.isNotEmpty,
        builder: (context) => Swiper(
          itemCount: readingList.length,
          scale: 0.9,
          loop: false,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => appCubit
                  .changeScreen(LibraryAddBookScreen(book: readingList[index])),
              child: _buildReadingBookCard(readingList[index]),
            );
          },
        ),
        fallback: (context) => _buildReadingBookCard(null, isEmpty: true),
      ),
    );
  }

  Widget _buildReadingBookCard(Book? book, {bool isEmpty = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          const RotationTransition(
            turns: AlwaysStoppedAnimation(-2.6 / 360),
            child: CustomContainer(
              color: Colors.white,
            ),
          ),
          CustomContainer(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: ConditionalBuilder(
              condition: isEmpty == false,
              builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  BookBox(
                    width: 121,
                    height: 190,
                    coverUri: book!.coverURI ?? '',
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            book.title,
                            maxLines: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      'page 230 of ${book.totalPages ?? '-'}'),
                                  const CustomText('63%'),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              CustomContainer(
                                padding: const EdgeInsets.all(6.0),
                                color: Colors.grey,
                                borderRadius: 12.0,
                                child: LinearPercentIndicator(
                                  lineHeight: 8.0,
                                  percent: 0.63,
                                  barRadius: const Radius.circular(4.0),
                                  backgroundColor: Colors.white,
                                  progressColor: Colors.grey,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomButton(
                                text: 'Start Reading',
                                styleType: ButtonStyleType.ghost,
                                width: 140,
                                onPressed: () {
                                  if (book.source == BookSourceEnums.local) {
                                    // open the pdf reader screen
                                    appCubit.changeScreen(
                                        LibraryPdfReaderScreen(book: book));
                                  } else {
                                    appCubit.changeScreen(
                                        ReadingSessionScreen(book: book));
                                  }
                                },
                                child: CustomText(
                                  book.source == BookSourceEnums.local
                                      ? 'Continue Reading'
                                      : 'Start a Session',
                                  textAlign: TextAlign.end,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              fallback: (context) => _buildContinueReadingEmptyCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueReadingEmptyCard() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
            text: 'Add a Book',
            height: 120,
            width: 120,
            borderRadius: 60,
            color: Colors.grey,
            onPressed: () {
              CustomBottomSheet.show(
                context: context,
                bottomSheetItems: homeScreenBottomSheetItems(),
              );
            },
            child: SvgPicture.asset(
              AppIcons.addOutline,
              width: 54,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            )),
        const Text('Add books you are reading'),
      ],
    );
  }

  Widget _buildDailyQuoteSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            children: [
              const CustomContainer(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 16.0,
                        left: 16.0,
                        top: 36.0,
                        bottom: 16.0,
                      ),
                      child: CustomText(
                        'They are many names for the future; weak call it impossible, afraid people call it  unknown. but for braves it’s the truth.',
                        color: Colors.black87,
                        textAlign: TextAlign.center,
                        maxLines: 10,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Money Master the Game / 201',
                            color: Colors.black54,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.0),
                          CustomText(
                            '- Plato',
                            color: Colors.black,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -6,
                left: 8,
                child: SvgPicture.asset(
                  AppIcons.bookmark,
                  height: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        const CustomButton(
          text: 'View all',
          textColor: Colors.white,
          styleType: ButtonStyleType.ghost,
        ),
      ],
    );
  }

  Widget _buildBooksShelvesSection() {
    return Column(
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Books Shelves',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                    'Browse all',
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            ConditionalBuilder(
              condition: shelvesItems.isNotEmpty,
              builder: (context) => _buildShelvesItems(),
              fallback: (context) => _buildEmptyShelvesCard(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShelvesItems() {
    return SizedBox(
      height: 140,
      child: Swiper(
        itemCount: shelvesItems.length,
        scale: 0.9,
        viewportFraction: 0.85,
        itemBuilder: (context, index) => _buildShelfItem(shelvesItems[index]),
      ),
    );
  }

  Widget _buildEmptyShelvesCard() {
    return CustomContainer(
      color: Colors.white,
      height: 120,
      borderRadius: 6.0,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomText(
            'No Books Shelves found.',
            fontSize: 16,
          ),
          SizedBox(height: 8.0),
          CustomButton(
            width: 160,
            text: 'Add a Shelf',
            borderRadius: 6.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBooksOverviewList() {
    List<Map<String, dynamic>> readingStatus = [
      {
        'label': 'Want to read',
        'icon': Icons.bookmark,
        'count': '51',
      },
      {
        'label': 'Reading',
        'icon': Icons.local_library,
        'count': '3',
      },
      {
        'label': 'Paused',
        'icon': Icons.pause_circle_filled_rounded,
        'count': '1',
      },
      {
        'label': 'Finished',
        'icon': Icons.bookmark_added,
        'count': '21',
      },
      {
        'label': 'Gave Up',
        'icon': Icons.flag,
        'count': '2',
      },
    ];

    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      borderColor: Colors.grey.withOpacity(0.8),
      borderWidth: 1,
      color: Colors.white,
      borderRadius: 8,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CustomListItem(
            label: readingStatus[index]['label'],
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            icon: Icon(
              readingStatus[index]['icon'],
              color: Colors.grey,
            ),
            backgroundColor: Colors.transparent,
            textStyle: const TextStyle(color: Colors.black),
            borderColor: Colors.transparent,
            appendIcon: Text(readingStatus[index]['count']),
          );
        },
        separatorBuilder: (context, index) {
          return index != readingStatus.length - 1
              ? Container(
                  color: Colors.grey.withOpacity(0.6),
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  height: 1,
                )
              : const SizedBox();
        },
        itemCount: readingStatus.length,
      ),
    );
  }

  Widget _buildShelfItem(Shelf shelf) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CustomContainer(
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width,
          borderRadius: 6.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomText(
                shelf.name,
                fontSize: 18,
              ),
              CustomText(
                shelf.totalBooks.toString(),
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Container(
          width: 150,
          height: 200,
          padding: const EdgeInsets.only(right: 12.0),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                top: 40,
                child: BookBox(
                  width: 60,
                  height: 90,
                ),
              ),
              Positioned(
                right: 0,
                top: 40,
                child: BookBox(
                  width: 60,
                  height: 90,
                ),
              ),
              BookBox(
                width: 70,
                height: 105,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Listener method
  void _buildListener(BuildContext context, state) {
    if (state is LibraryFetchedReadingListState) {
      readingList = state.books;
    }

    if (state is LibraryShelvesListLoaded) {
      shelvesItems = state.shelves;
    }
  }
}
