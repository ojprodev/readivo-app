import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/constants/images.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';

class ReadingSessionScreen extends StatefulWidget {
  const ReadingSessionScreen({super.key});

  @override
  State<ReadingSessionScreen> createState() => _ReadingSessionScreenState();
}

class _ReadingSessionScreenState extends State<ReadingSessionScreen> {
  bool timerOn = false;

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
        title: 'Reading Session',
        centerTitle: true,
        leading: CustomButton(
          text: 'Back',
          styleType: ButtonStyleType.ghost,
          child: SvgPicture.asset(AppIcons.chevronLeft),
        ),
        floatingActionButton: _buildAddNoteButton(),
        titleWidget: _buildTimer(),
        actions: const [
          CustomButton(
            text: 'Finish Session',
            styleType: ButtonStyleType.ghost,
            child: CustomText(
              'Done',
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
        body: Container(
          margin: const EdgeInsets.only(top: 48.0),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppImages.readingSession,
                height: 300,
              ),
              const SizedBox(height: 16.0),
              const CustomText('Start a reading session'),
            ],
          ),
        ));
  }

  Widget _buildTimer() {
    return CustomButton(
      text: 'Timer',
      color: Colors.black,
      width: 120,
      borderRadius: 24,
      onPressed: () {
        setState(() {
          timerOn = !timerOn;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _timerIcon(timerOn),
            const CustomText(
              '00:00',
              fontSize: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerIcon(bool active) {
    return ConditionalBuilder(
      condition: active,
      builder: (context) => SvgPicture.asset(
        AppIcons.stop,
        colorFilter: const ColorFilter.mode(
          Colors.red,
          BlendMode.srcIn,
        ),
      ),
      fallback: (context) => SvgPicture.asset(
        AppIcons.play,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildAddNoteButton(){
    return CustomButton(
      text: 'Add Note',
      width: 52,
      height: 52,
      borderRadius: 26,
      color: AppColors.lightBlue,
      child: SvgPicture.asset(
        AppIcons.quill,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
