import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
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
                          'Nome do Funcionário',
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
                  _buildInfoItem(context, 'Localização', 'endereço'),
                  _buildDivider(context),
                  _buildInfoItem(context, 'Data', '12/12/2023'),
                  _buildDivider(context),
                  _buildInfoItem(context, 'Horário', '15:40'),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      print('Button pressed ...');
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
}
