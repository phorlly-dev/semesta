import 'package:flutter/material.dart';

class LayoutPage extends StatelessWidget {
  final Widget? menu, content, button, footer, popup;
  final Color? bgColor;
  final PreferredSizeWidget? header;
  const LayoutPage({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
    this.footer,
    this.bgColor,
    this.popup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: header,
      drawer: menu == null ? null : SafeArea(child: menu!),
      body: SafeArea(child: content ?? SizedBox.shrink()),
      floatingActionButton: button,
      bottomNavigationBar: footer,
      bottomSheet: popup,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
