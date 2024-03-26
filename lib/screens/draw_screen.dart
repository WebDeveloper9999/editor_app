import 'dart:typed_data';
import 'package:editor_app/helper/color_picker.dart';
import 'package:editor_app/helper/pixel_color_image.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/reusablewidget/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  LindiController lindiController = LindiController();
  PainterController painterController = PainterController();
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    painterController.thickness = 5.0;
    painterController.backgroundColor = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Draw',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Consumer<AppImageProvider>(
            builder: (context, value, child) {
              return IconButton(
                icon: const Icon(Icons.done),
                color: Colors.white,
                onPressed: () async {
                  Uint8List? bytes = await lindiController.saveAsUint8List();
                  imageProvider.changeImage(bytes!);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (context, value, child) {
                if (value.currentImage != null) {
                  return LindiStickerWidget(
                    controller: lindiController,
                    child: Stack(
                      children: [
                        Image.memory(value.currentImage!),
                        Positioned.fill(
                          child: Painter(painterController),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                slider(
                  value: painterController.thickness,
                  onChanged: (value) {
                    setState(() {
                      painterController.thickness = value;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        color: Colors.black,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomButton(
                onTap: () {
                  if (!painterController.isEmpty) {
                    painterController.undo();
                  }
                },
                icon: Icons.undo,
              ),
              BottomButton(
                onTap: () {
                  ColorPicker().show(
                    context,
                    backgroundColor: painterController.drawColor,
                    onPick: (color) {
                      setState(() {
                        painterController.drawColor = color;
                      });
                    },
                  );
                },
                icon: Icons.color_lens_outlined,
              ),
            
              BottomButton(
                onTap: () {
                  PixelColorImage().show(
                    context,
                    backgroundColor: painterController.drawColor,
                    image: imageProvider.currentImage,
                    onPick: (color) {
                      setState(() {
                        painterController.drawColor = color;
                      });
                    },
                  );
                },
                icon: Icons.colorize,
              ),
            
              BottomButton(
                onTap: () {
                  if (!painterController.isEmpty) {
                    painterController.clear();
                  }
                },
                icon: Icons.delete,
              ),
              BottomButton(
                onTap: () {
                  setState(() {
                    painterController.eraseMode = !painterController.eraseMode;
                  });
                },
                icon: Icons.create,
              ),
            ],
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
      min: 1,
      max: 20,
    );
  }
}
