import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/animations/animations.dart';

import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/constants/images.dart';
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

class _LibrarySearchScreenState extends State<LibrarySearchScreen>
    with SingleTickerProviderStateMixin {
  late AppCubit appCubit;
  late LibraryCubit libraryCubit;
  SearchDisplayOption searchDisplayOption = SearchDisplayOption.list;
  bool showFilters = false;
  bool initialLoad = true;
  bool isLoading = false;
  List<Book> books = [];
  late AnimationController _loadingController;

  // controllers
  TextEditingController searchBooksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appCubit = AppCubit.get(context);
    libraryCubit = LibraryCubit.get(context);
    initialLoad = true;

    // define the loading animation
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
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
        endIcon: searchBooksController.text.isEmpty
            ? const Icon(Icons.search_outlined)
            : !isLoading
                ? const Icon(Icons.clear_rounded)
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: RotationTransition(
                      turns: _loadingController,
                      child: SvgPicture.asset(AppIcons.reload),
                    ),
                  ),
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
              if (libraryCubit.bookSource == BookSourceEnums.local) {
                libraryCubit.search('');
              }
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
        child: BlocBuilder<LibraryCubit, LibraryStates>(
          builder: (context, state) {
            bool showRefresh = libraryCubit.bookSource == BookSourceEnums.local;

            Widget content = SingleChildScrollView(
              child: Column(
                children: [
                  if (showFilters) _buildFiltersSection(),
                  BlocConsumer<LibraryCubit, LibraryStates>(
                    listener: _buildChangeListener,
                    builder: _buildLibrarySearchContainer,
                  ),
                ],
              ),
            );

            return ConditionalBuilder(
                condition: showRefresh,
                builder: (context) {
                  return RefreshIndicator(
                    strokeWidth: 3,
                    displacement: 0,
                    color: AppColors.grey,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      if (libraryCubit.bookSource == BookSourceEnums.local) {
                        // perform scanning
                        await libraryCubit.performLocalBooksScanning();
                      }
                    },
                    child: content,
                  );
                },
                fallback: (context) => content);
          },
        ),
      ),
    );
  }

  void _buildChangeListener(BuildContext context, state) {
    if (state is LibrarySearchLoadingState) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }

    if (state is LibraryStoragePermissionGrantedState) {
      libraryCubit.performLocalBooksScanning();
    }
    if (state is LibraryStoragePermissionDeniedState) {
      _showStoragePermissionDialog();
    }
    if (state is LibraryNewBookDetectedState) {
      if (!books.any((book) => book.id == state.book.id)) {
        books.add(state.book);
      }
    }

    if (state is LibraryBookSourceChangeState) {
      setState(() {
        showFilters = false;
      });

      if (libraryCubit.bookSource == BookSourceEnums.online) {
        books = libraryCubit.remoteBooks;
      } else {
        books = libraryCubit.localBooks;
        // first time loaded
        if (initialLoad) {
          // fetch local books from the database
          libraryCubit.getLocalBooks();

          // check permission
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
      fallback: !initialLoad
          ? (context) => SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.3,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.reading,
                        width: 240,
                      ),
                      const SizedBox(height: 48.0),
                      const CustomText(
                        'No Books Found!.',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 64.0, vertical: 12.0),
                        child: Text(
                          'Unfortunately we could not find the book you are looking for, would you like to add it?.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const CustomButton(
                        text: 'Add it Manually',
                        width: 200,
                        color: AppColors.grey,
                      )
                    ],
                  ),
                ),
              )
          : null,
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
            'Found $booksCount Books',
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
