import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  NoteCategoryEnum selectedCategory = NoteCategoryEnum.quote;
  TextEditingController pageController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
      leadingWidth: 50,
      leading: CustomButton(
        text: 'back',
        width: 50,
        styleType: ButtonStyleType.ghost,
        onPressed: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(AppIcons.close),
      ),
      title: 'Add a Note',
      centerTitle: true,
      actions: [
        CustomButton(
          text: 'Save Note',
          styleType: ButtonStyleType.ghost,
          width: 50,
          child: SvgPicture.asset(
            AppIcons.valid,
          ),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            _buildNoteCategoryAndPageButtons(),
            CustomInputField(
              controller: noteController,
              placeholder: 'Write your question here...',
              borderColor: Colors.transparent,
              minLines: 12,
              maxLines: 25,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 24.0),
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
                    placeholder: 'Paulo Coelho',
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
      ),
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
        context: context, bottomSheetItems: _noteCategoriesItems());
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
