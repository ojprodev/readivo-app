import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_add_book_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_cover.dart';

class LibraryEditBookAppBar extends StatelessWidget {
  final Book book;
  const LibraryEditBookAppBar({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 360.0,
      elevation: 0.0,
      pinned: true,
      stretch: true,
      toolbarHeight: 80,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      leadingWidth: 56,
      backgroundColor: Colors.black,
      leading: Container(
        margin: const EdgeInsets.only(left: 16.0),
        alignment: Alignment.center,
        child: CustomButton(
          text: 'Back',
          borderRadius: 40,
          color: Colors.black.withOpacity(0.2),
          onPressed: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            AppIcons.chevronLeft,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomButton(
            text: 'Save',
            width: 80,
            color: Colors.black.withOpacity(0.1),
            borderRadius: 6,
            textColor: Colors.white,
            onPressed: (){
              // go back with changed
              context.read<AppCubit>().changeScreen(LibraryAddBookScreen(book: book));
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            _buildBlurredImageWithGradient(book.coverURI ?? ''),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8.0),
                  child: BookCover(
                    width: 170,
                    height: 250,
                    child: BookBox(
                      coverUri: book.coverURI ?? '',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0, right: 16),
                  child: CustomButton(
                    text: 'Change Thumbnail',
                    width: 50,
                    height: 50,
                    borderRadius: 25,
                    color: Colors.white.withOpacity(0.4),
                    child: SvgPicture.asset(AppIcons.camera),
                  ),
                )
              ],
            ),
          ],
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: CustomContainer(
          padding: EdgeInsets.all(4.0),
          alignment: Alignment.bottomCenter,
          height: 12,
          boxDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: CustomContainer(
            width: 48,
            height: 4,
            borderRadius: 2,
            color: AppColors.grey,
          ),
        ),
      ),
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
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black.withOpacity(0), // Adjust opacity if needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
