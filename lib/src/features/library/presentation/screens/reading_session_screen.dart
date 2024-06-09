import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/constants/images.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';
import 'package:readivo_app/src/features/library/domain/entities/reading_session.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/screens/add_note_screen.dart';

class ReadingSessionScreen extends StatefulWidget {
  final Book book;

  const ReadingSessionScreen({super.key, required this.book});

  @override
  State<ReadingSessionScreen> createState() => _ReadingSessionScreenState();
}

class _ReadingSessionScreenState extends State<ReadingSessionScreen> {
  bool timerOn = false;
  late AppCubit appCubit;
  late LibraryCubit libraryCubit;
  Duration duration = const Duration();
  TextEditingController pageController = TextEditingController();
  Timer? timer;
  List<Note> notes = [];
  late ReadingSession readingSession;

  @override
  void initState() {
    super.initState();

    appCubit = AppCubit.get(context);
    libraryCubit = LibraryCubit.get(context);

    readingSession = ReadingSession(createdAt: DateTime.now());
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
              // stop the timer
              timer?.cancel();

              _showReadingProgressConfirmDialog();
            },
            child: const CustomText(
              'Done',
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
        body: BlocConsumer<LibraryCubit, LibraryStates>(
          builder: _buildContent,
          listener: _changeListener,
        ));
  }

  Widget _buildContent(BuildContext context, state) {
    return ConditionalBuilder(
      condition: notes.isEmpty,
      builder: (context) => Container(
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
      ),
      fallback: (context) {
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return _buildQuoteCard(notes[index]);
          },
        );
      },
    );
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
          // set start time if null
          readingSession.startTime ??= DateTime.now();

          if (timerOn) {
            timer?.cancel();

            timerOn = false;
          } else {
            startTimer();

            readingSession.endTime = DateTime.now();

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

  Widget _buildQuoteCard(Note note) {
    return CustomContainer(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
      color: AppColors.extraLightGreen,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20,
            right: 0,
            child: SvgPicture.asset(
              AppIcons.quote,
              width: 54,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomText(
                    note.content,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: AppColors.grey.withOpacity(0.9),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      '- ${note.author}',
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    if (note.page != null)
                      CustomText(
                        'page ${note.page}',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReadingProgressConfirmDialog() {
    CustomBottomSheet.show(
      context: context,
      showDragHandle: false,
      height: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CustomText('How much did you read?'),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText('Current Page (between 12-341)'),
                const SizedBox(height: 4.0),
                CustomInputField(
                  controller: pageController,
                  placeholder: 'Enter page number',
                  keyboardType: 'number',
                  onChanged: (value) {
                    setState(() {
                      pageController.text = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                text: 'Save',
                onPressed: () async {
                  readingSession.notes.addAll(notes);
                  readingSession.endTime ??= DateTime.now();
                  readingSession.timeSpent = duration.inSeconds;
                  if (pageController.text.isNotEmpty) {
                    readingSession.endPage = int.parse(pageController.text);
                  }

                  await libraryCubit.addReadingSession(
                    readingSession: readingSession,
                    book: widget.book,
                  );

                  appCubit.previousScreen();
                },
              ),
            ),
          ],
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
        CustomBottomSheet.show(
          context: context,
          height: MediaQuery.sizeOf(context).height * 0.96,
          child: AddNoteScreen(book: widget.book),
        );
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

  void _changeListener(BuildContext context, state) {
    if (state is LibraryNewNoteAddedState) {
      setState(() {
        notes.add(state.note);
      });
    }
  }
}
