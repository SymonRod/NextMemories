import 'package:flutter/material.dart';

class PhotoPage extends StatefulWidget {
  final Widget imageWidget;
  final VoidCallback onTap;
  final ValueChanged<bool> onZoomChanged;

  const PhotoPage({
    super.key,
    required this.imageWidget,
    required this.onTap,
    required this.onZoomChanged,
  });

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with SingleTickerProviderStateMixin {
  final TransformationController _transformController = TransformationController();
  late final AnimationController _animController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  static const double _zoomScale = 3.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(_onAnimTick);
    _transformController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    _transformController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onAnimTick() {
    if (_animation != null) {
      _transformController.value = _animation!.value;
    }
  }

  void _onTransformChanged() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    widget.onZoomChanged(scale > 1.01);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    final currentScale = _transformController.value.getMaxScaleOnAxis();
    final Matrix4 end;

    if (currentScale <= 1.01) {
      final dx = _doubleTapDetails!.localPosition.dx;
      final dy = _doubleTapDetails!.localPosition.dy;
      end = Matrix4.identity()
        ..translate(dx, dy)
        ..scale(_zoomScale)
        ..translate(-dx, -dy);
    } else {
      end = Matrix4.identity();
    }

    _animation = Matrix4Tween(
      begin: _transformController.value,
      end: end,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 1,
        maxScale: 5,
        child: Center(child: widget.imageWidget),
      ),
    );
  }
}
