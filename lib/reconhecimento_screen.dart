import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'home_page_model.dart';
import 'information_screen.dart';

class FacialRecognitionPage extends StatefulWidget {
  const FacialRecognitionPage({Key? key}) : super(key: key);

  @override
  _FacialRecognitionPageState createState() => _FacialRecognitionPageState();
}

class _FacialRecognitionPageState extends State<FacialRecognitionPage> {
  late HomePageModel _model;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

@override
void initState() {
  super.initState();
  _model = HomePageModel();
  _model.initState(context);

  _initializeCamera().then((_) {
    setState(() {
      _isCameraInitialized = true;
    });
  });
}

  @override
  void dispose() {
    _model.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
    } catch (e) {
      print('Erro ao inicializar a câmera: $e');
      _showErrorScreen('Erro ao inicializar a câmera');
    }
  }

Future<void> _startFacialRecognition() async {
  try {
    if (!_isCameraInitialized || _cameraController == null || !_cameraController!.value.isInitialized) {
      _showErrorScreen('Câmera não inicializada');
      return;
    }

    if (_cameraController == null) {
      _showErrorScreen('Câmera não inicializada');
      return;
    }

    // Abre a webcam
    await _openWebcam();

    XFile? imageFile = await _cameraController!.takePicture();

    if (imageFile == null) {
      _showErrorScreen('Erro ao capturar imagem');
      return;
    }

    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/recognize_face'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imagem': base64Image}),
    );

    if (response.statusCode == 200) {
      print(response.body);

      String detectedName = extractNameFromResponse(response.body);

      _navigateToInfoScreen(detectedName);
    } else {
      print('Erro na solicitação HTTP: ${response.statusCode}');
      _showErrorScreen('Erro na solicitação HTTP');
    }
  } catch (e) {
    print('Erro durante o reconhecimento facial: $e');
    _showErrorScreen('Erro durante o reconhecimento facial');
  } finally {
    _cameraController?.dispose();
  }
}

Future<void> _openWebcam() async {
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/open_webcam'),
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Erro ao abrir a webcam: ${response.statusCode}');
      _showErrorScreen('Erro ao abrir a webcam');
    }
  } catch (e) {
    print('Erro ao abrir a webcam: $e');
    _showErrorScreen('Erro ao abrir a webcam');
  }
}

  String extractNameFromResponse(String responseBody) {
    try {
      Map<String, dynamic> responseJson = jsonDecode(responseBody);

      if (responseJson.containsKey('nomes_detectados')) {
        List<String> detectedNames = List<String>.from(responseJson['nomes_detectados']);

        if (detectedNames.isNotEmpty) {
          return detectedNames[0];
        }
      }
    } catch (e) {
      print('Erro ao extrair o nome da resposta: $e');
    }

    return 'Desconhecido';
  }

  void _navigateToInfoScreen(String detectedName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InfoScreen(detectedName: detectedName),
      ),
    );
  }

  void _showErrorScreen(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF2C7B50),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(-1.00, 1.00),
            child: Text(
              'Reconhecimento Facial',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          actions: [],
          centerTitle: false,
          toolbarHeight: 100,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: _cameraController != null && _cameraController!.value.isInitialized
                      ? CameraPreview(_cameraController!)
                      : Container(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startFacialRecognition,
                  child: Text(
                    'Iniciar Reconhecimento Facial',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xD1358B61),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 3,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    minimumSize: Size(347, 50),
                    fixedSize: Size(347, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
