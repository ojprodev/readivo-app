import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_states.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_add_book_screen.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_home_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_grid_item.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_list_item.dart';

class LibrarySearchScreen extends StatefulWidget {
  const LibrarySearchScreen({super.key});

  @override
  State<LibrarySearchScreen> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends State<LibrarySearchScreen> {
  late AppCubit appCubit;
  late LibraryCubit libraryCubit;

  @override
  void initState() {
    super.initState();

    appCubit = AppCubit.get(context);
    libraryCubit = LibraryCubit.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: _buildChangeListener,
      builder: _buildLibrarySearchLayout,
    );
  }

  void _buildChangeListener(BuildContext context, state) {}

  Widget _buildLibrarySearchLayout(BuildContext context, state) {
    return BasicLayout(
      title: 'Search Screen',
      appBarBackground: Colors.white,
      isPinned: false,
      leading: CustomButton(
        text: 'back home',
        styleType: ButtonStyleType.ghost,
        child: SvgPicture.asset(AppIcons.chevronLeft),
        onPressed: () {
          // redirect back to home screen
          appCubit.changeScreen(screen: const LibraryHomeScreen());
        },
      ),
      showBackButton: false,
      titleWidget: const CustomInputField(
        placeholder: "Search for a book",
        textInputAction: TextInputAction.search,
        fillColor: AppColors.lightGrey,
        endIcon: Icons.search_outlined,
      ),
      actions: [
        CustomButton(
          text: 'Advanced Search',
          styleType: ButtonStyleType.ghost,
          width: 40,
          child: SvgPicture.asset(AppIcons.adjustments),
          onPressed: () {},
        ),
      ],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildSourceSwitchButton(),
      body: RefreshIndicator(
        strokeWidth: 2,
        displacement: 0,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeadSection(),
              Flexible(
                fit: FlexFit.loose,
                child: ConditionalBuilder(
                  condition: LibraryStates.searchDisplayOption ==
                      SearchDisplayOption.grid,
                  builder: (context) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 240,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        mainAxisExtent: 300,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: 24,
                      itemBuilder: (gridContext, index) => GestureDetector(
                        onTap: () {},
                        child: const BookGridItem(
                          coverWidth: 180,
                          coverHeight: 240,
                          titleFontSize: 16,
                          authorFontSize: 14,
                        ),
                      ),
                    );
                  },
                  fallback: (context) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            appCubit.changeScreen(screen: const LibraryAddBookScreen());
                          },
                          child: BookListItem(key: UniqueKey()),
                        );
                      },
                      // Provide unique keys
                      itemCount: 12,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceSwitchButton() {
    return FloatingActionButton.extended(
      extendedPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      elevation: 2.0,
      tooltip: "Switch Search Source",
      onPressed: () {},
      clipBehavior: Clip.hardEdge,
      enableFeedback: false,
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _switchSourceFab(
            label: 'Online',
            source: SearchSourceEnums.online,
            icon: SvgPicture.asset(
              AppIcons.globeAlt,
              colorFilter: const ColorFilter.mode(
                AppColors.lightBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
          Container(
            height: 55,
            width: 1,
            color: AppColors.lightGrey,
          ),
          _switchSourceFab(
            label: 'Local',
            source: SearchSourceEnums.local,
            append: true,
            icon: const Icon(Icons.sd_storage_rounded, color: AppColors.goldenYellow),
          ),
        ],
      ),
    );
  }

  CustomButton _switchSourceFab({
    required String label,
    required SearchSourceEnums source,
    required Widget icon,
    bool? append,
  }) {
    return CustomButton(
      text: label,
      borderRadius: 0.0,
      onPressed: () {
        libraryCubit.changeSearchSource(source);
      },
      height: 56,
      width: 110,
      color: LibraryStates.searchSource == source ? AppColors.grey : null,
      styleType: LibraryStates.searchSource == source
          ? ButtonStyleType.filled
          : ButtonStyleType.ghost,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ConditionalBuilder(
              condition: append != true,
              builder: (context) => icon,
              fallback: null),
          Text(
            label,
            style: TextStyle(
              color: LibraryStates.searchSource == source
                  ? AppColors.white
                  : Colors.black,
            ),
          ),
          ConditionalBuilder(
              condition: append == true,
              builder: (context) => icon,
              fallback: null),
        ],
      ),
    );
  }

  Widget _buildHeadSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Found 12 Books',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.grey,),
          ),
          IconButton(
            onPressed: () {
              libraryCubit.toggleSearchDisplayOption();
            },
            icon: Icon(
              LibraryStates.searchDisplayOption == SearchDisplayOption.list
                  ? Icons.grid_view_rounded
                  : Icons.format_list_bulleted_sharp,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
