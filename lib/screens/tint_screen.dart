import 'dart:typed_data';
import 'dart:ui';

import 'package:editor_app/helper/tints.dart';
import 'package:editor_app/model/tint.dart' as t;
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class TintScreen extends StatefulWidget {
  const TintScreen({super.key});

  @override
  State<TintScreen> createState() => _TintScreenState();
}

class _TintScreenState extends State<TintScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late t.Tint currentTint;
  late List<t.Tint> tints;
  int index = 0;
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    tints = Tints().list();
    currentTint = tints[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          'Tint',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
                    child: Image.memory(
                      value.currentImage!,
                      color:
                          tints[index].color.withOpacity(tints[index].opacity),
                      colorBlendMode: BlendMode.color,
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
                  value: tints[index].opacity,
                  onChanged: (value) {
                    setState(() {
                      tints[index].opacity = value;
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tints.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              t.Tint tint = tints[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      this.index = index;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        this.index == index ? Colors.white : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        backgroundColor: tint.color,
                      ),
                    ),
                  ),
                ),
              );
            },
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
      min: 0,
      max: 1,
    );
  }

}
