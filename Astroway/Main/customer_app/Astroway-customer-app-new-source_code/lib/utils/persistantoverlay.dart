import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PersistentRequestOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required int requestCount,
    required VoidCallback onViewRequests,
    bool? showAcceptBtn = false,
    String title = 'New Requests',
  }) {
    dismiss();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 5.h,
        left: 4.w,
        right: 4.w,
        child: Material(
          color: Colors.transparent,
          child: _RequestNotificationCard(
            showAcceptBtn: showAcceptBtn ?? false,
            requestCount: requestCount,
            title: title,
            onClose: dismiss,
            onView: () {
              dismiss();
              onViewRequests();
            },
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _isVisible = true;
  }

  static void dismiss() {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }
}

class _RequestNotificationCard extends StatefulWidget {
  final int requestCount;
  final String title;
  final VoidCallback onClose;
  final VoidCallback onView;
  final bool showAcceptBtn;

  const _RequestNotificationCard({
    required this.requestCount,
    required this.title,
    required this.onClose,
    required this.onView,
    this.showAcceptBtn = false,
  });

  @override
  __RequestNotificationCardState createState() =>
      __RequestNotificationCardState();
}

class __RequestNotificationCardState extends State<_RequestNotificationCard> {
  double _dragOffset = 0;
  bool _isDismissing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() => _dragOffset += details.primaryDelta!);
      },
      onHorizontalDragEnd: (_) {
        if (_dragOffset.abs() > 80) {
          setState(() => _isDismissing = true);
          widget.onClose();
        } else {
          setState(() => _dragOffset = 0);
        }
      },
      child: AnimatedContainer(
        height: 9.h,
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(_dragOffset, 0, 0),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _isDismissing ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 3.3.w,
                      child: Center(
                        child: Text(
                          '${widget.requestCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 1.w),
                    SizedBox(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Accept & Close
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: widget.onClose,
                            icon: Icon(Icons.close, color: Colors.white),
                          ),
                          SizedBox(width: 2.w),
                          widget.showAcceptBtn
                              ? IconButton(
                                  onPressed: widget.onView,
                                  icon: Icon(Icons.check,
                                      color: Colors.greenAccent),
                                )
                              : Container()
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
