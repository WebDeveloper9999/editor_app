import 'dart:io';
import 'dart:typed_data';
import 'package:blur/blur.dart';
import 'package:editor_app/helper/color_picker.dart';
import 'package:editor_app/helper/pick_image.dart';
import 'package:editor_app/helper/pixel_color_image.dart';
import 'package:editor_app/helper/textures.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/reusablewidget/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:editor_app/model/texture.dart' as t;

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  late AppImageProvider imageProvider;
  Uint8List? backgroundImage;
  Uint8List? currentImage;
  ScreenshotController screenshotController = ScreenshotController();
  late t.Texture currentTexture;
  late List<t.Texture> textures;
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    textures = Textures().list();
    currentTexture = textures[0];
  }

  Color backgroundColor = Colors.white;
  int x = 1, y = 1;
  bool showRatio = true;
  bool showBlur = false;
  bool showTexture = false;
  bool showColor = false;
  showActiveWidget({r, b, c, t}) {
    showRatio = r != null ? true : false;
    showBlur = b != null ? true : false;
    showColor = c != null ? true : false;
    showTexture = t != null ? true : false;
    setState(() {});
  }

  showBackgroundImage({b, c, t}) {
    showColorBackground = c != null ? true : false;
    showBlurBackground = b != null ? true : false;
    showTextureBackground = t != null ? true : false;
    setState(() {});
  }

  bool showColorBackground = false;
  bool showBlurBackground = false;
  bool showTextureBackground = false;
  double blur = 0;
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
          'Fit',
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
              currentImage = value.currentImage;
              backgroundImage ??= value.currentImage;
              return AspectRatio(
                aspectRatio: x / y,
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      if (showColorBackground)
                        Container(
                          color: backgroundColor,
                        ),
                      if (showBlurBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(backgroundImage!),
                            ),
                          ),
                        ).blurred(blur: blur, colorOpacity: 0),
                      if (showTextureBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(currentTexture.path!),
                            ),
                          ),
                        ),
                      Center(
                        child: Image.memory(value.currentImage!),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Image.memory(backgroundImage!),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (showRatio) ratioWidget(),
                    if (showBlur) blurWidget(),
                    if (showColor) colorWidget(),
                    if (showTexture) textureWidget(),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomButton(
                      onTap: () {
                        showActiveWidget(r: true);
                      },
                      icon: Icons.aspect_ratio,
                      title: 'Ratio',
                    ),
                    BottomButton(
                      onTap: () {
                        showActiveWidget(b: true);
                        showBackgroundImage(b: true);
                      },
                      icon: Icons.blur_linear_outlined,
                      title: 'Blur',
                    ),
                    BottomButton(
                      onTap: () {
                        showActiveWidget(c: true);
                        showBackgroundImage(c: true);
                      },
                      icon: Icons.color_lens_outlined,
                      title: 'Color',
                    ),
                    BottomButton(
                      onTap: () {
                        showActiveWidget(t: true);
                        showBackgroundImage(t: true);
                      },
                      icon: Icons.texture,
                      title: 'Texture',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ratioWidget() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 1;
                    y = 1;
                  });
                },
                child: const Text(
                  '1:1',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 2;
                    y = 1;
                  });
                },
                child: const Text(
                  '2:1',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 1;
                    y = 2;
                  });
                },
                child: const Text(
                  '1:2',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 4;
                    y = 3;
                  });
                },
                child: const Text(
                  '4:3',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 3;
                    y = 4;
                  });
                },
                child: const Text(
                  '3:4',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 16;
                    y = 9;
                  });
                },
                child: const Text(
                  '16:9',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    x = 9;
                    y = 16;
                  });
                },
                child: const Text(
                  '9:16',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget blurWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                PickImage(source: ImageSource.gallery).pickImage(
                    onPick: (File? image) async {
                  backgroundImage = await image!.readAsBytes();
                  setState(() {});
                });
              },
              icon: const Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                value: blur,
                onChanged: (value) {
                  setState(() {
                    blur = value;
                  });
                },
                max: 100,
                min: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorWidget() {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              ColorPicker().show(
                context,
                backgroundColor: backgroundColor,
                onPick: (color) {
                  setState(
                    () {
                      backgroundColor = color;
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.color_lens_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              PixelColorImage().show(context,
                  backgroundColor: backgroundColor,
                  image: currentImage, onPick: (color) {
                setState(() {
                  backgroundColor = color;
                });
              });
            },
            icon: const Icon(
              Icons.colorize_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget textureWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: textures.length,
          itemBuilder: (context, index) {
            t.Texture texture = textures[index];
            return Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.white),
              width: 80,
              child: FittedBox(
                fit: BoxFit.fill,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      currentTexture = texture;
                    });
                  },
                  child: Image.asset(texture.path!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
