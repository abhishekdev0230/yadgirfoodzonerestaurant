import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subTitle;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final Widget? menuWidget;
  const CustomAppBarWidget({super.key, required this.title, this.onBackPressed, this.isBackButtonExist = true, this.menuWidget, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(title!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color)),
          subTitle != null ? Text(subTitle!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)) : const SizedBox(),
        ],
      ),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge!.color,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
      elevation: 2,
      actions: menuWidget != null ? [menuWidget!, const SizedBox(width: 10)] : null,
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}