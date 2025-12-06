import 'package:flutter/material.dart';

class NavBarLayer extends StatefulWidget implements PreferredSizeWidget {
  final Widget? start, middle, end;
  final void Function(String query)? onSearch;
  final Color? bgColor;
  final PreferredSizeWidget? bottom;

  const NavBarLayer({
    super.key,
    this.start,
    this.middle,
    this.end,
    this.onSearch,
    this.bottom,
    this.bgColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<NavBarLayer> createState() => _NavBarLayerState();
}

class _NavBarLayerState extends State<NavBarLayer> {
  bool isSearching = false;
  final _searchController = TextEditingController();

  void _startSearch() => setState(() => isSearching = true);

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
    widget.onSearch?.call('');
  }

  void _onSearchSubmitted(String value) {
    FocusScope.of(context).unfocus();
    widget.onSearch?.call(value.trim());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      animateColor: true,
      elevation: 8,
      automaticallyImplyLeading: !isSearching,
      title: isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search…',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchSubmitted,
            )
          : widget.middle,
      leading: isSearching
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: _stopSearch,
              tooltip: 'Close search',
            )
          : widget.start,
      actions: [
        if (!isSearching && widget.onSearch != null)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _startSearch,
            tooltip: 'Search',
          ),

        ?widget.end,
      ],
      bottom: widget.bottom,
      backgroundColor: widget.bgColor,
    );
  }
}
