import 'package:flutter/material.dart';
import 'package:shop/utils/devices/devices_utils.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class CustomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomeAppbar({
    super.key,
    this.title,
    this.showbackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
  });
  final Widget? title;
  final bool showbackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showbackArrow
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? TColors.white : TColors.dark,
              ),
            )
          : leadingIcon != null
          ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
