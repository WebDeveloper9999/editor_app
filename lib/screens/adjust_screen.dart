import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/reusablewidget/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late ColorFilterGenerator adj;

  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
  }

  adjust({b, c, s, h, se}) {
    adj = ColorFilterGenerator(name: 'Adjust ', filters: [
      ColorFilterAddons.brightness(b ?? brightness),
      ColorFilterAddons.contrast(b ?? contrast),
      ColorFilterAddons.hue(b ?? hue),
      ColorFilterAddons.sepia(b ?? sepia),
      ColorFilterAddons.saturation(b ?? saturation),
    ]);
  }

  bool showBrightness = false;
  bool showSaturation = false;
  bool showcontrast = false;
  bool showhue = false;
  bool showSepia = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<AppImageProvider>(builder: (context, value, child) {
            return IconButton(
              icon: const Icon(Icons.done),
              color: Colors.white,
              onPressed: ()async {
             
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
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(adj.matrix),
                      child: Image.memory(value.currentImage!),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBrightness,
                        child: slider(
                          value: brightness,
                          onChanged: (value) {
                            setState(
                              () {
                                brightness = value;
                                adjust(b: brightness);
                              },
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: showSaturation,
                        child: slider(
                          value: saturation,
                          onChanged: (value) {
                            setState(
                              () {
                                saturation = value;
                                adjust(s: saturation);
                              },
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: showhue,
                        child: slider(
                          value: hue,
                          onChanged: (value) {
                            setState(
                              () {
                                hue = value;
                                adjust(h: hue);
                              },
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: showSepia,
                        child: slider(
                          value: sepia,
                          onChanged: (value) {
                            setState(
                              () {
                                sepia = value;
                                adjust(se: sepia);
                              },
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: showcontrast,
                        child: slider(
                          value: contrast,
                          onChanged: (value) {
                            setState(
                              () {
                                contrast = value;
                                adjust(c: contrast);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      brightness = 0;
                      contrast = 0;
                      sepia = 0;
                      hue = 0;
                      saturation = 0;
                      adjust(
                        b: brightness,
                        c: contrast,
                        s: saturation,
                        h: hue,
                        se: sepia,
                      );
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
          )
        ],
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
                  setState(() {
                    showBrightness = true;
                    showSaturation = false;
                    showhue = false;
                    showcontrast = false;
                    showSepia = false;
                  });
                },
                icon: Icons.brightness_5_rounded,
                title: 'Brightness',
              ),
              BottomButton(
                onTap: () {
                  setState(() {
                    showBrightness = false;
                    showSaturation = true;
                    showhue = false;
                    showcontrast = false;
                    showSepia = false;
                  });
                },
                icon: Icons.water_drop,
                title: 'Saturation',
              ),
              BottomButton(
                onTap: () {
                  setState(() {
                    showBrightness = false;
                    showSaturation = false;
                    showhue = false;
                    showcontrast = true;
                    showSepia = false;
                  });
                },
                icon: Icons.contrast,
                title: 'Contrast',
              ),
              BottomButton(
                onTap: () {
                  setState(() {
                    showBrightness = false;
                    showSaturation = false;
                    showhue = true;
                    showcontrast = false;
                    showSepia = false;
                  });
                },
                icon: Icons.filter_tilt_shift,
                title: 'Hue',
              ),
              BottomButton(
                onTap: () {
                  setState(() {
                    showBrightness = false;
                    showSaturation = false;
                    showhue = false;
                    showcontrast = false;
                    showSepia = true;
                  });
                },
                icon: Icons.motion_photos_auto,
                title: 'Sepia',
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
      min: -0.9,
      max: 1,
    );
  }

}
