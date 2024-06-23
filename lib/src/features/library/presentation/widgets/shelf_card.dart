import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/widgets/custom_button.dart';
import 'package:readivo_app/src/core/widgets/custom_container.dart';
import 'package:readivo_app/src/core/widgets/custom_text.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_shelf_screen.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/book_box.dart';

class ShelfCardWidget extends StatelessWidget {
  final Shelf shelf;
  late AppCubit appCubit;
  ShelfCardWidget({super.key, required this.shelf});

  @override
  Widget build(BuildContext context) {
    appCubit = AppCubit.get(context);

    return CustomContainer(
      width: double.infinity,
      borderRadius: 6,
      height: 184,
      child: Column(
        children: [
          _buildCardHeader(),
          _buildCardContent(),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Stack(
      children: [
        Container(
          color: AppColors.lightWhite,
          height: 60,
        ),
        Positioned(
          left: 16,
          child: _buildCardHeaderBooksCover(),
        ),
      ],
    );
  }

  Widget _buildCardHeaderBooksCover() {
    return Container(
      width: 140,
      height: 90,
      padding: const EdgeInsets.only(right: 24.0, top: 12.0),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 16,
            child: BookBox(
              width: 48,
              height: 70,
            ),
          ),
          Positioned(
            right: 0,
            top: 24,
            child: BookBox(
              width: 48,
              height: 70,
            ),
          ),
          Positioned(
            top: 0,
            child: BookBox(
              width: 54,
              height: 70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  shelf.name,
                  fontSize: 20,
                ),
              ),
              CustomText(getTotalBooks(shelf.totalBooks)),
            ],
          ),
        ),
        const SizedBox(height: 24.0),
        CustomButton(
          text: 'Browse',
          styleType: ButtonStyleType.ghost,
          onPressed: (){
            appCubit.changeScreen(LibraryShelfScreen(shelf: shelf,));
          },
        )
      ],
    );
  }

  String getTotalBooks(int number) {
    return '$number ${Intl.plural(number, other: 'books', one: 'book')}';
  }
}
