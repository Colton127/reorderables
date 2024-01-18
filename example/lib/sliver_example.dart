import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class SliverExample extends StatefulWidget {
  @override
  _SliverExampleState createState() => _SliverExampleState();
}

class _SliverExampleState extends State<SliverExample> {
  late List<Widget> _rows;

  @override
  void initState() {
    super.initState();
    _rows = List<Widget>.generate(
        50,
        (int index) =>
            Container(width: double.infinity, child: Align(alignment: Alignment.centerLeft, child: Text('This is sliver child $index', textScaleFactor: 2))));
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _rows.removeAt(oldIndex);
        _rows.insert(newIndex, row);
      });
    }

    // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
    // Otherwise an error will be thrown.
    ScrollController _scrollController = PrimaryScrollController.maybeOf(context) ?? ScrollController();
    final padding = MediaQuery.paddingOf(context);
    print('sliverExamplePadding: $padding');
    return CustomScrollView(
      // A ScrollController must be included in CustomScrollView, otherwise
      // ReorderableSliverList wouldn't work
      controller: _scrollController,
      slivers: <Widget>[
        SliverPadding(padding: EdgeInsets.only(top: padding.top)),
        ReorderableSliverList(
          scrollOffsetMargin: EdgeInsets.only(top: padding.top + kToolbarHeight, bottom: padding.bottom),
          delegate: ReorderableSliverChildListDelegate(_rows),
          // or use ReorderableSliverChildBuilderDelegate if needed
//          delegate: ReorderableSliverChildBuilderDelegate(
//            (BuildContext context, int index) => _rows[index],
//            childCount: _rows.length
//          ),
          onReorder: _onReorder,
          onNoReorder: (int index) {
            //this callback is optional
            debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
          },
          onReorderStarted: (int index) {
            debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started. index:$index');
          },
        ),
        SliverPadding(padding: EdgeInsets.only(top: padding.bottom)),
      ],
    );
  }
}
