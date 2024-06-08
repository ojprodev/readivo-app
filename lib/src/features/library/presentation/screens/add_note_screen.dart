import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';

class AddNoteScreen extends StatefulWidget {
  final Book book;

  const AddNoteScreen({super.key, required this.book});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  NoteCategoryEnum selectedCategory = NoteCategoryEnum.quote;
  TextEditingController pageController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  late LibraryCubit libraryCubit;
  bool isValid = true;

  @override
  void initState() {
    super.initState();

    libraryCubit = LibraryCubit.get(context);

    authorController.text = widget.book.author ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          _buildAddNoteNavBar(),
          const SizedBox(height: 16.0),
          _buildNoteCategoryAndPageButtons(),
          CustomInputField(
            controller: noteController,
            placeholder: 'Write your question here...',
            borderColor: Colors.transparent,
            minLines: 12,
            maxLines: 25,
            validator: (content) {
              if (content == null || content.isEmpty) {
                setState(() {
                  isValid = true;
                });

                return 'Please provide content.';
              }

              setState(() {
                isValid = false;
              });

              return null;
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
            onChanged: (value) {
              noteController.text = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const CustomText(
                '-',
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
              Expanded(
                child: CustomInputField(
                  controller: authorController,
                  placeholder: widget.book.author,
                  contentPadding: EdgeInsets.zero,
                  borderColor: Colors.transparent,
                  onChanged: (value) {
                    authorController.text = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddNoteNavBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(
          text: 'close',
          width: 40,
          styleType: ButtonStyleType.ghost,
          onPressed: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(AppIcons.close),
        ),
        const CustomText(
          'Add Note',
          fontSize: 18,
        ),
        CustomButton(
          text: 'add note',
          width: 40,
          styleType: ButtonStyleType.ghost,
          onPressed: () {
            if (isValid != true) {
              Note note = Note(
                content: noteController.text,
                noteCategory: selectedCategory,
                author: authorController.text,
                page: pageController.text.isNotEmpty
                    ? int.parse(pageController.text)
                    : null,
                createdAt: DateTime.now(),
              );

              libraryCubit.addNote(note, book: widget.book).then((_) {
                Navigator.pop(context);
              });
            }
          },
          child: SvgPicture.asset(AppIcons.valid),
        ),
      ],
    );
  }

  Widget _buildNoteCategoryAndPageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _showNoteCategorySelector();
          },
          child: CustomChip(
            text: Note.getNoteCategoryAsString(selectedCategory),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            backgroundColor: AppColors.lightGrey,
          ),
        ),
        CustomContainer(
          width: 80,
          height: 50,
          child: CustomInputField(
            controller: pageController,
            textAlign: TextAlign.center,
            borderRadius: 25,
            contentPadding:
                const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 6.0),
            keyboardType: 'number',
            placeholder: 'page',
            onChanged: (value) {
              pageController.text = value;
            },
          ),
        )
      ],
    );
  }

  void _showNoteCategorySelector() {
    CustomBottomSheet.show(
      context: context,
      height: 230,
      bottomSheetItems: _noteCategoriesItems(),
    );
  }

  List<BottomSheetItem> _noteCategoriesItems() {
    return NoteCategoryEnum.values.map((category) {
      return BottomSheetItem(
          label: Note.getNoteCategoryAsString(category),
          onTap: () {
            setState(() {
              selectedCategory = category;
            });

            Navigator.pop(context);
          });
    }).toList();
  }
}
