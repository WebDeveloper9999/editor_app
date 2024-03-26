import 'dart:typed_data';
import 'dart:ui';

import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/reusablewidget/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Blur',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Consumer<AppImageProvider>(builder: (context, value, child) {
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
          })
        ],
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (context, value, child) {
                if (value.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                          sigmaX: sigmaX,
                          sigmaY: sigmaY,
                          tileMode: tileMode),
                      child: Image.memory(value.currentImage!),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: slider(
                  value: sigmaX,
                  onChanged: (value) {
                    setState(() {
                      sigmaX = value;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: slider(
                  value: sigmaY,
                  onChanged: (value) {
                    setState(() {
                      sigmaY = value;
                    });
                  },
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                BottomButton(
                  onTap: () {
                    tileMode = TileMode.decal;
                    setState(() {
                      
                    });
                  },
                  title: 'Decal',
                ),
            
                BottomButton(
                  onTap: () {
                    tileMode = TileMode.clamp;setState(() {
                      
                    });
                  },
                  title: 'Clamp',
                ),
            
                BottomButton(
                  onTap: () {
                    tileMode = TileMode.mirror;setState(() {
                      
                    });
                  },
                  title: 'Mirror',
                ),
            
                BottomButton(
                  onTap: () {
                    tileMode = TileMode.repeated;setState(() {
                      
                    });
                  },
                  title: 'Repeated',
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      onChanged: onChanged,
      min: 0.1,
      max: 10,
    );
  }
}
