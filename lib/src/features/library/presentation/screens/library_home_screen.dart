import 'package:card_swiper/card_swiper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_list_item.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_search_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({super.key});

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  late AppCubit appCubit;
  List<String> bookShelves = [
    'For You',
    'Design',
    'Art',
    'Philosophy',
    'Health',
    'Programming',
    'Communication',
    'Fiction',
    'Cooking',
    'Sport',
    'Science'
  ];
  String selectedShelve = 'For You';

  @override
  void initState() {
    appCubit = AppCubit.get(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: _buildHomeScreen,
      listener: _buildListener,
    );
  }

  // Build methods
  Widget _buildHomeScreen(BuildContext context, state) {
    return BasicLayout(
      title: 'Home Screen',
      titleWidget: const CustomText(
        'Good morning',
        color: Colors.white,
      ),
      showBackButton: false,
      isPinned: false,
      extendBody: false,
      appBarBackground: const Color(0xFF282828),
      actions: [
        _buildAddButton(),
      ],
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF282828),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        _buildContinueReadingSection(),
                        const SizedBox(height: 36.0),
                        _buildDailyQuoteSection(),
                        const SizedBox(height: 24.0),
                        _buildBooksShelvesSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64.0),
                  _buildReadingStatuesList(),
                ],
              ),
            ],
          ),
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
        borderColor: AppColors.lightGrey.withOpacity(0.4),
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
        borderColor: AppColors.lightGrey.withOpacity(0.3),
        onTap: () {
          // close the bottom sheet
          Navigator.pop(context);
        },
      ),
      BottomSheetItem(
        icon: const Icon(Icons.edit_note_outlined),
        label: 'Add manually',
        borderColor: AppColors.lightGrey.withOpacity(0.4),
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
      padding: const EdgeInsets.all(4.0),
      height: 240,
      width: MediaQuery.sizeOf(context).width,
      child: ConditionalBuilder(
        condition: false,
        builder: (context) => Swiper(
          itemCount: 3,
          scale: 0.9,
          itemBuilder: (context, index) {
            return _buildReadingBookCard();
          },
        ),
        fallback: (context) => _buildReadingBookCard(isEmpty: true),
      ),
    );
  }

  Widget _buildReadingBookCard({bool isEmpty = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          RotationTransition(
            turns: const AlwaysStoppedAnimation(-2.6 / 360),
            child: CustomContainer(
              color: AppColors.lightWhite.withOpacity(0.5),
            ),
          ),
          CustomContainer(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.lightWhite,
            child: ConditionalBuilder(
              condition: isEmpty == false,
              builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  const BookBox(
                    width: 121,
                    height: 190,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            'The Almanack of naval ravikant',
                            maxLines: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText('page 230 of 345'),
                                  CustomText('63%'),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              CustomContainer(
                                padding: const EdgeInsets.all(6.0),
                                color: AppColors.lightGrey,
                                borderRadius: 12.0,
                                child: LinearPercentIndicator(
                                  lineHeight: 8.0,
                                  percent: 0.63,
                                  barRadius: const Radius.circular(4.0),
                                  backgroundColor: Colors.white,
                                  progressColor: AppColors.grey,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomButton(
                                text: 'Continue Reading',
                                styleType: ButtonStyleType.ghost,
                                width: 140,
                                child: CustomText(
                                  'Continue Reading',
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
              fallback: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomContainer(
                      height: 120,
                      width: 120,
                      borderRadius: 60,
                      color: AppColors.lightGrey,
                      padding: const EdgeInsets.all(32.0),
                      child: SvgPicture.asset(AppIcons.addOutline,colorFilter: const ColorFilter.mode(AppColors.grey, BlendMode.srcIn,),)
                    ),
                    const Text('Add books you are reading'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
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
              CustomContainer(
                color: Colors.white,
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.symmetric(
                    horizontal: 36.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      'They are many names for the future; weak call it impossible, afraid people call it  unknown. but for braves it’s the ...',
                      color: AppColors.grey,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                    ),
                    CustomText(
                      '- Plato',
                      color: AppColors.grey.withOpacity(0.6),
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
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText('Books Shelves',
                      fontSize: 20, fontWeight: FontWeight.w500),
                  CustomText(
                    'Browse all',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 140,
              child: Swiper(
                itemCount: 3,
                scale: 0.9,
                viewportFraction: 0.85,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomContainer(
                        color: Colors.white,
                        width: MediaQuery.sizeOf(context).width,
                        borderRadius: 6.0,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomText(
                              'Book Shelf Name',
                              fontSize: 18,
                            ),
                            CustomText(
                              '12 books',
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 200,
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 0,
                              top: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654371463i/18144590.jpg',
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654371463i/18144590.jpg',
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654371463i/18144590.jpg',
                                width: 70,
                                height: 105,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadingStatuesList() {
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
      borderColor: AppColors.lightGrey.withOpacity(0.8),
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
              color: AppColors.grey,
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
                  color: AppColors.lightGrey.withOpacity(0.6),
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  height: 1,
                )
              : const SizedBox();
        },
        itemCount: readingStatus.length,
      ),
    );
  }

  // Listener method
  void _buildListener(BuildContext context, state) {}
}
