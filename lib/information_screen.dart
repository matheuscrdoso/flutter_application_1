import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'home_page_widget.dart';

class InfoScreen extends StatelessWidget {
  final String detectedName;

  InfoScreen({required this.detectedName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Color(0xFF2C7B50), // Fundo verde
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'FUNCIONÁRIO',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/images/user_photo.jpg'),
                        ),
                        SizedBox(height: 12),
                        Text(
                          detectedName, // Usar o nome detectado
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildInfoItem(context, 'Matrícula', '123456'),
                  _buildDivider(context),
                  FutureBuilder<String>(
                    future: _getLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao obter a localização');
                      } else {
                        return _buildInfoItem(context, 'Localização', snapshot.data ?? 'N/A');
                      }
                    },
                  ),
                  _buildDivider(context),
                  _buildInfoItem(context, 'Data', _getCurrentDate()),
                  _buildDivider(context),
                  _buildInfoItem(context, 'Horário', _getCurrentTime()),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePageWidget()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      primary: Color(0xFF2C7B50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CONFIRMAR',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Readex Pro',
              fontSize: 18,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Divider(
        thickness: 1,
        color: Color(0xFF49D183),
      ),
    );
  }

  // Função para obter a localização do usuário
  Future<String> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return 'Lat: ${position.latitude}, Long: ${position.longitude}';
    } catch (e) {
      return 'Erro ao obter a localização';
    }
  }

 
//   Future<String> _getLocation() async {
//   try {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//     // Realiza a reversão geográfica
//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

//     if (placemarks.isNotEmpty) {
//       Placemark placemark = placemarks.first;
//       return 'Endereço: ${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
//     } else {
//       return 'Endereço não disponível';
//     }
//   } catch (e) {
//     return 'Erro ao obter o endereço';
//   }
// }
  

  // Função para obter a data atual
  String _getCurrentDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  // Função para obter a hora atual
  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }
}
