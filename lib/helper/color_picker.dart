import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ColorPicker {
  show(BuildContext context, {Color? backgroundColor, onPick}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Color tempColor = backgroundColor!;
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('Pick a color'),
                content: Center(
                  child: CircleColorPicker(
                    onChanged: (color) {
                      tempColor = color;
                    },
                    size: const Size(240, 240),
                    strokeWidth: 4,
                    thumbSize: 36,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      onPick(tempColor);
              
                      Navigator.pop(context);
                    },
                    child: const Text('Got it'),
                  ),
                ],
              );
            },
          );
        });
  }
}
