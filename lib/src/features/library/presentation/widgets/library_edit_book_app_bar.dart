import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readivo_app/src/core/constants/icons.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/core/widgets/bottom_sheet.dart';
import 'package:readivo_app/src/core/widgets/custom_alert.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_cover.dart';

// ignore: must_be_immutable
class LibraryEditBookAppBar extends StatefulWidget {
  String coverUri;
  final Function(String) onSave;

  LibraryEditBookAppBar({
    super.key,
    required this.coverUri,
    required this.onSave,
  });

  @override
  State<LibraryEditBookAppBar> createState() => _LibraryEditBookAppBarState();
}

class _LibraryEditBookAppBarState extends State<LibraryEditBookAppBar> {
  TextEditingController thumbnailUrlController = TextEditingController();

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
          color: Colors.white.withOpacity(0.9),
          onPressed: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            AppIcons.chevronLeft,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomButton(
            text: 'Save',
            width: 80,
            color: Colors.white.withOpacity(0.9),
            borderRadius: 6,
            textColor: Colors.black,
            onPressed: () => widget.onSave(widget.coverUri),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            _buildBlurredImageWithGradient(widget.coverUri),
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
                      coverUri: widget.coverUri,
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
                    color: Colors.black.withOpacity(0.2),
                    onPressed: () {
                      CustomBottomSheet.show(
                        context: context,
                        bottomSheetItems: [
                          BottomSheetItem(
                            icon: SvgPicture.asset(AppIcons.image),
                            label: 'Select an Image',
                            borderColor: Colors.grey.withOpacity(0.4),
                            onTap: () {
                              _pickBookThumbnail(source: ImageSource.gallery);

                              // close the bottom sheet
                              Navigator.pop(context);
                            },
                          ),
                          BottomSheetItem(
                            icon: SvgPicture.asset(AppIcons.link),
                            label: 'Use a URL',
                            borderColor: Colors.grey.withOpacity(0.4),
                            onTap: () {
                              // close the bottom sheet
                              Navigator.pop(context);

                              _fetchThumbnailFromUrl();
                            },
                          ),
                          BottomSheetItem(
                            icon: SvgPicture.asset(AppIcons.camera),
                            label: 'Take a Picture',
                            borderColor: Colors.grey.withOpacity(0.4),
                            onTap: () {
                              _pickBookThumbnail(source: ImageSource.camera);

                              // close the bottom sheet
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                    child: SvgPicture.asset(
                      AppIcons.camera,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
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
            color: Colors.grey,
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
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.black.withOpacity(0), // Adjust opacity if needed
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickBookThumbnail({required ImageSource source}) async {
    final XFile? selectedImage = await ImagePicker().pickImage(source: source);

    if (selectedImage != null) {
      setState(() {
        widget.coverUri = selectedImage.path;
      });
    }
  }

  void _fetchThumbnailFromUrl() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Enter a URL',
          content: Column(
            children: [
              CustomInputField(
                controller: thumbnailUrlController,
                label: 'Thumbnail URL',
                placeholder: 'https://',
                onChanged: (value) {
                  thumbnailUrlController.text = value;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                text: 'Use URL',
                width: double.infinity,
                onPressed: () {
                  setState(() {
                    if (thumbnailUrlController.text.isNotEmpty) {
                      widget.coverUri = thumbnailUrlController.text;
                    }

                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
