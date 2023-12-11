import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'home_page_model.dart';
import 'information_screen.dart'; // Importe a tela de informações

class FacialRecognitionPage extends StatefulWidget {
  const FacialRecognitionPage({Key? key}) : super(key: key);

  @override
  _FacialRecognitionPageState createState() => _FacialRecognitionPageState();
}

class _FacialRecognitionPageState extends State<FacialRecognitionPage> {
  late HomePageModel _model;
  late CameraController? _cameraController;
  bool _isCameraInitialized = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();
    _model.initState(context);

    _initializeCamera().then((_) {
      setState(() {});
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
    }
  }

  Future<void> _startFacialRecognition() async {
    try {
      // Abra a webcam antes de iniciar o reconhecimento facial
      final responseOpenWebcam = await http.post(
        Uri.parse('http://127.0.0.1:5000/open_webcam'),
        headers: {'Content-Type': 'application/json'},
      );

      if (responseOpenWebcam.statusCode == 200) {
        print('Webcam aberta com sucesso');
      } else {
        print('Erro ao abrir a webcam: ${responseOpenWebcam.statusCode}');
        return;
      }

      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        print('Câmera não inicializada');
        return;
      }

      XFile? imageFile = await _cameraController!.takePicture();

      if (imageFile == null) {
        print('Erro ao capturar imagem');
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

        // Extrair o nome detectado a partir da resposta
        String detectedName = extractNameFromResponse(response.body);

        // Navegar para a tela de informações
        _navigateToInfoScreen(detectedName);
      } else {
        print('Erro na solicitação HTTP: ${response.statusCode}');
        _showErrorScreen();
      }
    } catch (e) {
      print('Erro durante o reconhecimento facial: $e');
      _showErrorScreen();
    }
  }

  String extractNameFromResponse(String responseBody) {
    try {
      // Parse o JSON da resposta
      Map<String, dynamic> responseJson = jsonDecode(responseBody);

      // Verifique se a resposta contém a chave 'nomes_detectados'
      if (responseJson.containsKey('nomes_detectados')) {
        // Obtenha a lista de nomes detectados
        List<String> nomesDetectados = List<String>.from(responseJson['nomes_detectados']);

        // Verifique se a lista não está vazia e retorne o primeiro nome
        if (nomesDetectados.isNotEmpty) {
          return nomesDetectados[0];
        }
      }
    } catch (e) {
      print('Erro ao extrair o nome da resposta: $e');
    }

    // Em caso de erro ou se não houver nomes detectados, retorne "Desconhecido"
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

  void _showErrorScreen() {
    // Mostrar tela de erro
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text("Não foi possível reconhecer a pessoa."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fechar o diálogo de erro
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
              'Reconhecimento',
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
