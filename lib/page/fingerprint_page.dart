
import 'package:finger_print/api/local_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'home_page.dart';

class FingerprintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Color(0xFFAD3436),
          automaticallyImplyLeading: false,
          title: Text("Daily Attendance"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                buildAuthenticate(context),
                SizedBox(height: 30,),
                buildAuthenticateLogout(context),
              ],
            ),
          ),
        ),
      );





  Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Login',
        icon: Icons.lock_open,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },

      );
  Widget buildAuthenticateLogout(BuildContext context) => buildButton(
        text: 'Logout',
        icon: Icons.lock,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
      );

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFAD3436),
          minimumSize: Size.fromHeight(50),
        ),

        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );
}
