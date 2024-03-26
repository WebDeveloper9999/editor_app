import 'dart:typed_data';

import 'package:editor_app/helper/filters.dart';
import 'package:editor_app/model/filter.dart';
import 'package:editor_app/provider/app_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentFilter;
  late List<Filter> filters;
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    filters = Filters().list();
    currentFilter = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: ()async {
             
              Uint8List? bytes = await screenshotController.capture();
              imageProvider.changeImage(bytes!);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, value, child) {
            return Screenshot(
              controller: screenshotController,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(currentFilter.matrix),
                child: Image.memory(value.currentImage!),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: 50,
        height: 80,
        child: Consumer<AppImageProvider>(
          builder: (context, value, index) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                Filter filter = filters[index];
                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: Colors.white),
                  width: 80,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentFilter = filter;
                        });
                      },
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(filter.matrix),
                        child: Image.memory(value.currentImage!),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
