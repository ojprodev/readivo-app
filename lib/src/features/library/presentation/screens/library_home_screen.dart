import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/book_box.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({super.key});

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();

    appCubit = AppCubit.get(context);
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
          children: [
            _buildContinueReadingSection(),
            const SizedBox(height: 12.0),
            _buildSuggestionSection(),
            const SizedBox(height: 12.0),
            _buildCollectionsSection(),
            const SizedBox(
              height: 12.0,
            ),
            _buildBooksAnalytics(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return CustomButton(
      text: 'Library Add Button',
      onPressed: () {},
      styleType: ButtonStyleType.ghost,
      width: 40,
      height: 40,
      borderRadius: 20,
      child: SvgPicture.asset(AppIcons.add),
    );
  }

  Widget _buildContinueReadingSection() {
    return Container(
      color: AppColors.lightGrey,
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Continue Reading',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return CustomButton(
      text: 'view all',
      onPressed: () {},
      styleType: ButtonStyleType.ghost,
      width: 60,
      child: Text(
        'view all',
        style: TextStyle(
          color: AppColors.lightBlue,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.lightBlue,
        ),
      ),
    );
  }

  Widget _buildContinueReadingList() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildReadingBookBox(),
            _buildReadingBookBox(),
            _buildReadingBookBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingBookBox() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: BookBox(),
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          width: 164.0,
          lineHeight: 8.0,
          percent: 0.35,
          barRadius: const Radius.circular(4.0),
          backgroundColor: AppColors.white,
          progressColor: AppColors.grey,
        ),
        const SizedBox(height: 6.0),
        const SizedBox(
          height: 20,
          width: 142.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('35/230p', textAlign: TextAlign.left),
              Text('35%', textAlign: TextAlign.right),
            ],
          ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildReadNextSectionItem(),
            _buildReadNextSectionItem(),
            _buildReadNextSectionItem(),
            _buildReadNextSectionItem(),
            _buildReadNextSectionItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadNextSectionItem() {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookBoxWithRating(),
          const SizedBox(height: 4.0),
          const Text(
            'Book Title',
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Text(
            'Author Name',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookBoxWithRating() {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        BookBox(
          width: 130,
          height: 170,
          background: AppColors.lightGrey,
        ),
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          width: 60,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                AppIcons.microStar,
                colorFilter: ColorFilter.mode(
                  AppColors.goldenYellow,
                  BlendMode.srcIn,
                ),
              ),
              const Text('4.3/5'),
            ],
          ),
        )
      ],
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFff930f), Color(0xFFfff95b)],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
          width: 2,
          color: AppColors.lightGrey,
        ),
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
            color: AppColors.lightGreen.withOpacity(0.2),
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
