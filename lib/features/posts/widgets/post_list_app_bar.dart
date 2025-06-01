import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      titleSpacing: 16, // 로고와 왼쪽 여백 사이 간격 조정
      title: Image.asset(
        'assets/logos/logor가로@2x.png',
        height: 30,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity:
                    const VisualDensity(horizontal: -3.0, vertical: -3.0),
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  'assets/icons/Search.svg',
                  width: 25,
                ),
                onPressed: () {},
              ),
              IconButton(
                visualDensity:
                    const VisualDensity(horizontal: -3.0, vertical: -3.0),
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  width: 25,
                ),
                onPressed: () {},
              ),
              IconButton(
                visualDensity:
                    const VisualDensity(horizontal: -3.0, vertical: -3.0),
                padding: const EdgeInsets.only(left: -3.5, right: 5),
                icon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  width: 25,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
