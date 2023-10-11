import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_mitra/buttons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File? _image;
  final imagepicker = ImagePicker();
  List _predictions = [];

  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  detect_image(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      _predictions = prediction!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildImageWidget() {
    if (_loading) {
      return Container();
    } else if (_image != null) {
      return Container(height: 200, width: 200, child: Image.file(_image!));
    } else {
      return Container();
    }
  }

  _loadimage_gallery() async {
    var image = await imagepicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);
      detect_image(_image!);
    }
  }

  _loadimage_camera() async {
    var image = await imagepicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _image = File(image.path);
      detect_image(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: DefaultTextStyle(
        style: GoogleFonts.bitter(),
        child: Container(
          height: h,
          width: w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                padding: EdgeInsets.all(10.0),
                child: Image.asset('assets/plantpic.png'),
              ),
              Text(
                'Plant Mitra',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              CustomElevatedButton(
                  onPressed: _loadimage_camera, buttonText: 'Camera'),
              CustomElevatedButton(
                  onPressed: _loadimage_gallery, buttonText: 'Gallery'),
              _buildImageWidget(),
              if (_predictions.isNotEmpty) ...[
                Text('Result: ' + _predictions[0]['label'].toString().substring(2)),
                Text('Confidence: ' + (_predictions[0]['confidence'] * 100).toStringAsFixed(1) + '%'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
