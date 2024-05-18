import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

class BasicLayout extends StatefulWidget {
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
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final bool isTransparent;

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
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.isTransparent = false,
  });

  @override
  State<BasicLayout> createState() => _BasicLayoutState();
}

class _BasicLayoutState extends State<BasicLayout> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: widget.extendBody,
        appBar: widget.extendBody ? _buildNormalAppBar() : null,
        body: ConditionalBuilder(
          condition: widget.extendBody,
          builder: (context) => widget.body,
          fallback: (context) => _buildNestedAppBar(),
        ),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      forceMaterialTransparency: widget.isTransparent,
      elevation: 0.0,
      backgroundColor: widget.appBarBackground,
      automaticallyImplyLeading: widget.showBackButton,
      leading: widget.leading,
      primary: true,
      surfaceTintColor: Colors.white,
      leadingWidth: 40,
      title: ConditionalBuilder(
        condition: widget.titleWidget == null,
        builder: (context) => Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        fallback: (context) => widget.titleWidget ?? Text(widget.title),
      ),
      centerTitle: widget.centerTitle,
      actions: widget.actions,
    );
  }

  Widget _buildNestedAppBar() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            forceMaterialTransparency: widget.isTransparent,
            elevation: 0.0,
            backgroundColor: widget.appBarBackground,
            automaticallyImplyLeading: widget.showBackButton,
            leading: widget.leading,
            pinned: widget.isPinned,
            primary: true,
            surfaceTintColor: Colors.white,
            forceElevated: innerBoxIsScrolled,
            leadingWidth: 40,
            title: ConditionalBuilder(
              condition: widget.titleWidget == null,
              builder: (context) => Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              fallback: (context) => widget.titleWidget ?? Text(widget.title),
            ),
            centerTitle: widget.centerTitle,
            actions: widget.actions,
          )
        ];
      },
      body: widget.body,
    );
  }
}
