import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback onTap;

  final IconData? icon;
  final String? title;

  const BottomButton({
    super.key,
    required this.onTap,
     this.icon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              title ?? '',
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
