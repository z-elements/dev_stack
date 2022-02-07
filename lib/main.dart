import 'package:flutter/material.dart';
import 'package:simplechat/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((prefs) {
    runApp(LandingPage(prefs));
  });
}

class LandingPage extends StatefulWidget {
  final SharedPreferences prefs;
  LandingPage(this.prefs);
  @override
  State<LandingPage> createState() => _LandingPage(prefs);
}

class _LandingPage extends State<LandingPage> {
  final SharedPreferences prefs;
 _LandingPage(this.prefs);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MainPage(),
    );
  }
       _MainPage()
       {
        prefs.setString('uid',"user2");
        prefs.setString('name', "user2");
        return HomePage(prefs: prefs);
      }

}
