import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reconhecimento_screen.dart'; // Substitua com o caminho correto

import 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
              'Minhas Atividades',
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
            child: ListView(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacialRecognitionPage()),
                    );
                  },
                  child: Text(
                    'CONST01 - Construção 1',
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
                SizedBox(height: 35), // Adiciona espaço entre os botões
                ElevatedButton(
                  onPressed: () {
                    print('Button 2 pressed ...');
                  },
                  child: Text(
                    'OBRA014 - Obra Escola',
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
                SizedBox(height: 35), // Adiciona espaço entre os botões
                ElevatedButton(
                  onPressed: () {
                    print('Button 3 pressed ...');
                  },
                  child: Text(
                    'CONST007 - Prédio 7',
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
                SizedBox(height: 35), // Adiciona espaço entre os botões
                ElevatedButton(
                  onPressed: () {
                    print('Button 4 pressed ...');
                  },
                  child: Text(
                    'CONST02 - Construção 2',
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
