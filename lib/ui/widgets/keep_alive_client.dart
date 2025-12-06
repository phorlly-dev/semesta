import 'package:flutter/material.dart';

class KeepAliveClient extends StatefulWidget {
  final Widget child;
  const KeepAliveClient({super.key, required this.child});

  @override
  State<KeepAliveClient> createState() => _KeepAliveClientState();
}

class _KeepAliveClientState extends State<KeepAliveClient>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(child: widget.child);
  }
}
