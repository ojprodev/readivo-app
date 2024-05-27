import 'package:card_swiper/card_swiper.dart';
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
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
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
      title: 'Good morning',
      showBackButton: false,
      isPinned: false,
      appBarBackground: Colors.white,
      actions: [
        _buildAddButton(),
      ],
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildContinueReadingSection(),
            Container(
              color: AppColors.lightGrey.withOpacity(0.4),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSuggestionSection(),
                    _buildReadingStatuesList(),
                  ],
                ),
              ),
            )
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
      child: SvgPicture.asset(AppIcons.add),
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
    return Container(
      color: Colors.black,
      height: 300.0,
      child: Column(
        children: [
          _buildContinueReadingHeader(),
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
            fontWeight: FontWeight.w400,
          ),
          CustomText(
            'See all',
            fontSize: 16,
            color: AppColors.lightBlue,
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
      child: Swiper(
        itemCount: 3,
        scale: 0.9,
        itemBuilder: (context, index) {
          return _buildReadingBookCard();
        },
      ),
    );
  }

  Widget _buildReadingBookCard() {
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
            child: Row(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionSection() {
    return Column(
      children: [
        _buildSuggestionsHeader(),
        _buildSuggestionsList(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: CustomButton(
            text: 'Browse More',
            color: AppColors.lightGrey,
            textColor: AppColors.grey,
            borderRadius: 4.0,
            width: MediaQuery.sizeOf(context).width / 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('Suggestions',
                  fontSize: 20, fontWeight: FontWeight.w500),
              CustomText('Browse all', color: AppColors.lightBlue),
            ],
          ),
          const SizedBox(height: 6.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: bookShelves.map((item) {
                return Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedShelve = item;
                      });
                    },
                    child: CustomChip(
                      text: item,
                      borderRadius: 4.0,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      backgroundColor: selectedShelve == item
                          ? AppColors.lightGrey.withOpacity(0.4)
                          : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 170,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 0.0,
        mainAxisExtent: 230,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: 5,
      itemBuilder: (gridContext, index) => GestureDetector(
        onTap: () {},
        child: const SizedBox(),
        // const BookGridItem(
        //   coverWidth: 140,
        //   coverHeight: 170,
        //   titleFontSize: 16,
        //   authorFontSize: 14,
        // ),
      ),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.0),
      ),
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
