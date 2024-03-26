import 'dart:io';

import 'package:editor_app/helper/pick_image.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:editor_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppImageProvider()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
        ),
        title: 'Photo Editor',
        home: const PickerScreen(),
      ),
    ),
  );
}

class PickerScreen extends StatefulWidget {
  const PickerScreen({
    super.key,
  });

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  late AppImageProvider imageProvider;
  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Photo Editor',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                PickImage(source: ImageSource.gallery).pickImage(
                    onPick: (File? image) {
                  imageProvider.changeImageFile(image!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                });
              },
              child: const Text('Gallery'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
