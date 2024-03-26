import 'package:flutter/material.dart';

class BlendModeName {
  List<String> list() {
    return [
      'Dstin',
      'Overlay',
      'Screen',
      'Modulate',
      'Difference',
    ];
  }
}

class BlendModes {
  List<BlendMode> list() {
    return [
      BlendMode.dstIn,
      BlendMode.overlay,
      BlendMode.screen,
      BlendMode.modulate,
      BlendMode.difference,
    ];
  }
}
