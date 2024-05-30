import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_alert.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_list_item.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/library_edit_book_app_bar.dart';

class LibraryEditBookScreen extends StatefulWidget {
  final Book book;

  const LibraryEditBookScreen({super.key, required this.book});

  @override
  State<LibraryEditBookScreen> createState() => _LibraryEditBookScreenState();
}

class _LibraryEditBookScreenState extends State<LibraryEditBookScreen> {
  BookType selectedBookType = BookType.paperBook;
  List<Map<String, dynamic>> selectedBooksShelves = [];
  List<String> selectedTags = [];
  List<String> tempSelectedTags = [];
  List<Map<String, dynamic>> tempSelectedBooksShelves = [];
  List<Map<String, dynamic>> booksShelvesSearchResult = [];
  List<String> tagsSearchResult = [];
  final List<Map<String, dynamic>> booksShelves = [];
  final List<String> tagsList = [];
  bool invalidStartDate = false;
  bool invalidFinishDate = false;
  bool invalidPagesCount = false;
  bool invalidData = false;

  // controllers
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController totalPagesController;
  late TextEditingController isbnController;
  late TextEditingController publishedAtController;
  late TextEditingController descriptionController;
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController searchBooksShelvesController =
      TextEditingController();
  final TextEditingController searchTagsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // set default form controllers value
    titleController = TextEditingController(text: widget.book.title);
    authorController = TextEditingController(text: widget.book.author);
    totalPagesController =
        TextEditingController(text: widget.book.totalPages.toString());
    publishedAtController =
        TextEditingController(text: widget.book.publishDate);
    descriptionController =
        TextEditingController(text: widget.book.description);
    isbnController = TextEditingController(text: widget.book.isbn);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            LibraryEditBookAppBar(
              imageUri: widget.book.coverURI ?? '',
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: Column(
                  children: [
                    _buildBookTypeTabs(),
                    _buildBookTagsSection(),
                    _buildAddToBooksShelvesSection(),
                    _buildBookInfoFields(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
              children: getBookTypes()
                  .map((status) => Expanded(
                        child: _buildTab(
                          getBookTypeAsString(status),
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
        if (getBookType(type) != selectedBookType) {
          setState(() {
            selectedBookType = getBookType(type);
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

  Widget _buildNewTagBottomSheetButton() {
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
      height: MediaQuery.sizeOf(context).height -
          MediaQuery.paddingOf(context).top -
          4,
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

  void _showAddBooksShelvesBottomSheet(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      height: MediaQuery.sizeOf(context).height -
          MediaQuery.paddingOf(context).top -
          4,
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

  Widget _buildBookInfoFields() {
    final bookFields = [
      {
        "label": "Title",
        "value": widget.book.title,
        "controller": titleController,
      },
      {
        "label": "Author",
        "value": widget.book.author,
        "controller": authorController,
      },
      {
        "label": "Total Pages",
        "value": widget.book.totalPages,
        "type": 'number',
        "controller": totalPagesController,
      },
      {
        "label": "ISBN",
        "value": null,
        "type": 'number',
        "controller": isbnController,
      },
      {
        "label": "Publish Year",
        "value": widget.book.publishDate,
        "type": 'date',
        "controller": publishedAtController,
      },
      {
        "label": "Description",
        "value": widget.book.description,
        "type": 'textarea',
        "controller": descriptionController,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookFields.mapIndexed((index, field) {
          TextEditingController controller =
              field["controller"] as TextEditingController;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomInputField(
              controller: controller,
              label: field['label'].toString(),
              placeholder: "Enter ${field['label']}",
              validator: (value) {
                if (field['label'] == 'Total Pages') {
                  if (value!.isEmpty || int.parse(value) <= 0) {
                    invalidData = true;
                    return 'Invalid total pages';
                  }
                } else if (field['label'] == 'ISBN') {
                  if (value!.isEmpty || !Utils.validISBN(value)) {
                    invalidData = true;
                    return 'Invalid ISBN';
                  }
                } else if (field['label'] == 'Title') {
                  if (value!.isEmpty) {
                    invalidData = true;
                    return 'Title should not be empty';
                  }
                }

                invalidData = false;
                return null;
              },
              dismissibleKeyboard: true,
              keyboardType: field['type'].toString(),
              minLines: field['type'].toString() == 'textarea' ? 3 : null,
              maxLines: field['type'].toString() == 'textarea' ? 20 : null,
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
