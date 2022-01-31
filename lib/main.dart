import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

//void main() => runApp(const MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
    //  title: appTitle,
      home: Scaffold(
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
const MyStatefulWidget({Key? key}) : super(key: key);

@override
State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class MyWelcomeWidget extends StatefulWidget {

  final TextEditingController nameController;
  final TextEditingController passwordController;
  MyWelcomeWidget( this.nameController,this.passwordController) ;

  @override
  State<MyWelcomeWidget> createState() => _MyWelcomeWidgetState(nameController,passwordController);
}

class _MyWelcomeWidgetState extends State<MyWelcomeWidget>
{
  TextEditingController emailController;
  TextEditingController passwordController;
  _MyWelcomeWidgetState(this.emailController, this.passwordController);
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Route'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);

            },
            child: const Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Welcome',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child:  Text(
                      "email "+emailController.text )
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child:  Text(
                      "password "+passwordController.text )
              ),
            ],
          )),
    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController error = TextEditingController();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.blue[300],
    minimumSize: Size(50, 50),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  void signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('user find');
      if ( userCredential.user!= null) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                MyWelcomeWidget(
                    emailController,
                    passwordController)),
          );
        });
      }
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(()
        {
          error.text="user-not-found";
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        setState(()
        {
          error.text="Wrong password";
        });
      }
    }
  }

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    error.dispose();
    super.dispose();
  }
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
                      const  Text("Email"),
                      TextField(
                      controller: emailController,
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
                  const  Text("Password"),
                  TextField(
                    controller: passwordController,
                    obscureText:true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: 'Email',
                    ),
                  ),
                TextField(
                  controller: error,
                  decoration:const InputDecoration(
                    border: InputBorder.none,
                    //hintText: 'Username',
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
                          onPressed: ()
                          {
                              if (isEmail(emailController.text)) {
                                 signInWithEmailAndPassword();
                              } else
                                {
                                  error.text="Wrong email";
                                }
                          },
                      ),
                ),

            Expanded(
              child:  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0,10,10),
                    child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () { },
                      child: Text('+'),
                    )
                  ),
               ),
            ),

          ],
        )
    );
  }
}