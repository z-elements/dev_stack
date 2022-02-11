import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginappv2/mymodel.dart';
import 'package:loginappv2/welcome.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(  ChangeNotifierProvider(
    create: (context) => MyModel(),
    child: const MyApp(),
  ),);
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form LoginV2';
    return const MaterialApp(
      //  title: appTitle,
      home: Scaffold(
        body: MyBaseWidget(),
      ),
    );
  }
}



class MyBaseWidget extends StatelessWidget {
  const MyBaseWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text("Email"),
                  TextField(
                    controller: Provider.of<MyModel>(context).emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text("Password"),
                  TextField(
                    controller: Provider.of<MyModel>(context).passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: Provider.of<MyModel>(context).error,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () async {
                  final bool  auth=   await Provider.of<MyModel>(context, listen: false).signInWithEmailAndPassword();
                  if (auth) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyWelcomeWidget()));
                  }
                },
              ),
            ),

          ],
        )
    );
  }
}


