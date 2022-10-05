import 'package:flutter/material.dart';

import '../../../common/enum/tab_item.dart';

class BottomNavigatorBarMainWidget extends StatefulWidget {
  const BottomNavigatorBarMainWidget({
    Key? key,
    required this.currentTab,
    required this.updateTabSelection,
  }) : super(key: key);
  final TabItem currentTab;
  final void Function(TabItem value) updateTabSelection;

  @override
  State<BottomNavigatorBarMainWidget> createState() =>
      _BottomNavigatorBarMainWidgetState();
}

class _BottomNavigatorBarMainWidgetState
    extends State<BottomNavigatorBarMainWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                widget.updateTabSelection(TabItem.home);
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.home,
                color: widget.currentTab == TabItem.home
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                widget.updateTabSelection(TabItem.file);
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.folder,
                color: widget.currentTab == TabItem.file
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
            const SizedBox(
              width: 50.0,
            ),
            IconButton(
              onPressed: () {
                widget.updateTabSelection(TabItem.favourite);
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.favorite,
                color: widget.currentTab == TabItem.favourite
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                widget.updateTabSelection(TabItem.setting);
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.settings,
                color: widget.currentTab == TabItem.setting
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
