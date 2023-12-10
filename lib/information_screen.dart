import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: AppBar(
            backgroundColor: const Color(0xFF2C7B50),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'FUNCIONÁRIO',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(240)),
                    child: Image.asset(
                      'assets/images/user_photo.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Text(
                    'Nome do Funcionário',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              expandedTitleScale: 1.0,
            ),
            elevation: 2,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoContainer(context, 'Matrícula', '123456'),
              const Divider(
                thickness: 1,
                color: Color(0xFF49D183),
              ),
              _buildInfoContainer(context, 'Localização', 'endereço'),
              const Divider(
                thickness: 1,
                color: Color(0xFF49D183),
              ),
              _buildInfoContainer(context, 'Data', '12/12/2023'),
              const Divider(
                thickness: 1,
                color: Color(0xFF49D183),
              ),
              _buildInfoContainer(context, 'Horário', '15:40'),
              ElevatedButton(
                onPressed: () {
                  print('Button pressed ...');
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF2C7B50),
                  minimumSize: const Size(180, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
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
    );
  }

  Widget _buildInfoContainer(BuildContext context, String title, String value) {
    return Container(
      width: 394,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 18,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
