import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/core/widgets/custom_input_field.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/widgets/shelf_card.dart';

class LibraryShelvesScreen extends StatefulWidget {
  const LibraryShelvesScreen({super.key});

  @override
  State<LibraryShelvesScreen> createState() => _LibraryShelvesScreenState();
}

class _LibraryShelvesScreenState extends State<LibraryShelvesScreen> {
  late LibraryCubit libraryCubit;
  List<Shelf> shelves = [];

  @override
  void initState() {
    super.initState();

    libraryCubit = LibraryCubit.get(context);

    libraryCubit.fetchShelves();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: _changeListener,
      builder: _mainBuilder,
    );
  }

  Widget _mainBuilder(context, state){
    return BasicLayout(
        title: 'Shelves Screen',
        titleWidget: const SizedBox(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const CustomInputField(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: shelves.length,
                    itemBuilder: (context, index) {
                      return ShelfCardWidget(shelf: shelves[index]);
                    },
                    separatorBuilder: (context, index){
                      return const SizedBox(height: 24.0);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _changeListener(context, state){
    if(state is LibraryShelvesListLoaded){
      shelves = state.shelves;
    }
  }
}
