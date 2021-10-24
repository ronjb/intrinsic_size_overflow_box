# intrinsic_size_overflow_box

[![Pub](https://img.shields.io/pub/v/intrinsic_size_overflow_box.svg)](https://pub.dev/packages/intrinsic_size_overflow_box)

A Flutter widget that imposes different constraints on its child than it gets from its parent, possibly allowing the child to overflow the parent.

Similar to `OverflowBox` except that the unconstrained width or height is sized to the intrinsic size of the child, instead of being assumed to be infinite, which allows IntrinsicSizeOverflowBox to be used in a `Scrollable` widget.

Try it out at: [https://ronjb.github.io/intrinsic_size_overflow_box](https://ronjb.github.io/intrinsic_size_overflow_box)

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  intrinsic_size_overflow_box: ^0.1.0
```

## Usage

Then you have to import the package with:

```dart
import 'package:intrinsic_size_overflow_box/intrinsic_size_overflow_box.dart';
```

And use `IntrinsicSizeOverflowBox` where appropriate. For example:

```dart
ListView(
  children: const [
      IntrinsicSizeOverflowBox(
          maxWidth: 700.0,
          child: Text(text),
      ),
  ],
),
```
