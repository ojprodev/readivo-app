import 'package:collection/collection.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_alert.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_list_item.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_cover.dart';

class LibraryAddBookScreen extends StatefulWidget {
  const LibraryAddBookScreen({super.key});

  @override
  State<LibraryAddBookScreen> createState() => _LibraryAddBookScreenState();
}

class _LibraryAddBookScreenState extends State<LibraryAddBookScreen> {
  String selectedStatus = 'Want to read';
  DateTime? startDate;
  DateTime? finishDate;
  List<String> bookTypes = ['paper book', 'e-book', 'audio book'];
  String selectedBookType = 'paper book';
  List<Map<String, dynamic>> selectedBooksShelves = [];
  List<String> selectedTags = [];
  List<String> tempSelectedTags = [];
  List<Map<String, dynamic>> tempSelectedBooksShelves = [];
  List<Map<String, dynamic>> booksShelvesSearchResult = [];
  List<String> tagsSearchResult = [];
  final List<Map<String, dynamic>> booksShelves = [
    {'text': 'Chip 1', 'icon': Icons.star, 'color': Colors.blue},
    {'text': 'Short', 'icon': Icons.ac_unit, 'color': Colors.purple},
    {'text': 'Another', 'icon': Icons.favorite, 'color': Colors.red},
    {'text': 'More', 'icon': Icons.thumb_up, 'color': Colors.green},
    {
      'text': 'This is a very long chip',
      'icon': Icons.alarm,
      'color': Colors.orange
    }
  ];
  final List<String> tagsList = [
    'Fiction',
    'Non-fiction',
    'Mystery',
    'Thriller',
    'Romance',
    'Science Fiction',
    'Fantasy',
    'Historical Fiction',
    'Biography',
    'Autobiography',
    'Memoir',
    'Self-Help',
    'Psychology',
    'Philosophy',
    'Business',
    'Leadership',
    'Entrepreneurship',
    'Finance',
    'Economics',
    'History',
    'Travel',
    'Cooking',
    'Health',
    'Fitness',
    'Parenting',
    'Education',
    'Poetry',
    'Art',
    'Religion',
    'Spirituality',
  ];

  double bottomSheetFullHeight = 0.0;

  // controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController totalPagesController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController publishedAtController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController searchBooksShelvesController =
      TextEditingController();
  final TextEditingController searchTagsController = TextEditingController();

