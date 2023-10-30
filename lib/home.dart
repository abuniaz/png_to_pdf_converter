import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  File? image;
  // final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile =
  //       await picker.pickImage(source: ImageSource.gallery);
  // }
  ImagePicker? imagePicker;

  pickImageFromGallert() async {
    PickedFile pickedFile = (await imagePicker!
        .pickImage(source: ImageSource.gallery)) as PickedFile;
    image = File(pickedFile.path);

    setState(() {
      image;
      performImageLabeling();
    });
  }

  pickImageFromCamera() async {
    PickedFile pickedFile = (await imagePicker!
        .pickImage(source: ImageSource.camera)) as PickedFile;
    image = File(pickedFile.path);

    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image!);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    VisionText visionText =
        await textRecognizer.processImage(firebaseVisionImage);
    result = '';
    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String? txt = block.text;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += element.text!;
            "";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back.jpg"), fit: BoxFit.cover)),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
            ),
            Container(
              height: 280,
              width: 250,
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/note.jpg"), fit: BoxFit.cover)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset("assets/pin.png"),
                      )
                    ],
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          pickImageFromGallert();
                        },
                        onLongPress: () {
                          pickImageFromCamera();
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 25),
                            child: image != null
                                ? Image.file(
                                    image!,
                                    width: 140,
                                    height: 192,
                                    fit: BoxFit.fill,
                                  )
                                : Container(
                                    width: 240,
                                    height: 200,
                                    child: const Icon(
                                      Icons.camera_enhance_sharp,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
