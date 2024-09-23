
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class NewTestScreen extends StatefulWidget {
  const NewTestScreen({super.key});

  @override
  _NewTestScreenState createState() => _NewTestScreenState();
}

class _NewTestScreenState extends State<NewTestScreen> {
  File? _image;
  String? _predictedLabel;
  final String modelPath = "custom_files/model.tflite";
  final String labelsPath = "custom_files/labels.json";
  late Interpreter _interpreter;
  List<String>? _labels;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelPath);
    debugPrint("Loadmodel ended");
  }

  Future<void> _loadLabels() async {
    final jsonString = await rootBundle.loadString(labelsPath);
    _labels = List<String>.from(json.decode(jsonString));
    debugPrint("Loadlabels ended");
  }

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _predictedLabel = null; // Reset prediction
      });
      await _predictImage(_image!);
    }
  }

  Future<void> _predictImage(File image) async {
    var inputImage = await _preprocessImage(image);
    var output = List.generate(1, (b) => List<double>.filled(_labels!.length, 0.0));

    // Run inference
    _interpreter.run(inputImage, output);

    int predictedClass = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
    debugPrint("Predicted Class: $predictedClass");
    debugPrint("Predicted Class Name: ${_labels![predictedClass]}");
    debugPrint("${_labels![predictedClass]}: ${output[0][predictedClass]}");

    setState(() {
      _predictedLabel = _labels![predictedClass];
    });
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File image) async {
    final inputSize = 128;
    final imageBytes = await image.readAsBytes();
    img.Image? decodedImage = img.decodeImage(imageBytes);

    // Resize the image
    img.Image resizedImage = img.copyResize(decodedImage!, width: inputSize, height: inputSize);

    // Create a 4D list for model input
    List<List<List<List<double>>>> input = List.generate(
      1, // Batch size = 1
          (b) => List.generate(
        inputSize,
            (y) => List.generate(
          inputSize,
              (x) {
            img.Pixel pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r.toDouble(),
              pixel.g.toDouble(),
              pixel.b.toDouble(),
            ];
          },
        ),
      ),
    );

    return input;
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.black, size: 36),
            SizedBox(width: 10),
            Text('New Test Screen'),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _chooseImage,
                      child: Text('Choose Image'),
                    ),
                    if (_image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (_predictedLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Predicted: $_predictedLabel',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              color: Colors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }
}
