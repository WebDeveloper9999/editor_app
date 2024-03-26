import 'dart:typed_data';

import 'package:crop_image/crop_image.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  late CropController cropController;
  @override
  void initState() {
    super.initState();
    cropController = CropController(
      aspectRatio: 1,
      defaultCrop: const Rect.fromLTRB(0.05, 0.05, 0.95, 0.95),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Refreshed');
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        actions: [
          Consumer<AppImageProvider>(builder: (context, value, child) {
            return IconButton(
              icon: const Icon(Icons.done),
              color: Colors.white,
              onPressed: () async {
                ui.Image bitMap = await cropController.croppedBitmap();
                ByteData? data =
                    await bitMap.toByteData(format: ui.ImageByteFormat.png);
                Uint8List bytes = data!.buffer.asUint8List();
                value.changeImage(bytes);
                if (!mounted) return;
                Navigator.pop(context);
              },
            );
          })
        ],
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, value, child) {
            if (value.currentImage != null) {
              return CropImage(
                image: Image.memory(value.currentImage!),
                controller: cropController,
                gridColor: Colors.white,
                gridCornerColor: Colors.white,
                gridCornerSize: 50,
                gridThinWidth: 3,
                gridThickWidth: 6,
                scrimColor: Colors.grey.withOpacity(0.5),
                onCrop: (rect) => debugPrint(rect.toString()),
                minimumImageSize: 50,
                maximumImageSize: 2000,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    cropController.rotateLeft();
                  },
                  child: const Icon(
                    Icons.rotate_90_degrees_ccw_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    cropController.rotateRight();
                  },
                  child: const Icon(
                    Icons.rotate_90_degrees_cw_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 20,
                  width: 2,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              bottomButton(
                title: 'Free',
                onTap: () {
                  cropController.aspectRatio = null;
                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                },
              ),
              bottomButton(
                title: 'Square',
                onTap: () {
                  cropController.aspectRatio = 1.0;
                },
              ),
              bottomButton(
                title: '1:2',
                onTap: () {
                  cropController.aspectRatio = 0.5;
                },
              ),
              bottomButton(
                title: '2:1',
                onTap: () {
                  cropController.aspectRatio = 2.0 / 1;
                },
              ),
              bottomButton(
                title: '16:9',
                onTap: () {
                  cropController.aspectRatio = 16.0 / 9.0;
                },
              ),
              bottomButton(
                title: '4:3',
                onTap: () {
                  cropController.aspectRatio = 4.0 / 3.0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButton({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
