import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget? menu, content, button, footer;
  final PreferredSizeWidget? header;

  const Layout({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      drawer: menu == null ? null : SafeArea(child: menu!),
      body: SafeArea(child: content ?? SizedBox.shrink()),
      floatingActionButton: button,
      bottomNavigationBar: footer,
    );
  }
}
