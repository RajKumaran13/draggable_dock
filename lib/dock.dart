import 'package:dock/main.dart';
import 'package:flutter/material.dart';

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [], /// list of item displayed in dock
  });

  final List<T> items;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> with TickerProviderStateMixin {
  final List<T> _items = []; /// list of hold icons
  int? draggingIndex; /// selected icon that is currently dragged 
  bool dragOutsideDock = false; /// to track the drag is outside dock

  @override
  void initState() {
    super.initState();
    _items.addAll(widget.items);  //populate items with widget's item
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      // This Determines the acceptance of drag data
      onWillAcceptWithDetails: (_) {
        setState(() => dragOutsideDock = false);  // when the drag enters the dock area
        return true;
      },
      //when the drag leaves the dock it updates
      onLeave: (_) => setState(() => dragOutsideDock = true), 
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_items.length, (index) {
              final item = _items[index]; // get the icon of current index
              final isBeingDragged = draggingIndex == index; // flag to check if this item is being dragged

              return GestureDetector(
                // the tapped icon set as dragged icon
                onTap: () => setState(() => draggingIndex = index),
                child: Draggable<int>(
                  data: index,
                  feedback: Material(
                    color: Colors.transparent,
                    child: ItemWidget(icon: item as IconData),
                  ),
                  // display a placeholder when the item is being dragged
                  childWhenDragging: dragOutsideDock
                      ? Container(width: 1, height: 1, color: Colors.transparent)
                      : AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isBeingDragged ? 0.0 : 1.0,
                          child: ItemWidget(icon: item as IconData),
                        ),
                  // set the dragging index when the drag starts
                  onDragStarted: () => setState(() => draggingIndex = index),
                  // reset the dragging state when the drag ends
                  onDragEnd: (details) {
                    setState(() {
                      dragOutsideDock = false;
                      draggingIndex = null;
                    });
                  },
                  child: DragTarget<int>(
                    // the target where the item is dragged to
                    onAcceptWithDetails: (details) {
                      setState(() {
                        final fromIndex = details.data; // get the index of the dragged item
                        final draggedItem = _items.removeAt(fromIndex); // remove the dragged item
                        _items.insert(index, draggedItem); // insert it at the new position
                      });
                    },
                    onWillAcceptWithDetails: (_) => dragOutsideDock, // allow the drag if it's outside the dock
                    builder: (context, candidateData, rejectedData) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isBeingDragged ? 0.0 : 1.0,
                          child: ItemWidget(icon: item as IconData),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}