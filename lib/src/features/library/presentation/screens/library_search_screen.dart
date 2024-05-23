import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/services/permission_service.dart';
import 'package:readivo_app/src/core/widgets/custom_alert.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_add_book_screen.dart';
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
  SearchDisplayOption searchDisplayOption = SearchDisplayOption.list;
  bool showFilters = false;
  bool initialLoad = true;
  List<Book> books = [];

  // controllers
  TextEditingController searchBooksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appCubit = AppCubit.get(context);
    libraryCubit = LibraryCubit.get(context);
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
      title: 'Search Screen',
      isPinned: false,
      leading: CustomButton(
        text: 'back home',
        styleType: ButtonStyleType.ghost,
        child: SvgPicture.asset(AppIcons.chevronLeft),
        onPressed: () {
          // redirect to previous screen
          Navigator.of(context).pop();
        },
      ),
      showBackButton: false,
      titleWidget: CustomInputField(
        controller: searchBooksController,
        placeholder: "Search for a book",
        textInputAction: TextInputAction.search,
        fillColor: AppColors.lightGrey.withOpacity(0.4),
        endIcon: searchBooksController.text.isNotEmpty
            ? Icons.clear_rounded
            : Icons.search_outlined,
        maxLines: 1,
        onChanged: (value) {
          setState(() {
            searchBooksController.text = value;
          });
        },
        onSubmit: (query) {
          libraryCubit.search(query);
        },
        onEndIconPress: () {
          if (searchBooksController.text.isNotEmpty) {
            setState(() {
              searchBooksController.clear();
            });
          }
        },
        contentPadding: const EdgeInsets.all(8.0),
      ),
      actions: [
        CustomButton(
          text: 'Advanced Search',
          styleType: ButtonStyleType.ghost,
          width: 40,
          child: SvgPicture.asset(AppIcons.adjustments),
          onPressed: () {
            setState(() {
              showFilters = !showFilters;
            });
          },
        ),
      ],
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          strokeWidth: 3,
          displacement: 0,
          color: AppColors.grey,
          onRefresh: () async {
             // perform scanning
            await libraryCubit.performLocalBooksScanning();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (showFilters) _buildFiltersSection(),
                BlocConsumer<LibraryCubit, LibraryStates>(
                  listener: _buildChangeListener,
                  builder: _buildLibrarySearchContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buildChangeListener(BuildContext context, state) {
    if (state is LibraryStoragePermissionGrantedState) {
      libraryCubit.performLocalBooksScanning();
    }
    if (state is LibraryStoragePermissionDeniedState) {
      _showStoragePermissionDialog();
    }
    if (state is LibraryNewBookDetectedState) {
      if(!books.any((book) => book.id == state.book.id)){
        books.add(state.book);
      }
    }

    if (state is LibraryBookSourceChangeState) {
      if (libraryCubit.bookSource == BookSourceEnums.online) {
        books = libraryCubit.remoteBooks;
      } else {
        books = libraryCubit.localBooks;
        // first time loaded
        if (initialLoad) {

          // perform scanning
          libraryCubit.handleStoragePermission(action: PermissionAction.check);

          // prevent reputation
          setState(() {
            initialLoad = false;
          });
        }
      }
    }
  }

  Widget _buildLibrarySearchContainer(BuildContext context, state) {
    if (state is LibrarySearchLoadedState) {
      books = state.books;
    }

    return ConditionalBuilder(
      condition: books.isNotEmpty,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeadSection(booksCount: books.length),
            _buildSearchList(books: books),
          ],
        );
      },
      fallback: (context) => const Text('Empty library'),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      color: AppColors.lightGrey.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Source'),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      styleType:
                          libraryCubit.bookSource == BookSourceEnums.online
                              ? ButtonStyleType.filled
                              : ButtonStyleType.outline,
                      color: AppColors.grey,
                      text: 'Online',
                      onPressed: () {
                        setState(() {
                          libraryCubit
                              .changeBookSearchSource(BookSourceEnums.online);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: CustomButton(
                      styleType:
                          libraryCubit.bookSource == BookSourceEnums.local
                              ? ButtonStyleType.filled
                              : ButtonStyleType.outline,
                      color: AppColors.grey,
                      text: 'Local',
                      onPressed: () {
                        setState(() {
                          libraryCubit
                              .changeBookSearchSource(BookSourceEnums.local);
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeadSection({required int booksCount}) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: 'Found $booksCount Books',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.grey,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (searchDisplayOption == SearchDisplayOption.list) {
                  searchDisplayOption = SearchDisplayOption.grid;
                } else {
                  searchDisplayOption = SearchDisplayOption.list;
                }
              });
            },
            icon: Icon(
              searchDisplayOption == SearchDisplayOption.list
                  ? Icons.grid_view_rounded
                  : Icons.format_list_bulleted_sharp,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchList({required List<Book> books}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: ConditionalBuilder(
        condition: searchDisplayOption == SearchDisplayOption.grid,
        builder: (context) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              mainAxisExtent: 310,
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: books.length,
            itemBuilder: (gridContext, index) => GestureDetector(
              onTap: () {
                appCubit.changeScreen(LibraryAddBookScreen(
                  book: books[index],
                ));
              },
              child: BookGridItem(
                book: books[index],
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
            itemCount: books.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  appCubit.changeScreen(LibraryAddBookScreen(
                    book: books[index],
                  ));
                },
                child: BookListItem(
                  key: UniqueKey(),
                  book: books[index],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showStoragePermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        showTitle: false,
        title: 'Storage Permission Needed',
        contentPadding: EdgeInsets.zero,
        content: const Column(
          children: [
            Text('Storage Permission'),
            Text(
                'We need you to grant storage permission in order to perform a scan for books available in your device'),
          ],
        ),
        actions: [
          Expanded(
            child: CustomButton(
              text: 'Cancel',
              styleType: ButtonStyleType.ghost,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            width: 6.0,
          ),
          Expanded(
            child: CustomButton(
              text: 'Grant Permission',
              onPressed: () {
                // redirect to the storage permission setting
                libraryCubit.handleStoragePermission(
                    action: PermissionAction.request);

                // close the alert
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
