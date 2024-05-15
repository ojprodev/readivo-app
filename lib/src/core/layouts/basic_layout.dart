import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

class BasicLayout extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget body;
  final Widget? leading;
  final Color statusBarColor;
  final bool? centerTitle;
  final bool showBackButton;
  final bool isPinned;
  final Color? appBarBackground;

  const BasicLayout({
    super.key,
    required this.title,
    this.actions,
    required this.body,
    this.titleWidget,
    this.statusBarColor = Colors.black,
    this.centerTitle = false,
    this.leading,
    this.showBackButton = true,
    this.isPinned = true,
    this.appBarBackground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceMaterialTransparency: false,
                elevation: 0.0,
                backgroundColor: appBarBackground,
                automaticallyImplyLeading: showBackButton,
                leading: leading,
                pinned: isPinned,
                primary: true,
                surfaceTintColor: Colors.white,
                forceElevated: innerBoxIsScrolled,
                title: ConditionalBuilder(
                  condition: titleWidget == null,
                  builder: (context) => Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fallback: (context) => titleWidget ?? Text(title),
                ),
                centerTitle: centerTitle,
                actions: actions,
              )
            ];
          },
          body: body,
        ),
      ),
    );
  }
}