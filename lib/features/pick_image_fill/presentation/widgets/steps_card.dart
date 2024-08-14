import 'package:flutter/material.dart';

class StepsCard extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? bgColor;
  final Widget? backButton;

  const StepsCard({
    super.key,
    this.text,
    this.child,
    this.bgColor,
    this.backButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backButton ?? const SizedBox(),
              Text(
                text ?? "Placeholder Text",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(),
            ],
          ),
          const Divider(color: Colors.grey, thickness: 1),
          ClipRect(child: AnimatedSize(duration: const Duration(milliseconds: 500),child: child ?? const SizedBox())),
        ],
      ),
    );
  }
}
