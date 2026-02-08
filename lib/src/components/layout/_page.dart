import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';

class PageLayout extends StatelessWidget {
  final Color? color;
  final PreferredSizeWidget? header;
  final Widget? menu, content, button, footer, popup;
  const PageLayout({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
    this.footer,
    this.color,
    this.popup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color ?? context.defaultColor,
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
