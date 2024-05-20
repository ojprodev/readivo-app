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
              color: AppColors.lightYellow,
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
                    const SizedBox(height: 12.0),
                    _buildSuggestionSection(),
                    const SizedBox(height: 12.0),
                    _buildCollectionsSection(),
                    const SizedBox(height: 12.0),
                    _buildBooksAnalytics(),
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
      color: AppColors.lightYellow,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomText(
            text: 'Continue Reading',
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return CustomButton(
      text: 'see all',
      onPressed: () {},
      styleType: ButtonStyleType.ghost,
      width: 60,
      child: const CustomText(
        text: 'See all',
        color: AppColors.lightBlue,
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
    List<Map<String, dynamic>> chips = [
      {'icon': Icons.format_quote, 'label': '300 Quotes'},
      {'icon': Icons.edit_note, 'label': '100 Note'}
    ];
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
        mainAxisSize: MainAxisSize.min,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: chips.map((chip) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: CustomChip(
                      text: chip['label'],
                      icon: chip['icon'],
                      iconColor: AppColors.grey.withOpacity(0.4),
                      backgroundColor: AppColors.lightGrey,
                      textColor: AppColors.grey,
                      padding: const EdgeInsets.all(2.0),
                      borderRadius: 4.0,
                    ),
                  );
                }).toList(),
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
      ],
    );
  }

  Widget _buildSuggestionsHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return const Padding(
      padding: EdgeInsets.only(left: 6.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BookGridItem(),
            BookGridItem(),
            BookGridItem(),
            BookGridItem(),
            BookGridItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCollectionsHeader(),
        _buildCollectionsList(),
      ],
    );
  }

  Widget _buildCollectionsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Collections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildCollectionsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCollectionsItem(),
          _buildCollectionsItem(),
          _buildCollectionsItem(),
        ],
      ),
    );
  }

  Widget _buildCollectionsItem() {
    return Container(
      width: 180,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFff930f), Color(0xFFfff95b)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Stack(
        children: [
          _buildCollectionsText(),
          _buildCollectionsIcon(),
        ],
      ),
    );
  }

  Widget _buildCollectionsText() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cryptocurrencies',
            softWrap: true,
            maxLines: 2,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.white, // Text color
            ),
          ),
          Text(
            '12 books',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white, // Text color
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsIcon() {
    return Positioned(
      bottom: -10,
      right: -8,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: const Icon(
          Icons.currency_bitcoin,
          color: Colors.white, // Icon color
          size: 64,
        ),
      ),
    );
  }

  Widget _buildBooksCountHeader() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Books Analytics',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildBooksAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBooksCountHeader(),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: AppColors.lightGrey,
          child: Column(
            children: [
              _bookAnalyticsItem('Paused Books'),
              _bookAnalyticsItem('Give-Up Books'),
              _bookAnalyticsItem('Local Books'),
              _bookAnalyticsItem('Online Books'),
              _bookAnalyticsItem('Without Collection'),
            ],
          ),
        )
      ],
    );
  }

  Widget _bookAnalyticsItem(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          const Text('12'),
        ],
      ),
    );
  }

  // Listener method
  void _buildListener(BuildContext context, state) {}
}
