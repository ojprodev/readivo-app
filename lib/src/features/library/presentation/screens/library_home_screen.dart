import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';

class LibraryHomeScreen extends StatelessWidget{
  const LibraryHomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return const BasicLayout(
      title: 'Good Evening',
      body: Text('Working'),
    );
  }
}