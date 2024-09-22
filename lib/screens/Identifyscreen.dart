import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class IdentifyScreen extends StatefulWidget {
  @override
  _IdentifyScreenState createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  File? _image;
  String _classificationResult = "No result";
  late Interpreter _interpreter;

  final List<String> _labels = [
    "alpine sea holly", "anthurium", "artichoke", "azalea", "ball moss",
    "balloon flower", "barbeton daisy", "bearded iris", "bee balm", "bird of paradise",
    "bishop of llandaff", "black-eyed susan", "blackberry lily", "blanket flower",
    "bolero deep blue", "bougainvillea", "bromelia", "buttercup", "californian poppy",
    "camellia", "canna lily", "canterbury bells", "cape flower", "carnation",
    "cautleya spicata", "clematis", "colt's foot", "columbine", "common dandelion",
    "corn poppy", "cyclamen", "daffodil", "desert-rose", "english marigold",
    "fire lily", "foxglove", "frangipani", "fritillary", "garden phlox", "gaura",
    "gazania", "geranium", "giant white arum lily", "globe thistle", "globe-flower",
    "grape hyacinth", "great masterwort", "hard-leaved pocket orchid", "hibiscus",
    "hippeastrum", "japanese anemone", "king protea", "lenten rose", "lotus lotus",
    "love in the mist", "magnolia", "mallow", "marigold", "mexican aster",
    "mexican petunia", "monkshood", "moon orchid", "morning glory", "orange dahlia",
    "osteospermum", "oxeye daisy", "passion flower", "pelargonium", "peruvian lily",
    "petunia", "pincushion flower", "pink primrose", "pink-yellow dahlia", "poinsettia",
    "primula", "prince of wales feathers", "purple coneflower", "red ginger", "rose",
    "ruby-lipped cattleya", "siam tulip", "silverbush", "snapdragon", "spear thistle",
    "spring crocus", "stemless gentian", "sunflower", "sweet pea", "sweet william",
    "sword lily", "thorn apple", "tiger lily", "toad lily", "tree mallow", "tree poppy",
    "trumpet creeper", "wallflower", "water lily", "watercress", "wild pansy",
    "windflower", "yellow iris"
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset("custom_files/model.tflite");
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      classifyImage(_image!);
    }
  }

  Future<void> classifyImage(File image) async {
    // Preprocess the image similar to Python preprocessing
    final img.Image? imgRaw = img.decodeImage(image.readAsBytesSync());

    if (imgRaw != null) {
      final img.Image imgResized = img.copyResize(imgRaw, width: 128, height: 128);
      Float32List inputData = _imageToFloat32List(imgResized);

      // Create a buffer for output
      var output = List.filled(1 * _labels.length, 0).reshape([1, _labels.length]);

      // Run the model
      _interpreter.run(inputData, output);

      // Process the results
      int index = output[0].indexWhere((element) => element == output[0].reduce((a, b) => a > b ? a : b));
      setState(() {
        _classificationResult = _labels[index];
      });
    }
  }

  Float32List _imageToFloat32List(img.Image image) {
    var convertedBytes = Float32List(128 * 128 * 3);

    int pixelIndex = 0;
    for (int i = 0; i < 128; i++) {
      for (int j = 0; j < 128; j++) {
        final pixel = image.getPixel(j, i);

        convertedBytes[pixelIndex++] = img.getRed(pixel) / 255.0;
        convertedBytes[pixelIndex++] = img.getGreen(pixel) / 255.0;
        convertedBytes[pixelIndex++] = img.getBlue(pixel) / 255.0;
      }
    }
    return convertedBytes; // Return the single Float32List
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
        title: Text('Plant Identifier'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null) ...[
            Image.file(_image!),
            SizedBox(height: 20),
            Text(
              'This plant is a: $_classificationResult',
              style: TextStyle(fontSize: 24),
            ),
          ],
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text('Take a Picture'),
              ),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text('Choose from Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
