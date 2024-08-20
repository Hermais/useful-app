import 'package:flutter/material.dart';

class AdjustedElevatedButton extends StatelessWidget {
  final EdgeInsets? padding;
  final void Function()? onPressed;
  final Widget? child;

  const AdjustedElevatedButton({super.key, this.padding, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8),
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
