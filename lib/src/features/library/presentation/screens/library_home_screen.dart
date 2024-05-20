import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_search_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_grid_item.dart';

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
    ' Programming',
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
        onTap: () {
          // close the bottom sheet
          Navigator.pop(context);
        },
      ),
      BottomSheetItem(
        icon: const Icon(Icons.edit_note_outlined),
        label: 'Add manually',
        onTap: () {
          // Handle add manually
        },
      ),
    ];
  }

  Widget _buildContinueReadingSection() {
    return Container(
      color: AppColors.lightGrey.withOpacity(0.4),
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
            text: 'Continue Reading',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          CustomText(
            text: 'See all',
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
    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      margin: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 8.0),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: OverflowBox(
              alignment: Alignment.centerRight,
              maxWidth: double.infinity,
              minWidth: 130,
              child: Container(
                margin: const EdgeInsets.only(right: 12.0),
                child: const BookBox(
                  borderRadius: 6.0,
                  width: 130,
                  coverUrl:
                      'https://m.media-amazon.com/images/I/61HAE8zahLL._AC_UF1000,1000_QL80_.jpg',
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'The Alchemist',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      CustomText(
                        text: 'By Paulo Coelho',
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            size: 16,
                          ),
                          SizedBox(width: 4.0),
                          CustomText(text: '2 weeks'),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(text: '5 Quotes', color: AppColors.grey),
                            CustomText(text: '3 Notes', color: AppColors.grey),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      LinearPercentIndicator(
                        width: 200.0,
                        lineHeight: 12.0,
                        percent: 0.35,
                        barRadius: const Radius.circular(6.0),
                        backgroundColor: AppColors.lightGrey,
                        progressColor: AppColors.grey,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8.0),
                      const CustomText(text: '35%', fontSize: 14),
                    ],
                  ),
                  const CustomButton(
                    text: 'Start a session',
                    color: AppColors.grey,
                    width: 240,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: CustomText(
                          text: 'Start a Session',
                          textAlign: TextAlign.center,
                        )),
                        CustomButton(
                          text: 'start session icon',
                          width: 40,
                          color: Colors.black,
                          child: Icon(Icons.play_circle_fill_rounded),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
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
              CustomText(
                text: 'Suggestions',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: 'Browse all',
                color: AppColors.lightBlue,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: bookShelves.map((item) {
                return Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedShelve = item;
                      });
                    },
                    child: CustomChip(
                      text: item,
                      borderRadius: 4.0,
                      backgroundColor: selectedShelve == item
                          ? AppColors.lightGrey.withOpacity(0.6)
                          : Colors.transparent,
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
        child: const BookGridItem(
          coverWidth: 140,
          coverHeight: 170,
          titleFontSize: 16,
          authorFontSize: 14,
        ),
      ),
    );
  }

  // Listener method
  void _buildListener(BuildContext context, state) {}
}
