// @dart=2.9
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:flutter/material.dart';

import '../../../../models/line/line_branch_info.dart';
import '../medium_content_branch_controller.dart';

class StickyExpansionTile extends StatefulWidget {
  final MediumContentBranchController subController;
  final LineBranchInfo info;
  final Function(bool) onExpansionChanged;
  final Widget Function() headerBuilder;
  final Widget Function() childBuilder;
  final Function(Key key, Widget header, double offset) onStickyUpdate;

  const StickyExpansionTile({
    Key key,
    @required this.subController,
    @required this.info,
    @required this.onExpansionChanged,
    @required this.headerBuilder,
    @required this.childBuilder,
    @required this.onStickyUpdate,
  }) : super(key: key);

  @override
  StickyExpansionTileState createState() => StickyExpansionTileState();
}

class StickyExpansionTileState extends State<StickyExpansionTile> {
  bool _isExpanded = false;
  final GlobalKey _headerKey = GlobalKey();
  ScrollPosition _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _scrollPosition = Scrollable.of(context)?.position;
    _scrollPosition?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _removeListener();
    // Ensure we clear the sticky header when disposed
    if (widget.key != null) {
      widget.onStickyUpdate(widget.key, null, 0);
    }
    super.dispose();
  }

  void _removeListener() {
    try {
      _scrollPosition?.removeListener(_onScroll);
    } catch (e) {
      // Ignore
    }
  }

  Widget _buildStickyHeader() {
    return Container(
      color: widget.subController.lineBranchInfo?.value?.isSaved == true
          ? Colors.green
          : Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(child: widget.headerBuilder()),
          IconButton(
            icon: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: widget.subController.lineBranchInfo?.value?.isSaved == true
                  ? Colors.white
                  : AppColor.highlightColor70,
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (!_isExpanded) {
                  widget.onStickyUpdate(widget.key, null, 0);
                }
              });
              widget.onExpansionChanged(_isExpanded);
            },
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (!_isExpanded) {
      if (widget.key != null) {
        widget.onStickyUpdate(widget.key, null, 0);
      }
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final RenderBox headerBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    if (renderBox == null || headerBox == null) {
      // Clear sticky header if render box is not available
      if (widget.key != null) {
        widget.onStickyUpdate(widget.key, null, 0);
      }
      return;
    }

    final Offset boxPos = renderBox.localToGlobal(Offset.zero);
    final double headerHeight = headerBox.size.height;
    final double totalHeight = renderBox.size.height;

    // Xác định vị trí top của list (thường là dưới SafeArea/StatusBar)
    final RenderBox scrollBox =
        Scrollable.of(context).context.findRenderObject() as RenderBox;
    if (scrollBox == null) {
      // Clear sticky header if scroll box is not available
      if (widget.key != null) {
        widget.onStickyUpdate(widget.key, null, 0);
      }
      return;
    }
    final double listTop = scrollBox.localToGlobal(Offset.zero).dy;

    final double y = boxPos.dy;

    // Logic:
    // 1. Item đã trôi lên trên listTop (y < listTop)
    // 2. Item vẫn còn hiển thị (y + totalHeight > listTop)
    if (y < listTop && (y + totalHeight) > listTop) {
      // Tính toán vị trí top cho overlay (để tạo hiệu ứng đẩy lên)
      double overlayTop = listTop;
      if (y + totalHeight < listTop + headerHeight) {
        overlayTop = (y + totalHeight) - headerHeight;
      }

      // Offset relative to the top of the Stack (which aligns with listTop)
      double offset = overlayTop - listTop;

      // Pass the header widget to parent
      if (widget.key != null) {
        widget.onStickyUpdate(widget.key, _buildStickyHeader(), offset);
      }
    } else {
      if (widget.key != null) {
        widget.onStickyUpdate(widget.key, null, 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        InkWell(
          key: _headerKey,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (!_isExpanded) {
                if (widget.key != null) {
                  widget.onStickyUpdate(widget.key, null, 0);
                }
              }
            });
            widget.onExpansionChanged(_isExpanded);
          },
          child: Container(
            color: widget.subController.lineBranchInfo?.value?.isSaved == true
                ? Colors.green
                : Colors.grey.shade100,
            child: Row(
              children: [
                // Wrap headerBuilder in Container to ensure full width hit test
                Expanded(child: widget.headerBuilder()),
                IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color:
                        widget.subController.lineBranchInfo?.value?.isSaved ==
                                true
                            ? Colors.white
                            : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                      if (!_isExpanded) {
                        if (widget.key != null) {
                          widget.onStickyUpdate(widget.key, null, 0);
                        }
                      }
                    });
                    widget.onExpansionChanged(_isExpanded);
                  },
                ),
              ],
            ),
          ),
        ),
        // Content
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: widget.childBuilder(),
          ),
      ],
    );
  }
}

