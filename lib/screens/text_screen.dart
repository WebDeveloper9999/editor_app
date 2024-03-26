import 'dart:typed_data';

import 'package:editor_app/helper/fonts.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:text_editor/text_editor.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  LindiController lindiController = LindiController();
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  bool showEditor = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Text',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Consumer<AppImageProvider>(builder: (context, value, child) {
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
                  return LindiStickerWidget(
                    controller: lindiController,
                    child: Image.memory(value.currentImage!),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.black,
            width: double.infinity,
            height: 70,
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showEditor = true;
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    'Add Text',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: Container(
          //   height: 120,
          //   width: double.infinity,
          //   decoration: const BoxDecoration(color: Colors.black),
          //   child: SafeArea(
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: Container(
          //             decoration: const BoxDecoration(color: Colors.transparent),
          //             child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: stickers.length,
          //               itemBuilder: (context, index) {
          //                 String sticker = stickers[index];
          //                 return Container(
          //                   margin: const EdgeInsets.all(5),
          //                   decoration: const BoxDecoration(color: Colors.white),
          //                   width: 80,
          //                   child: FittedBox(
          //                     fit: BoxFit.fill,
          //                     child: InkWell(
          //                       onTap: () {
          //                         lindiController.addWidget(
          //                           Image.asset(sticker),
          //                         );
          //                       },
          //                       child: Image.asset(sticker),
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //         ),
          //         SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: Row(
          //             children: [
          //               for (int i = 0; i < stickers.length; i++)
          //                 bottomBarItem(
          //                   i,
          //                   stickers[i].toString(),
          //                   onTap: () {
          //                     setState(() {
          //                       index = i;
          //                     });
          //                   },
          //                 ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        if (showEditor)
          Scaffold(
            backgroundColor: Colors.black54,
            body: SafeArea(
              child: TextEditor(
                minFontSize: 10,
                maxFontSize: 70,
                fonts:  Fonts().list(),
                textStyle: const TextStyle(color: Colors.white),
                onEditCompleted: (style, align, text) {
                  if (text.isNotEmpty) {
                    showEditor = false;
                    setState(() {
                      lindiController.addWidget(Text(
                        text,
                        style: style,
                        textAlign: align,
                      ));
                    });
                  } else {
                    setState(() {
                      showEditor = false;
                    });
                  }
                },
              ),
            ),
          )
      ],
    );
  }

  // Widget bottomBarItem(int ind, String icon, {required VoidCallback onTap}) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Padding(
  //       padding: const EdgeInsets.only(),
  //       child: Column(
  //         children: [
  //           Container(
  //             width: 20,
  //             height: 2,
  //             decoration: BoxDecoration(
  //               color: ind == index ? Colors.blue : Colors.white,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 10,
  //               vertical: 10,
  //             ),
  //             child: Image.asset(
  //               icon,
  //               width: 30,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
