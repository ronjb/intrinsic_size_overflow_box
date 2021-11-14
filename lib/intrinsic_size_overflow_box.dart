// Copyright (c) 2021 Ron Booth. All rights reserved.
// Use of this source code is governed by a license that can be found in the
// LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A widget that imposes different constraints on its child than it gets from
/// its parent, possibly allowing the child to overflow the parent.
///
/// Similar to `OverflowBox` except that the unconstrained width or height
/// is sized to the intrinsic size of the child, instead of being assumed to be
/// infinite, which allows IntrinsicSizeOverflowBox to be used in a `Scrollable`
/// widget.
class IntrinsicSizeOverflowBox extends SingleChildRenderObjectWidget {
  /// Creates a new IntrinsicSizeOverflowBox, a widget that imposes different
  /// constraints on its child than it gets from its parent, possibly allowing
  /// the child to overflow the parent.
  ///
  /// Similar to `OverflowBox` except that the unconstrained width or height
  /// is sized to the intrinsic size of the child, instead of being assumed to 
  /// be infinite, which allows IntrinsicSizeOverflowBox to be used in a 
  /// `Scrollable` widget.
  const IntrinsicSizeOverflowBox({
    Key? key,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    required Widget child,
  }) : super(key: key, child: child);

  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;

  @override
  RenderIntrinsicSizeOverflowBox createRenderObject(BuildContext context) {
    return RenderIntrinsicSizeOverflowBox(
      childConstraints: _childConstraints,
    );
  }

  BoxConstraints get _childConstraints {
    return BoxConstraints(
        minWidth: minWidth ?? 0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0,
        maxHeight: maxHeight ?? double.infinity);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderIntrinsicSizeOverflowBox renderObject) {
    renderObject.childConstraints = _childConstraints;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('minWidth', minWidth, defaultValue: null))
      ..add(DoubleProperty('maxWidth', maxWidth, defaultValue: null))
      ..add(DoubleProperty('minHeight', minHeight, defaultValue: null))
      ..add(DoubleProperty('maxHeight', maxHeight, defaultValue: null));
  }
}

class RenderIntrinsicSizeOverflowBox extends RenderProxyBox {
  RenderIntrinsicSizeOverflowBox({
    RenderBox? child,
    required BoxConstraints childConstraints,
  })  :
        // ignore: unnecessary_null_comparison
        assert(childConstraints != null),
        assert(childConstraints.debugAssertIsValid()),
        _childConstraints = childConstraints,
        super(child);

  BoxConstraints get childConstraints => _childConstraints;
  BoxConstraints _childConstraints;
  set childConstraints(BoxConstraints value) {
    // ignore: unnecessary_null_comparison
    assert(value != null);
    assert(value.debugAssertIsValid());
    if (_childConstraints == value) return;
    _childConstraints = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _computeLayout();

  @override
  void performLayout() {
    size = _computeLayout();
  }

  Size _computeLayout() {
    Size? size;
    if (child != null) {
      if (childConstraints.hasBoundedWidth) {
        if (!childConstraints.hasBoundedHeight) {
          // If bounded width and not bounded height, use child's height.
          final c = childConstraints.enforceIfNotBounded(constraints);
          child!.layout(c, parentUsesSize: true);
          size = Size(
            childConstraints.enforce(constraints).constrain(Size.zero).width,
            child!.size.height,
          );
        }
      } else if (childConstraints.hasBoundedHeight) {
        // If bounded height and not bounded width, use child's width.
        final c = childConstraints.enforceIfNotBounded(constraints);
        child!.layout(c, parentUsesSize: true);
        size = Size(
          child!.size.width,
          childConstraints.enforce(constraints).constrain(Size.zero).height,
        );
      } else {
        // If no bounded width or height, allow child to set its size.
        child!.layout(const BoxConstraints(), parentUsesSize: true);
        size = Size(
          childConstraints.enforce(constraints).constrain(child!.size).width,
          childConstraints.enforce(constraints).constrain(child!.size).height,
        );
      }
    }

    size ??= childConstraints.enforce(constraints).constrain(Size.zero);
    // print('_computeLayout with $constraints returns $size');
    return size;
  }

  @override
  void debugPaintSize(PaintingContext context, Offset offset) {
    super.debugPaintSize(context, offset);
    assert(() {
      Paint paint;
      if (child == null || child!.size.isEmpty) {
        paint = Paint()..color = const Color(0x90909090);
        context.canvas.drawRect(offset & size, paint);
      }
      return true;
    }());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'childConstraints', childConstraints));
  }
}

extension IntrinsicSizeOverflowBoxExtOnBoxConstraints on BoxConstraints {
  BoxConstraints enforceIfNotBounded(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: hasBoundedWidth
          ? minWidth
          : minWidth
              .clamp(constraints.minWidth, constraints.maxWidth)
              .toDouble(),
      maxWidth: hasBoundedWidth
          ? maxWidth
          : maxWidth
              .clamp(constraints.minWidth, constraints.maxWidth)
              .toDouble(),
      minHeight: hasBoundedHeight
          ? minHeight
          : minHeight
              .clamp(constraints.minHeight, constraints.maxHeight)
              .toDouble(),
      maxHeight: hasBoundedHeight
          ? maxHeight
          : maxHeight
              .clamp(constraints.minHeight, constraints.maxHeight)
              .toDouble(),
    );
  }
}
