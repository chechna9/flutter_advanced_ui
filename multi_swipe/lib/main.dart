import 'dart:math';

import 'package:flutter/material.dart';

const double LIST_ITEM_HEIGHT = 50;
Widget getTileItem(int i) {
  return Container(
    height: LIST_ITEM_HEIGHT - 1,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buy ${i} more spam!',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Now with 100% more salt!'),
        ],
      ),
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: ListHomeView(),
      ),
    );
  }
}

class ListHomeView extends StatefulWidget {
  const ListHomeView({super.key});

  @override
  State<ListHomeView> createState() => _ListHomeViewState();
}

class _ListHomeViewState extends State<ListHomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController dragController;
  final ScrollController scrollController = ScrollController();
  List<int> emails = List.generate(20, (index) => index);
  int? draggedIDX;
  int? dragOffset;
  bool shouldDrag = false;
  @override
  void initState() {
    super.initState();
    dragController = AnimationController.unbounded(vsync: this);
  }

  List<Widget> getListItems() {
    List<Widget> items = [];
    emails.asMap().forEach(
      (index, email) {
        items.add(
          AnimatedBuilder(
            animation: dragController,
            builder: (context, child) {
              if (draggedIDX != null && dragOffset != null) {
                int topIdx = min(draggedIDX!, draggedIDX! + dragOffset!);
                int bottomIndx = max(draggedIDX!, draggedIDX! + dragOffset!);
                print('index $index');
                print('draggedIDX $draggedIDX');
                print('topIdx $topIdx');

                print('bottomIndx $bottomIndx');
                shouldDrag = (index >= topIdx && index <= bottomIndx);
              }

              return Transform.translate(
                offset: Offset(shouldDrag ? dragController.value : 0, 0),
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    draggedIDX = index;
                  },
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta != null) {
                      dragController.value += details.primaryDelta!;
                    }
                    dragOffset =
                        (details.localPosition.dy / LIST_ITEM_HEIGHT).floor();
                  },
                  onHorizontalDragEnd: (details) {
                    dragController.value = 0;
                    draggedIDX = null;
                    dragOffset = null;
                  },
                  child: getTileItem(email),
                ),
              );
            },
          ),
        );
        items.add(
          AnimatedBuilder(
              animation: dragController,
              builder: (context, child) {
                return Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 2,
                  indent: shouldDrag && dragController.value > 0
                      ? dragController.value
                      : 0,
                  endIndent: shouldDrag && dragController.value < 0
                      ? dragController.value.abs()
                      : 0,
                );
              }),
        );
      },
    );
    return items;
  }

  Widget _getSwipeActionIndicator() {
    return AnimatedBuilder(
      animation: dragController,
      builder: (context, child) {
        if (!scrollController.hasClients ||
            draggedIDX == null ||
            draggedIDX == null) {
          return Container();
        }

        double topPixelOffset =
            (min(draggedIDX!, draggedIDX! + dragOffset!) * LIST_ITEM_HEIGHT) -
                scrollController.offset;
        double bottomPixelOffset =
            ((max(draggedIDX!, draggedIDX! + dragOffset!) + 1) *
                    LIST_ITEM_HEIGHT) -
                scrollController.offset;

        if (dragController.value > 0) {
          return Positioned(
            top: topPixelOffset,
            left: 0,
            height: bottomPixelOffset - topPixelOffset,
            width: dragController.value,
            child: Container(
              color: Colors.green,
              child: const Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
          );
        }
        return Positioned(
          top: topPixelOffset,
          right: 0,
          height: bottomPixelOffset - topPixelOffset,
          width: dragController.value.abs(),
          child: Container(
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getSwipeActionIndicator(),
        ListView(
          controller: scrollController,
          children: getListItems(),
        ),
      ],
    );
  }
}
