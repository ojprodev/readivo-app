import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/constants/images.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/presentation/screens/add_note_screen.dart';

class ReadingSessionScreen extends StatefulWidget {
  const ReadingSessionScreen({super.key});

  @override
  State<ReadingSessionScreen> createState() => _ReadingSessionScreenState();
}

class _ReadingSessionScreenState extends State<ReadingSessionScreen> {
  bool timerOn = false;
  late AppCubit appCubit;
  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    appCubit = AppCubit.get(context);
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    setState(() {
      duration = Duration(seconds: duration.inSeconds + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
        title: 'Reading Session',
        centerTitle: true,
        leading: CustomButton(
          text: 'Back',
          styleType: ButtonStyleType.ghost,
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset(AppIcons.chevronLeft),
        ),
        floatingActionButton: _buildAddNoteButton(),
        titleWidget: _buildTimer(),
        actions: [
          CustomButton(
            text: 'Finish Session',
            styleType: ButtonStyleType.ghost,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const CustomText(
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
    final minutes = Utils.twoDigits(duration.inMinutes.remainder(60));
    final seconds = Utils.twoDigits(duration.inSeconds.remainder(60));

    return CustomButton(
      text: 'Timer',
      color: Colors.black,
      width: 120,
      borderRadius: 24,
      onPressed: () {
        setState(() {
          if (timerOn) {
            timer?.cancel();

            timerOn = false;
          } else {
            startTimer();

            timerOn = !timerOn;
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _timerIcon(timerOn),
          CustomText(
            '$minutes:$seconds',
            fontSize: 18,
            color: Colors.white,
          ),
        ],
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

  Widget _buildAddNoteButton() {
    return CustomButton(
      text: 'Add Note',
      width: 52,
      height: 52,
      borderRadius: 26,
      color: AppColors.lightBlue,
      onPressed: () {
        appCubit.changeScreen(const AddNoteScreen());
      },
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
