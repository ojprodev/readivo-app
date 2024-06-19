import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/icons.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/core/widgets/star_rating.dart';
import 'package:readivo_app/src/core/widgets/toast.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_edit_book_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_cover.dart';

class LibraryAddBookScreen extends StatefulWidget {
  final Book book;
  final TextEditingController reviewController = TextEditingController();

  LibraryAddBookScreen({super.key, required this.book});

  @override
  State<LibraryAddBookScreen> createState() => _LibraryAddBookScreenState();
}

class _LibraryAddBookScreenState extends State<LibraryAddBookScreen> {
  late ReadingStatus selectedReadingStatus;
  bool isReadingStatusActive = false;
  bool invalidStartDate = false;
  bool invalidFinishDate = false;
  bool invalidPagesCount = false;
  bool invalidData = false;
  DateTime? startDate;
  DateTime? finishDate;
  bool showFullDescription = false;
  late LibraryCubit libraryCubit;

  @override
  void initState() {
    super.initState();

    libraryCubit = LibraryCubit.get(context);

    // init vars
    selectedReadingStatus =
        widget.book.readingStatus ?? ReadingStatus.wantToRead;
    isReadingStatusActive = widget.book.readingStatus != null;
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BasicLayout(
      title: 'Add Book',
      isPinned: false,
      isTransparent: true,
      titleWidget: const SizedBox(),
      extendBody: true,
      leadingWidth: 54,
      leading: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
        child: CustomButton(
          text: 'Back',
          borderRadius: 40,
          color: Colors.black.withOpacity(0.3),
          onPressed: () {
            appCubit.previousScreen();
          },
          child: SvgPicture.asset(
            AppIcons.chevronLeft,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CustomButton(
            text: 'Edit',
            width: 40,
            height: 40,
            borderRadius: 30,
            color: Colors.black.withOpacity(0.3),
            onPressed: () {
              appCubit.changeScreen(LibraryEditBookScreen(book: widget.book),
                  enableBack: false);
            },
            child: SvgPicture.asset(
              AppIcons.edit,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ],
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBookCoverSection(),
              const SizedBox(height: 16),
              _buildBookTitleAndAuthor(),
              const SizedBox(height: 16.0),
              _buildReadingStatusButton(),
              if(selectedReadingStatus != ReadingStatus.wantToRead)
              CustomContainer(
                color: Colors.grey.withOpacity(0.15),
                padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
                margin: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    _buildReadingDateRange(),
                    const SizedBox(height: 16.0),
                    if (selectedReadingStatus == ReadingStatus.finished ||
                        selectedReadingStatus == ReadingStatus.gaveUp)
                      _buildAddRatingButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              _buildBookInfoCard(),
              const SizedBox(height: 24),
              if (widget.book.description != null &&
                  widget.book.description!.isNotEmpty)
                _buildBookDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCoverSection() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Blurred background image with gradient
        SizedBox(
          height: 340.0,
          width: double.infinity,
          child: _buildBlurredImageWithGradient(widget.book.coverURI ?? ''),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: BookCover(
            width: 170,
            height: 250,
            child: BookBox(
              coverUri: widget.book.coverURI ?? '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlurredImageWithGradient(String uri) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0.0), // Ensure no rounded corners
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: Utils.determineImageProviderByUri(uri),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.white.withOpacity(0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookTitleAndAuthor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          CustomText(
            widget.book.title,
            fontSize: 20,
            maxLines: 3,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          CustomText(
            widget.book.author ?? 'unknown',
            color: Colors.grey,
          ),
          const SizedBox(height: 6.0),
          if (widget.book.globalRating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StarRating(rating: widget.book.globalRating ?? 0),
                const SizedBox(width: 6.0),
                CustomText(
                  '${widget.book.globalRating ?? 0}/5',
                  fontWeight: FontWeight.w500,
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildReadingStatusButton() {
    return Center(
      child: CustomButton(
        borderColor:
            isReadingStatusActive ? Colors.black87 : Colors.transparent,
        textColor: isReadingStatusActive ? Colors.black87 : Colors.white,
        text: 'Reading Status',
        color: isReadingStatusActive ? Colors.white : Colors.black87,
        height: 42,
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomText(
                getReadingStatusAsString(selectedReadingStatus),
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            CustomButton(
              width: 40,
              text: 'Change Reading Status',
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.black,
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
              ),
              onPressed: () {
                CustomBottomSheet.show(
                  context: context,
                  bottomSheetItems: _buildReadingStatusBottomSheet(),
                );
              },
            )
          ],
        ),
        onPressed: () {
          // change the active status state
          setState(() {
            isReadingStatusActive = !isReadingStatusActive;
            if (isReadingStatusActive) {
              widget.book.readingStatus = selectedReadingStatus;
            } else {
              widget.book.readingStatus = null;
            }
            libraryCubit.updateBook(widget.book);
          });

          String readingStatus =
              getReadingStatusAsString(selectedReadingStatus);
          // show informing toast
          if (isReadingStatusActive) {
            Toast.show(
                context: context,
                message: 'Book added to $readingStatus list',
                backgroundColor: Colors.grey);
          } else {
            Toast.show(
                context: context,
                message: 'Book removed from the $readingStatus list',
                backgroundColor: Colors.grey);
          }
        },
      ),
    );
  }

  List<BottomSheetItem> _buildReadingStatusBottomSheet() {
    return getReadingStatuesList().map((status) {
      return BottomSheetItem(
        borderColor: status == selectedReadingStatus
            ? Colors.black
            : Colors.grey.withOpacity(0.4),
        icon: _getReadingStatusIcon(status),
        label: getReadingStatusAsString(status),
        appendIcon: _getReadingBottomSheetSelectedItemIcon(status),
        onTap: () {
          setState(() {
            selectedReadingStatus = status;
            if (isReadingStatusActive == false) {
              isReadingStatusActive = true;
            }

            // sync status on the db
            libraryCubit.updateBook(widget.book..readingStatus = status);
          });

          Toast.show(
              context: context,
              message:
                  'Book added to ${getReadingStatusAsString(selectedReadingStatus)} list',
              backgroundColor: Colors.grey);

          Navigator.of(context).pop();
        },
      );
    }).toList();
  }

  Widget _getReadingStatusIcon(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.wantToRead:
        return const Icon(
          Icons.library_add_outlined,
          color: Colors.grey,
        );
      case ReadingStatus.paused:
        return const Icon(
          Icons.pause_rounded,
          color: Colors.grey,
        );
      case ReadingStatus.reading:
        return const Icon(
          Icons.local_library_outlined,
          color: Colors.grey,
        );
      case ReadingStatus.finished:
        return const Icon(
          Icons.library_add_check_outlined,
          color: Colors.grey,
        );
      case ReadingStatus.gaveUp:
        return const Icon(
          Icons.flag_outlined,
          color: Colors.grey,
        );
      default:
        return const Icon(
          Icons.circle_outlined,
          color: Colors.grey,
        );
    }
  }

  Widget _getReadingBottomSheetSelectedItemIcon(ReadingStatus status) {
    return Icon(
      selectedReadingStatus == status
          ? Icons.check_circle
          : Icons.circle_outlined,
      color: selectedReadingStatus == status
          ? Colors.black
          : Colors.grey.withOpacity(0.4),
    );
  }

  Widget _buildReadingDateRange() {
    return ConditionalBuilder(
      condition: selectedReadingStatus != ReadingStatus.wantToRead,
      builder: (context) => Center(
        child: Column(
          children: [
            Container(
              width: selectedReadingStatus == ReadingStatus.reading ||
                      selectedReadingStatus == ReadingStatus.paused
                  ? 160
                  : null,
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.only(
                  top: 24.0, left: 24.0, bottom: 4.0, right: 24.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: invalidStartDate || invalidFinishDate
                      ? Colors.red.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildDateColumn(
                        title: 'Start Date',
                        date: startDate,
                        buttonText: 'Start Date',
                        onPressed: () => _pickDate(context, startDate, (date) {
                          setState(() {
                            if (finishDate != null &&
                                date.isAfter(finishDate!)) {
                              invalidStartDate = true;
                            } else {
                              invalidFinishDate = false;
                              invalidStartDate = false;
                            }

                            startDate = date;
                          });
                        }),
                      ),
                      Container(
                        width: 2,
                        height: 64,
                        color: selectedReadingStatus != ReadingStatus.reading &&
                                selectedReadingStatus != ReadingStatus.paused
                            ? Colors.grey.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                      if (selectedReadingStatus != ReadingStatus.wantToRead &&
                          selectedReadingStatus != ReadingStatus.reading &&
                          selectedReadingStatus != ReadingStatus.paused)
                        _buildDateColumn(
                          title: 'Finish Date',
                          date: finishDate,
                          buttonText: 'Finish Date',
                          onPressed: () => _pickDate(
                            context,
                            finishDate,
                            (date) {
                              setState(() {
                                if (startDate != null &&
                                    date.isBefore(startDate!)) {
                                  invalidFinishDate = true;
                                } else {
                                  invalidFinishDate = false;
                                  invalidStartDate = false;
                                }

                                finishDate = date;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (invalidStartDate || invalidFinishDate)
              const SizedBox(height: 8.0),
            if (invalidStartDate)
              const CustomText(
                'Start date should be older than finish date.',
                color: Colors.red,
                fontSize: 14,
              ),
            if (invalidFinishDate)
              const CustomText(
                'Finish date should be more recent than start date.',
                color: Colors.red,
                fontSize: 14,
              ),
          ],
        ),
      ),
      fallback: null,
    );
  }

  Widget _buildDateColumn(
      {required String title,
      DateTime? date,
      required String buttonText,
      required Function() onPressed}) {
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
                Utils.formatDate(date!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 20),
              ),
              fallback: (context) => const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  Text(
                    'Add Date',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickDate(BuildContext context, DateTime? currentDate,
      Function(DateTime) onConfirm) async {
    await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(DateTime.now().year - 100),
      maxTime: DateTime.now(),
      currentTime: currentDate,
      onConfirm: onConfirm,
    );
  }

  Widget _buildAddRatingButton() {
    return CustomButton(
      text: 'Add Book Review',
      width: 160,
      styleType: ButtonStyleType.outline,
      borderColor: Colors.grey.withOpacity(0.6),
      color: Colors.grey,
      onPressed: () {
        _showAddReviewBottomSheet();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(AppIcons.quill),
          const Text('Write a review'),
        ],
      ),
    );
  }

  void _showAddReviewBottomSheet() {
    return CustomBottomSheet.show(
      height: MediaQuery.sizeOf(context).height,
      showDragHandle: false,
      context: context,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButton(
                    text: 'Close',
                    width: 20,
                    styleType: ButtonStyleType.ghost,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppIcons.close,
                      height: 32,
                    ),
                  ),
                  const CustomText(
                    'How was it this book?',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  const CustomText(
                    'By sharing your insight about this book you are giving your self what you get out of it, and telling other what they could excpect',
                    color: Colors.grey,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24.0),
                  const CustomText(
                    'Rating',
                    fontWeight: FontWeight.w500,
                  ),
                  Center(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: 48,
                      glowColor: Colors.grey.withOpacity(0.4),
                      unratedColor: Colors.grey,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const CustomText(
                    'Review',
                    fontWeight: FontWeight.w500,
                  ),
                  const CustomInputField(
                    placeholder: 'Write your review...',
                    keyboardType: 'textarea',
                    minLines: 5,
                    maxLines: 20,
                  ),
                ],
              ),
            ),
            CustomButton(
              text: 'Save Review',
              width: double.infinity,
              height: 48,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfoCard() {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      borderColor: Colors.grey.withOpacity(0.6),
      borderWidth: 1,
      borderRadius: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Pages',
                color: Colors.grey,
              ),
              CustomText(
                '${widget.book.totalPages ?? '-'}',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Publish',
                color: Colors.grey,
              ),
              CustomText(
                widget.book.publishYear ?? '-',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Language',
                color: Colors.grey,
              ),
              CustomText(
                widget.book.language ?? '-',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Description',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showFullDescription = !showFullDescription;
              });
            },
            child: CustomText(
              widget.book.description ?? '-',
              textAlign: TextAlign.start,
              maxLines: showFullDescription ? 1000 : 8,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
