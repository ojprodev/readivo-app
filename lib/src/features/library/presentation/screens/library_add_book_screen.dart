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
  List<String> selectedCollections = [];
  List<Map<String, dynamic>> collectionsSearchResult = [];
  final List<Map<String, dynamic>> collectionsList = [
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

  // controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController totalPagesController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController publishedAtController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController searchCollectionsController = TextEditingController();

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
              _buildAddToCollectionSection(),
              _buildBookTagsSection(),
              _buildBookInfoFields(),
              const SizedBox(height: 8.0),
            ],
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
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputLabel('Add tags'),
              CustomButton(
                text: 'Add to a Collection',
                width: 30,
                height: 30,
                styleType: ButtonStyleType.ghost,
                borderRadius: 15,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Wrap(
            spacing: 6.0,
            children: [
              buildCustomChip(
                  text: 'love',
                  icon: Icons.tag,
                  iconColor: AppColors.grey,
                  backgroundColor: AppColors.lightGrey),
              buildCustomChip(
                  text: 'business',
                  icon: Icons.tag,
                  iconColor: AppColors.grey,
                  backgroundColor: AppColors.lightGrey),
              buildCustomChip(
                  text: 'life',
                  icon: Icons.tag,
                  iconColor: AppColors.grey,
                  backgroundColor: AppColors.lightGrey),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddToCollectionBottomSheet(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          4,
      showDragHandle: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAddCollectionsBottomSheetHeader(context),
              _buildAddCollectionsBottomSheetContent(context, setState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddToCollectionSection() {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputLabel('Add to a Collection'),
              _buildAddToCollectionButton(),
            ],
          ),
          _buildCollectionsContainer(collectionsList),
        ],
      ),
    );
  }

  Widget _buildAddToCollectionButton() {
    return CustomButton(
      text: 'Add to a Collection',
      width: 30,
      height: 30,
      styleType: ButtonStyleType.ghost,
      borderRadius: 15,
      onPressed: () {
        _showAddToCollectionBottomSheet(context);
      },
      child: const Icon(Icons.create_new_folder),
    );
  }

  Widget _buildAddCollectionsBottomSheetHeader(BuildContext context) {
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
          const Text(
            'Add to Collections',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomButton(
            width: 80,
            text: 'Add',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAddCollectionsBottomSheetContent(
      BuildContext context, StateSetter setState) {
    final collections = collectionsSearchResult.isNotEmpty
        ? collectionsSearchResult
        : collectionsList;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAddCollectionsSearchField(setState),
          _buildCollectionsList(context, setState, collections),
        ],
      ),
    );
  }

  Widget _buildAddCollectionsSearchField(StateSetter setState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: AppColors.lightGrey.withOpacity(0.2),
      child: CustomInputField(
        controller: searchCollectionsController,
        placeholder: 'Search for a collection',
        borderRadius: 24,
        suffix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomButton(
            text: 'clear collection search',
            color: AppColors.grey.withOpacity(0.6),
            width: 24,
            height: 24,
            borderRadius: 12,
            child: const Icon(
              Icons.clear_rounded,
              size: 18,
            ),
            onPressed: () {
              setState((){
                searchCollectionsController.clear();
                collectionsSearchResult = [];
              });
            },
          ),
        ),
        onChanged: (value) {
          setState(() {
            if (value.isEmpty) {
              collectionsSearchResult = List.from(collectionsList);
            } else {
              collectionsSearchResult = collectionsList.where((collection) {
                String collectionText =
                    collection['text'].toString().toLowerCase();
                return collectionText.contains(value.toLowerCase());
              }).toList();
            }
          });
        },
      ),
    );
  }

  Widget _buildCollectionsList(BuildContext context, StateSetter setState,
      List<Map<String, dynamic>> collections) {
    return Expanded(
      child: Container(
        color: AppColors.lightGrey.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: collections.length,
          itemBuilder: (context, index) {
            bool isSelected =
                selectedCollections.contains(collections[index]['text']);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomListItem(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                label: collections[index]['text'].toString(),
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
                icon: Icon(
                  collections[index]['icon'],
                  size: 24,
                  color: collections[index]['color'],
                ),
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
                    blurRadius: 4,
                    spreadRadius: 4,
                  )
                ],
                onTap: () {
                  setState(() {
                    if (!selectedCollections
                        .contains(collections[index]['text'])) {
                      selectedCollections.add(collections[index]['text']);
                    } else {
                      selectedCollections.remove(collections[index]['text']);
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

  Widget _buildCollectionsContainer(List<Map<String, dynamic>> collections) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: AppColors.lightGrey,
          width: 2,
        ),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: collections.map((chip) {
          return buildCustomChip(
            text: chip['text'],
            icon: chip['icon'],
            iconColor: chip['color'],
            backgroundColor: AppColors.lightGrey.withOpacity(0.6),
            borderRadius: 8.0,
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
            Colors.red.withOpacity(0.9),
            Colors.yellow.withOpacity(0.8),
            Colors.white,
          ],
        ),
      ),
      child: const BookCover(
        width: 180,
        height: 260,
        child: BookBox(
          coverUrl:
              "https://booksondemand.ma/cdn/shop/products/81ioPZFMeUL-min.jpg?v=1631701482",
        ),
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
            status == selectedStatus ? AppColors.grey : AppColors.lightGrey,
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

  Widget _getAppendIcon(String status) {
    return Icon(
      selectedStatus == status ? Icons.check_circle : Icons.circle_outlined,
      color: selectedStatus == status ? AppColors.grey : AppColors.lightGrey,
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
}
