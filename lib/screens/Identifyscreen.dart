import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_widgets/CustomButton.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'ResultScreen.dart';
import '../custom_widgets/CustomFooter.dart';

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  _IdentifyScreenState createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
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
  }

  Future<void> _loadLabels() async {
    final jsonString = await rootBundle.loadString(labelsPath);
    _labels = List<String>.from(json.decode(jsonString));
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _selectedImage = File(image.path);
      await _predictImage(_selectedImage!);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
      await _predictImage(_selectedImage!);
    }
  }

  Future<void> _predictImage(File image) async {
    var inputImage = await _preprocessImage(image);
    var output = List.generate(1, (b) => List<double>.filled(_labels!.length, 0.0));

    // Run inference
    _interpreter.run(inputImage, output);

    // Find the maximum probability and its class index
    int predictedClass = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
    double maxProbability = output[0][predictedClass];

    // Check if the maximum probability is below 60%
    if (maxProbability < 0.6) {
      // Navigate to ResultScreen with no result message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            classificationResult: "No result found",
            image: image,
          ),
        ),
      );
    } else {
      // Navigate to ResultScreen with the predicted label
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            classificationResult: _labels![predictedClass],
            image: image,
          ),
        ),
      );
    }
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
        title: Text('Identify Plant'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    CustomButton(
                      text: "Snap a picture",
                      icon: Icons.add_a_photo,
                      onPressed: _pickImageFromCamera,
                    ),
                    SizedBox(height: 30),
                    CustomButton(
                      text: "Select from local device",
                      icon: Icons.folder,
                      onPressed: _pickImageFromGallery,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}