  // handle scroll change
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bottomSheetFullHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        4;
    return BasicLayout(
      extendBody: true,
      appBarBackground:
          _scrollPosition >= 1 ? Colors.white : Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.chevron_left_sharp,
          size: 36,
          color: _scrollPosition >= 1 ? Colors.black : Colors.white,
        ),
      ),
      title: 'Add This Book',
      titleWidget: Text(
        'Add This book',
        style: TextStyle(
          color: _scrollPosition >= 1 ? Colors.black : Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CustomButton(
            text: 'add book',
            color: _scrollPosition >= 1 ? Colors.black : Colors.white,
            onPressed: () {
              // Add book logic here
            },
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.add_circle,
                    color: _scrollPosition >= 1 ? Colors.white : Colors.black),
                Text(
                  'Add',
                  style: TextStyle(
                    color: _scrollPosition >= 1 ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookCoverSection(),
              _buildReadingStatusButton(),
              const SizedBox(height: 8.0),
              _buildReadingDateRange(),
              const SizedBox(height: 8.0),
              _buildRatingSection(),
              _buildBookTypeTabs(),
              _buildAddToBooksShelvesSection(),
              _buildBookTagsSection(),
              _buildBookInfoFields(),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCoverSection() {
    return Container(
      padding: const EdgeInsets.only(top: 36.0),
      height: 350,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 0.8],
          colors: [
            AppColors.grey.withOpacity(0.9),
            AppColors.lightGrey.withOpacity(0.8),
            Colors.white,
          ],
        ),
      ),
      child: const BookCover(
        width: 180,
        height: 260,
        child: BookBox(
          iconSize: 64,
        ),
      ),
    );
  }

  Widget _buildReadingStatusButton() {
    return Center(
      child: CustomButton(
        borderColor: AppColors.grey,
        textColor: AppColors.grey,
        text: 'Reading Status',
        color: Colors.white,
        height: 42,
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                selectedStatus,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
              ),
              child: SvgPicture.asset(
                AppIcons.chevronUpDown,
                colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            )
          ],
        ),
        onPressed: () {
          CustomBottomSheet.show(
            context: context,
            bottomSheetItems: _buildReadingStatusBottomSheet(),
          );
        },
      ),
    );
  }

  List<BottomSheetItem> _buildReadingStatusBottomSheet() {
    return _buildBottomSheetItems([
      'Want to read',
      'Reading',
      'Finished',
      'Gave up',
    ]);
  }

  List<BottomSheetItem> _buildBottomSheetItems(List<String> statuses) {
    return statuses.map((status) {
      return BottomSheetItem(
        borderColor:
        status == selectedStatus ? AppColors.grey : AppColors.lightGrey.withOpacity(0.4),
        icon: _getStatusIcon(status),
        label: status,
        appendIcon: _getAppendIcon(status),
        onTap: () {
          setState(() {
            selectedStatus = status;
          });
          Navigator.of(context).pop();
        },
      );
    }).toList();
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'Want to read':
        return const Icon(
          Icons.library_add_outlined,
          color: AppColors.grey,
        );
      case 'Reading':
        return const Icon(
          Icons.local_library_outlined,
          color: AppColors.grey,
        );
      case 'Finished':
        return const Icon(
          Icons.library_add_check_outlined,
          color: AppColors.grey,
        );
      case 'Gave up':
        return const Icon(
          Icons.flag_outlined,
          color: AppColors.grey,
        );
      default:
        return const Icon(
          Icons.circle_outlined,
          color: AppColors.grey,
        );
    }
  }

  Widget _buildBookTypeTabs() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel('Book Type'),
          const SizedBox(height: 6.0),
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: bookTypes
                  .map((status) => Expanded(
                        child: _buildTab(
                          status,
                          isSelected: status == selectedBookType,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String type, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (type != selectedBookType) {
          setState(() {
            selectedBookType = type;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                  color: AppColors.lightGrey.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 2)
          ],
          color: isSelected
              ? Colors.white
              : Colors.transparent, // Darker background for unselected tabs
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : AppColors.grey // Lighter text color for unselected tabs
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTagsBottomSheetList(StateSetter updateState) {
    List<String> tags =
        searchTagsController.text != '' ? tagsSearchResult : tagsList;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          for (var tag in tags)
            GestureDetector(
              onTap: () {
                updateState(() {
                  if (!tempSelectedTags.contains(tag)) {
                    tempSelectedTags.add(tag);
                  } else {
                    tempSelectedTags.remove(tag);
                  }
                });
              },
              child: CustomChip(
                text: tag,
                textColor: tempSelectedTags.contains(tag) ? Colors.white : null,
                backgroundColor: tempSelectedTags.contains(tag)
                    ? AppColors.grey
                    : AppColors.lightGrey.withOpacity(0.4),
                icon: Icons.local_offer_rounded,
                iconColor: tempSelectedTags.contains(tag)
                    ? AppColors.lightGrey
                    : AppColors.grey.withOpacity(0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddTagsBottomSheetContent(StateSetter updateState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSearchField(
                controller: searchTagsController,
                placeholder: 'Search for a tags',
                onChanged: (value) {
                  updateState(
                    () {
                      if (value.isEmpty) {
                        tagsSearchResult = List.from(tagsList);
                      } else {
                        tagsSearchResult = tagsList.where((tag) {
                          String tagText = tag.toString().toLowerCase();
                          return tagText.contains(value.toLowerCase());
                        }).toList();
                      }
                    },
                  );
                },
              ),
            ),
            _buildNewTagBottomSheetButton(),
          ],
        ),
        _buildAddTagsBottomSheetList(updateState),
      ],
    );
  }
  Widget _buildNewTagBottomSheetButton(){
    return CustomButton(
      text: 'new tag',
      width: 48,
      height: 48,
      borderRadius: 4,
      child: const Icon(Icons.add_circle_rounded, size: 32),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Add New Tag',
            content: const CustomInputField(
              placeholder: 'Tag name',
              contentPadding:
              EdgeInsets.symmetric(horizontal: 6.0, vertical: 14.0),
            ),
            actions: [
              Expanded(
                child: CustomButton(
                  styleType: ButtonStyleType.ghost,
                  text: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              const Expanded(
                child: CustomButton(
                  text: 'Save',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddTagsBottomSheet(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      height: bottomSheetFullHeight,
      showDragHandle: false,
      child: StatefulBuilder(
        builder: (context, updateState) => Column(
          children: [
            _buildBottomSheetHeader(
              context: context,
              title: 'Add Tags',
              tempSelectedList: tempSelectedTags,
              updateFinalSelectedList: (List<dynamic> updatedList) {
                selectedTags = updatedList as List<String>;
              },
            ),
            _buildAddTagsBottomSheetContent(updateState),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetHeader({
    required BuildContext context,
    required String title,
    String submitTitle = 'Save',
    required List<dynamic> tempSelectedList,
    required Function(List<dynamic>) updateFinalSelectedList,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            width: 30,
            text: 'Back',
            styleType: ButtonStyleType.ghost,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.chevron_left,
              size: 36,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomButton(
            width: 80,
            text: submitTitle,
            onPressed: () {
              setState(() {
                searchTagsController.clear();

                updateFinalSelectedList(tempSelectedList);

                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookTagsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInputLabel('Add tags'),
              CustomButton(
                text: 'Add Tags',
                width: 30,
                height: 30,
                styleType: ButtonStyleType.ghost,
                borderRadius: 15,
                onPressed: () {
                  _showAddTagsBottomSheet(context);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          selectedTags.isNotEmpty
              ? Wrap(
                  spacing: 6.0,
                  children: [
                    for (String tag in selectedTags)
                      CustomChip(
                        text: tag,
                        icon: Icons.tag,
                        iconColor: AppColors.grey,
                        backgroundColor: AppColors.lightGrey,
                        deleteIcon: CustomButton(
                          text: 'remove $tag',
                          borderRadius: 18,
                          width: 20,
                          height: 20,
                          color: Colors.redAccent.withOpacity(0.8),
                          child: const Icon(
                            Icons.clear_rounded,
                            size: 18,
                          ),
                        ),
                        onDeleted: () {
                          setState(() {
                            if (selectedTags.contains(tag)) {
                              selectedTags.remove(tag);
                            }
                          });
                        },
                      )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _showAddBooksShelvesBottomSheet(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      height: bottomSheetFullHeight,
      showDragHandle: false,
      child: StatefulBuilder(
        builder: (context, updateState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomSheetHeader(
                context: context,
                title: 'Add to BooksShelves',
                tempSelectedList: tempSelectedBooksShelves,
                updateFinalSelectedList: (List<dynamic> updatedList) {
                  selectedBooksShelves =
                      updatedList as List<Map<String, dynamic>>;
                },
              ),
              _buildAddBooksShelvesBottomSheetContent(context, updateState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddToBooksShelvesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputLabel('Add to a Books Shelves'),
              _buildAddToBookShelfButton(),
            ],
          ),
          selectedBooksShelves.isNotEmpty
              ? _buildBooksShelvesContainer(selectedBooksShelves)
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildAddToBookShelfButton() {
    return CustomButton(
      text: 'Add to a bookshelf',
      width: 30,
      height: 30,
      styleType: ButtonStyleType.ghost,
      borderRadius: 15,
      onPressed: () {
        // fill the temp list with the already selected bookshelf
        tempSelectedBooksShelves = selectedBooksShelves;

        // show the bottom sheet
        _showAddBooksShelvesBottomSheet(context);
      },
      child: const Icon(
        Icons.create_new_folder,
        color: AppColors.goldenYellow,
      ),
    );
  }

  Widget _buildAddBooksShelvesBottomSheetContent(
      BuildContext context, StateSetter updateState) {
    final List<Map<String, dynamic>> bookshelves =
        searchBooksShelvesController.text != ''
            ? booksShelvesSearchResult
            : booksShelves;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSearchField(
                    controller: searchBooksShelvesController,
                    placeholder: 'Search for tags',
                    onChanged: (value) {
                      updateState(() {
                        if (value.isEmpty) {
                          booksShelvesSearchResult = List.from(booksShelves);
                        } else {
                          booksShelvesSearchResult =
                              booksShelves.where((bookShelf) {
                            String bookShelfText =
                                bookShelf['text'].toString().toLowerCase();
                            return bookShelfText.contains(value.toLowerCase());
                          }).toList();
                        }
                      });
                    },
                  ),
                ),
                _buildNewBookShelfBottomSheetButton(),
              ],
            ),
          ),
          _buildBooksShelvesList(context, updateState, bookshelves),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String placeholder,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: CustomInputField(
        controller: controller,
        placeholder: placeholder,
        borderRadius: 8,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
        suffix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: CustomButton(
            text: 'clear search',
            color: AppColors.grey.withOpacity(0.6),
            width: 24,
            height: 24,
            borderRadius: 8,
            child: const Icon(
              Icons.clear_rounded,
              size: 18,
            ),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildBooksShelvesList(BuildContext context, StateSetter updateState,
      List<Map<String, dynamic>> booksShelves) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: booksShelves.length,
          itemBuilder: (context, index) {
            bool isSelected =
                tempSelectedBooksShelves.contains(booksShelves[index]);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomListItem(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 18.0),
                label: booksShelves[index]['text'].toString(),
                iconBackground: isSelected
                    ? AppColors.lighterGreen
                    : AppColors.lightGrey.withOpacity(0.4),
                appendIcon: const Text('12'),
                borderColor: isSelected
                    ? AppColors.lightGreen
                    : AppColors.lightGrey.withOpacity(0.5),
                borderRadius: 12.0,
                backgroundColor:
                    isSelected ? AppColors.extraLightGreen : Colors.white,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                shadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.extraLightGreen.withOpacity(0.2)
                        : AppColors.lightGrey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 4,
                  )
                ],
                onTap: () {
                  updateState(() {
                    if (!tempSelectedBooksShelves
                        .contains(booksShelves[index])) {
                      tempSelectedBooksShelves.add(booksShelves[index]);
                    } else {
                      tempSelectedBooksShelves.remove(booksShelves[index]);
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBooksShelvesContainer(List<Map<String, dynamic>> booksShelves) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: AppColors.lightGrey.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: booksShelves.map((chip) {
          return CustomChip(
            text: chip['text'],
            iconColor: chip['color'],
            backgroundColor: AppColors.lightGrey.withOpacity(0.6),
            borderRadius: 4.0,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSection() {
    return ConditionalBuilder(
      condition: selectedStatus != 'Want to read',
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add rating',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.0)),
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 32,
                    glowColor: AppColors.lightGrey.withOpacity(0.8),
                    unratedColor: AppColors.lightGrey,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: AppColors.goldenYellow,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            CustomInputField(
              controller: reviewController,
              label: 'Write a review',
              placeholder: 'Add your review for this book',
              keyboardType: 'textarea',
              minLines: 3,
              maxLines: 10,
            ),
          ],
        ),
      ),
      fallback: null,
    );
  }

  Widget _buildNewBookShelfBottomSheetButton() {
    return CustomButton(
      text: 'new bookshelf',
      width: 48,
      height: 48,
      borderRadius: 4,
      child: const Icon(Icons.add_circle_rounded, size: 32),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'New Books Shelf',
            content: const CustomInputField(
              placeholder: 'BookShelf name',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 6.0, vertical: 14.0),
            ),
            actions: [
              Expanded(
                child: CustomButton(
                  styleType: ButtonStyleType.ghost,
                  text: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              const Expanded(
                child: CustomButton(
                  text: 'Save',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadingDateRange() {
    return ConditionalBuilder(
      condition: selectedStatus != 'Want to read',
      builder: (context) => Center(
        child: Container(
          width: selectedStatus == 'Reading' ? 180 : null,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.lightGrey, width: 2),
          ),
          child: Row(
            children: [
              _buildDateColumn(
                'Started',
                startDate,
                'Start Date',
                () => _pickDate(context, startDate, (date) {
                  setState(() {
                    startDate = date;
                  });
                }),
              ),
              Container(
                width: 2,
                height: 64,
                color: selectedStatus != 'Reading'
                    ? AppColors.lightGrey
                    : Colors.transparent,
              ),
              if (selectedStatus != 'Want to read' &&
                  selectedStatus != 'Reading')
                _buildDateColumn(
                  'Finished',
                  finishDate,
                  'Finish Date',
                  () => _pickDate(context, finishDate, (date) {
                    setState(() {
                      finishDate = date;
                    });
                  }),
                ),
            ],
          ),
        ),
      ),
      fallback: null,
    );
  }

  void _pickDate(BuildContext context, DateTime? currentDate,
      Function(DateTime) onConfirm) async {
    await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(DateTime.now().year - 100),
      maxTime: DateTime.now(),
      onConfirm: onConfirm,
      currentTime: DateTime.now(),
    );
  }

  Widget _buildDateColumn(
      String title, DateTime? date, String buttonText, Function() onPressed) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(title),
          CustomButton(
            width: 120,
            text: buttonText,
            styleType: ButtonStyleType.ghost,
            onPressed: onPressed,
            child: ConditionalBuilder(
              condition: date != null,
              builder: (context) => Text(
                formatDate(date!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey, fontSize: 20),
              ),
              fallback: (context) => const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.grey,
                  ),
                  Text(
                    'Add Date',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppendIcon(String status) {
    return Icon(
      selectedStatus == status ? Icons.check_circle : Icons.circle_outlined,
      color: selectedStatus == status ? AppColors.grey : AppColors.lightGrey.withOpacity(0.4),
    );
  }

  Widget _buildBookInfoFields() {
    final bookFields = [
      {
        "label": "Title",
        "value": 'The Alchemist',
        "controller": titleController,
        "defaultValue": 'The Alchemist',
      },
      {
        "label": "Author",
        "value": 'Paulo Coelho',
        "controller": authorController,
        "defaultValue": 'Paulo Coelho',
      },
      {
        "label": "Total Pages",
        "value": '196',
        "type": 'number',
        "controller": totalPagesController,
        "defaultValue": '196',
      },
      {
        "label": "ISBN",
        "value": '12233445566',
        "type": 'number',
        "controller": isbnController,
        "defaultValue": '12233445566',
      },
      {
        "label": "Publish date",
        "value": '1996',
        "type": 'date',
        "controller": publishedAtController,
        "defaultValue": '1996',
      },
      {
        "label": "Description",
        "value": 'book description',
        "type": 'textarea',
        "controller": descriptionController,
        "defaultValue": 'book description',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookFields.mapIndexed((index, field) {
          TextEditingController controller =
              field["controller"] as TextEditingController;

          if (field['defaultValue'] != null) {
            controller.text = field['defaultValue'].toString();
          }
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomInputField(
              controller: controller,
              label: field['label'].toString(),
              placeholder: 'Enter text',
              keyboardType: field['type'].toString(),
              minLines: field['type'].toString() == 'textarea' ? 3 : null,
              maxLines: field['type'].toString() == 'textarea' ? 30 : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 14.0, bottom: 4.0, left: 2.0, right: 2.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
