import 'package:flutter/material.dart';

class ZoomableImageWidget extends StatefulWidget {
  final Widget imageWidget;
  const ZoomableImageWidget({super.key, required this.imageWidget});

  @override
  State<ZoomableImageWidget> createState() => _ZoomableImageWidgetState();
}

class _ZoomableImageWidgetState extends State<ZoomableImageWidget> {
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _controller.value = Matrix4.identity();
      },
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1.0,
        maxScale: 4.0,
        child: widget.imageWidget,
      ),
    );
  }
}
