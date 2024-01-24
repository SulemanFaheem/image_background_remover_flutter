// ignore_for_file: deprecated_member_use, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_background_remover/choose_image.dart';
import 'package:image_background_remover/primary_button.dart';
import 'package:image_background_remover/remover_api.dart';
import 'package:image_background_remover/snack_bar.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatelessWidget {
    GlobalKey _globalKey = GlobalKey();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          title: const Text('Remove Background'),
        ),
        body: Center(
          child: RepaintBoundary(
            key: _globalKey,
            child: GetBuilder<RemoveBgController>(
                init: RemoveBgController(),
                builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (controller.imageFile != null)
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
                                  child: Screenshot(
                                    controller: controller.controller,
                                    child: Image.memory(
                                      controller.imageFile!,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                controller.isLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ReusablePrimaryButton(
                                        childText: "Remove Background",
                                        textColor: Colors.white,
                                        buttonColor: Colors.black,
                                        onPressed: () async {
                                          if (controller.imageFile == null) {
                                            showSnackBar("Error",
                                                "Please select an image", true);
                                          } else {
                                            controller.imageFile =
                                                await RemoveBgController()
                                                    .removeBg(
                                                        controller.imagePath!);
                                            print("Success");
                                          }
                                          controller.update();
                                        }),
                                const SizedBox(height: 20),
                                ReusablePrimaryButton(
                                    childText: "Save Image",
                                    textColor: Colors.white,
                                    buttonColor: Colors.black,
                                    onPressed: () async {
                                      if (controller.imageFile != null) {
                                        controller.saveImage();
              
                                        showSnackBar("Success",
                                            "Image saved successfully", false);
                                      } else {
                                        showSnackBar("Error",
                                            "Please select an image", true);
                                      }
                                    }),
                                const SizedBox(height: 20),
                                ReusablePrimaryButton(
                                    childText: "Add New Image",
                                    textColor: Colors.white,
                                    buttonColor: Colors.black,
                                    onPressed: () async {
                                      controller.cleanUp();
                                    }),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ReusablePrimaryButton(
                                    childText: "Select Image",
                                    textColor: Colors.white,
                                    buttonColor: Colors.grey,
                                    onPressed: () async {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return bottomSheet(
                                                controller, context);
                                          });
                                    }),
                              ],
                            ),
                            
                    ],
                    
                  );
                }),
          ),
              
        ));
  }
}
