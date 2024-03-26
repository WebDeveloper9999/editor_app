
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/reusablewidget/bottom_button.dart';
import 'package:editor_app/screens/adjust_screen.dart';
import 'package:editor_app/screens/blur_screen.dart';
import 'package:editor_app/screens/crop_screen.dart';
import 'package:editor_app/screens/draw_screen.dart';
import 'package:editor_app/screens/filter_screen.dart';
import 'package:editor_app/screens/fit_screen.dart';
import 'package:editor_app/screens/mask_screen.dart';
import 'package:editor_app/screens/sticker_screen.dart';
import 'package:editor_app/screens/text_screen.dart';
import 'package:editor_app/screens/tint_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: CloseButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black,
          title: const Text(
            'Home Screen',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
          ],
        ),
        body: Center(
          child: Consumer<AppImageProvider>(
            builder: (context, value, child) {
              return Image.memory(value.currentImage!);
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 70,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CropScreen(),
                      ),
                    );
                  },
                  icon: Icons.crop,
                  title: 'Crop',
                ),
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FilterScreen(),
                      ),
                    );
                  },
                  icon: Icons.filter,
                  title: 'Filter',
                ),
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdjustScreen(),
                      ),
                    );
                  },
                  icon: Icons.tune,
                  title: 'Adjust',
                ),
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FitScreen(),
                      ),
                    );
                  },
                  icon: Icons.fit_screen,
                  title: 'Fit',
                ),
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TintScreen(),
                      ),
                    );
                  },
                  icon: Icons.border_color_outlined,
                  title: 'Tint',
                ),
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BlurScreen(),
                      ),
                    );
                  },
                  icon: Icons.blur_circular,
                  title: 'Blur',
                ),
            
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StickerScreen(),
                      ),
                    );
                  },
                  icon: Icons.emoji_emotions_outlined,
                  title: 'Stickers',
                ),
            
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TextScreen(),
                      ),
                    );
                  },
                  icon: Icons.text_fields_rounded,
                  title: 'Text',
                ),
            
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrawScreen(),
                      ),
                    );
                  },
                  icon: Icons.draw_outlined,
                  title: 'Draw',
                ),
            
                BottomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaskScreen(),
                      ),
                    );
                  },
                  icon: Icons.star_border,
                  title: 'Mask',
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
