import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ডাটা মডেল ক্লাস (আইকন এবং লেবেলের জন্য)
class NavItem {
  final String svgPath;
  final String label;

  NavItem({required this.svgPath, required this.label});
}

class CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItem> items;
  final Function(int) onItemSelected;

  const CustomFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ফ্লোটিং ইফেক্ট দেওয়ার জন্য মার্জিন
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 20 + MediaQuery.of(context).viewPadding.bottom,
      ),
      padding: const EdgeInsets.all(5),
      height: 70, // বার-এর উচ্চতা
      decoration: BoxDecoration(
        color: Color(
          0xFF8e8e8e,
        ), // পুরো বার-এর ব্যাকগ্রাউন্ড (ট্রান্সপারেন্ট গ্রে)
        borderRadius: BorderRadius.circular(50), // ক্যাপসুল শেইপ
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final bool isSelected = selectedIndex == index;

          return Expanded(
            flex: isSelected ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => onItemSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: 55,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF050505)
                        : const Color(0xFFb6b0b1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        items[index].svgPath,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        height: 26,
                        width: 26,
                      ),
                      if (isSelected)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              items[index].label,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
