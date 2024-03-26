import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';

class PixelColorImage {
  show(BuildContext context,
      {Color? backgroundColor, Uint8List? image, onPick}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = backgroundColor!;
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Move your finger'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PixelColorPicker(
                    child: SizedBox(width:MediaQuery.of(context).size.width/1.25,height:MediaQuery.of(context).size.height/1.75,child: Image.memory(image!,fit: BoxFit.contain,)),
                    onChanged: (color) {
                      setState(
                        () {
                          tempColor = color;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: tempColor,
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onPick(tempColor);
                    Navigator.pop(context);
                  },
                  child: const Text('Pick'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
