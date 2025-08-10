import 'package:flutter/material.dart';
import 'images_constant/common_images.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String? title;
  final String? subtitle;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool roundedBottom;
  final bool? isHomeButtonEnable;

  const CommonAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.height = 210.0,
    this.backgroundColor = const Color(
      0xFF9D2A53,
    ), // Dark pink tone from design
    this.titleStyle,
    this.subtitleStyle,
    this.roundedBottom = true,
    this.isHomeButtonEnable = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            roundedBottom
                ? const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                )
                : null,
      ),
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  CommonImages.logo,
                  alignment: Alignment.topCenter,
                  height: 70,
                  fit: BoxFit.cover,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  title ?? "",
                  style:
                      titleStyle ??
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                if (subtitle?.isNotEmpty ?? false) ...[
                  Text(
                    subtitle ?? "",
                    style:
                        titleStyle ??
                        const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                  ),
                ],
              ],
            ),
          ),

          // Optional actions (like 3-dot menu)
          Builder(
            builder:
                (context) => Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 35,
                        color: Colors.white,
                      ),

                      onPressed:
                          isHomeButtonEnable == false
                              ? () {
                                Scaffold.of(context).openDrawer();
                              }
                              : () {
                                Navigator.pop(context);
                              },
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
