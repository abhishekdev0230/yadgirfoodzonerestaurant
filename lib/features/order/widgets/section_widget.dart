import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
class SectionWidget extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final Widget child;
  final bool? titleSpace;
  const SectionWidget({super.key, required this.title, required this.child, this.titleWidget, this.titleSpace = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: titleSpace! ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start, children: [
          Text(title, style: robotoMedium),
          titleWidget != null ? titleWidget! : const SizedBox(),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        child,
      ]),
    );
  }
}
