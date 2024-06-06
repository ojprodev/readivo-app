import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_chip.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
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
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomChip(
                  text: 'Question',
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  backgroundColor: AppColors.lightGrey,
                ),
                CustomContainer(
                  width: 80,
                  height: 50,
                  child: CustomInputField(
                    textAlign: TextAlign.center,
                    borderRadius: 25,
                    contentPadding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 6.0),
                    keyboardType: 'number',
                    placeholder: 'page',
                  ),
                )
              ],
            ),
            CustomInputField(
              placeholder: 'Write your question here...',
              borderColor: Colors.transparent,
              minLines: 12,
              maxLines: 25,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 0, vertical: 24.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomText(
                  '-',
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
                Expanded(
                  child: CustomInputField(
                    placeholder: 'Paulo Coelho',
                    contentPadding: EdgeInsets.zero,
                    borderColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
