import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'cubit/bottom_nav_layout_bloc.dart';

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({super.key, required this.child});

  final Widget child;

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavLayoutCubit, int>(
      builder: (context, currentIndex) {
        final cubit = context.read<BottomNavLayoutCubit>();
        final items = cubit.list;

        return Scaffold(
          extendBody: false,
          extendBodyBehindAppBar: true,
          body: widget.child,
          bottomNavigationBar: BottomNavigationBar(
            // selectedFontSize: 14.0,
            // unselectedFontSize: 14.0,
            // iconSize: 24,
            // selectedLabelStyle: TextStyle(
            //   color: Color(0xff0A83FF),
            //   fontSize: 24.0,
            // ),
            // unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 24),
            // backgroundColor: Colors.white,
            // onTap: cubit.moveTo,
            selectedItemColor: const Color(0xff0A83FF),
            unselectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(
              fontSize: 14.0,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.black
            ),
            onTap: cubit.onTap,
            currentIndex: currentIndex,
            items: List.generate(
              items.length,
              (index) => BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset(
                      items[index].image,
                      height: 24,
                      width: 24
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset(
                      items[index].activeImage,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
                label: items[index].name,
              ),
            ),
          ),
        );
      },
    );
  }
}
