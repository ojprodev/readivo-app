import 'package:flutter/material.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_home_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: 'Readivo',
      debugShowCheckedModeBanner: false,
      home: LibraryHomeScreen(),
    );
  }
}