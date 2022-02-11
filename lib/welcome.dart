import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loginappv2/style.dart';
import 'package:loginappv2/mymodel.dart';
class MyWelcomeWidget extends StatelessWidget {
  const MyWelcomeWidget({Key? key}) : super(key: key);
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
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
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
                      "email "+Provider.of<MyModel>(context, listen: false).emailControllerText)
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child:  Text(
                      "password "+Provider.of<MyModel>(context, listen: false).passwordControllerText)
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {},
                        child: Text('+'),
                      )
                  ),
                ),
              ),
            ],
          )),
    );
  }
}