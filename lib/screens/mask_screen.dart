import 'dart:typed_data';

import 'package:editor_app/helper/blend_mode.dart';
import 'package:editor_app/helper/shapes.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/reusablewidget/gesture_detector_widget.dart';
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:widget_mask/widget_mask.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({super.key});

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  LindiController lindiController = LindiController();
  BlendMode blendMode = BlendMode.dstIn;
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  IconData maskIcon = Icons.favorite;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<AppImageProvider>(
            builder: (context, value, child) {
              return IconButton(
                icon: const Icon(Icons.done),
                color: Colors.white,
                onPressed: () async {
                  Uint8List? bytes = await screenshotController.capture();
                  imageProvider.changeImage(bytes!);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              );
            },
          )
        ],
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mask',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, value, child) {
            if (value.currentImage != null) {
              return
                  // LindiStickerWidget(
                  //   controller: lindiController,
                  //   child: Image.memory(value.currentImage!),
                  // );
                  Screenshot(
                controller: screenshotController,
                child: WidgetMask(
                  childSaveLayer: true,
                  blendMode: blendMode,
                  mask: Stack(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      GestureDetectorWidget(
                        child: Icon(
                          maskIcon,
                          size: 250,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  child: Image.memory(value.currentImage!),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          for (int i = 0;
                              i < BlendModeName().list().length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    blendMode = BlendModes().list()[i];
                                  });
                                },
                                child: Text(
                                  BlendModeName().list()[i],
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          for (int i = 0; i < Shapes().list().length; i++)
                            bottomBarItem(
                              Shapes().list()[i],
                              onTap: () {
                                setState(() {
                                 maskIcon  = Shapes().list()[i];
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget bottomBarItem(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
