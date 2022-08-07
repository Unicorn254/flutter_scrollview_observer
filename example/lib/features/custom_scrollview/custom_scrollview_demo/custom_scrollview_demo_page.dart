import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:scrollview_observer_example/typedefs.dart';

class CustomScrollViewDemoPage extends StatefulWidget {
  const CustomScrollViewDemoPage({Key? key}) : super(key: key);

  @override
  State<CustomScrollViewDemoPage> createState() =>
      _CustomScrollViewDemoPageState();
}

class _CustomScrollViewDemoPageState extends State<CustomScrollViewDemoPage> {
  BuildContext? _sliverViewCtx1;
  BuildContext? _sliverViewCtx2;

  int _hitIndexForCtx1 = 0;
  List<int> _hitIndexsForCtx2 = [];

  ScrollController scrollController = ScrollController();

  late SliverObserverController observerController;

  @override
  void initState() {
    super.initState();

    observerController = SliverObserverController(controller: scrollController);

    // Trigger an observation manually
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((timeStamp) {
      ListViewOnceObserveNotification().dispatch(_sliverViewCtx1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CustomScrollView")),
      body: SliverViewObserver(
        controller: observerController,
        child: CustomScrollView(
          controller: scrollController,
          // scrollDirection: Axis.horizontal,
          slivers: [
            _buildSliverListView1(),
            _buildSliverListView2(),
          ],
        ),
        sliverListContexts: () {
          return [
            if (_sliverViewCtx1 != null) _sliverViewCtx1!,
            if (_sliverViewCtx2 != null) _sliverViewCtx2!,
          ];
        },
        onObserveAll: (resultMap) {
          final model1 = resultMap[_sliverViewCtx1];
          if (model1 != null &&
              model1.visible &&
              model1 is ListViewObserveModel) {
            debugPrint('1 visible -- ${model1.visible}');
            debugPrint('1 firstChild.index -- ${model1.firstChild?.index}');
            debugPrint('1 displaying -- ${model1.displayingChildIndexList}');
            setState(() {
              _hitIndexForCtx1 = model1.firstChild?.index ?? 0;
            });
          }

          final model2 = resultMap[_sliverViewCtx2];
          if (model2 != null &&
              model2.visible &&
              model2 is GridViewObserveModel) {
            debugPrint('2 visible -- ${model2.visible}');
            debugPrint('2 displaying -- ${model2.displayingChildIndexList}');
            setState(() {
              _hitIndexsForCtx2 =
                  model2.firstGroupChildList.map((e) => e.index).toList();
            });
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                _showSnackBar(
                  context: context,
                  text: 'SliverList - Jumping to row 29',
                );
                observerController.animateTo(
                  sliverContext: _sliverViewCtx1,
                  index: 29,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.ac_unit_outlined),
            ),
            IconButton(
              onPressed: () {
                _showSnackBar(
                  context: context,
                  text: 'SliverGrid - Jumping to item 10',
                );
                observerController.animateTo(
                  sliverContext: _sliverViewCtx2,
                  index: 10,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.backup_table),
            ),
          ],
        ),
      ),
    );
  }

  _showSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  Widget _buildSliverListView1() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, index) {
          _sliverViewCtx1 ??= ctx;
          return Container(
            height: (index % 2 == 0) ? 80 : 50,
            color: _hitIndexForCtx1 == index ? Colors.red : Colors.black12,
            child: Center(
              child: Text(
                "index -- $index",
                style: TextStyle(
                  color:
                      _hitIndexForCtx1 == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
        childCount: 30,
      ),
    );
  }

  Widget _buildSliverListView2() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //Grid按两列显示
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          _sliverViewCtx2 ??= context;
          return Container(
            color: (_hitIndexsForCtx2.contains(index))
                ? Colors.green
                : Colors.blue[100],
            child: Center(
              child: Text('index -- $index'),
            ),
          );
        },
        childCount: 150,
      ),
    );
  }
}