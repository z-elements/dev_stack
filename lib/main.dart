import 'dart:ffi';

import 'package:flutter/material.dart';

//void main() => runApp(const MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue[300],
  minimumSize: Size(50, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);
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


class MyStore{
  String login="";
  String name="";
  String surname="";
  String phone="";
  bool state=false;
  MyStore(this.login,this.name, this.surname, this.phone,[this.state=false]);
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class MyWelcomeWidget extends StatefulWidget {
  final Map<String, MyStore> _users;
  String? keysel;
  MyWelcomeWidget( this._users,[this.keysel]) ;
  @override
  State<MyWelcomeWidget> createState() => _MyWelcomeWidgetState(_users,keysel);
}

class _MyWelcomeWidgetState extends State<MyWelcomeWidget>
{
   final Map<String, MyStore> _users;
   final TextEditingController mlogin= TextEditingController();
   final TextEditingController mname=TextEditingController();
   final TextEditingController msurname=TextEditingController();
   final TextEditingController mphone=TextEditingController();
   String? keysel;
   _MyWelcomeWidgetState(this._users,  [this.keysel]);

   @override
   void initState() {
     if (keysel!.isEmpty==false){
       mlogin.text=_users[keysel]!.login;
       mname.text=_users[keysel]!.name;
       msurname.text=_users[keysel]!.surname;
       mphone.text=_users[keysel]!.phone;
     }
     //assert(_debugLifecycleState == _StateLifecycle.created);
   }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child:
                    TextField(
                        controller: mlogin,
                        //obscureText:true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:  'Username',
                        ),
                      ),
              ),
             Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:
                 TextField(
                  controller: msurname,
                 // obscureText:true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                   // labelText: 'Surname',
                    labelText:  'Surname',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:
                TextField(
                  controller: mname,
                  //obscureText:true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:'Name',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:
                 TextField(
                  controller: mphone,
                 // obscureText:true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                   // labelText: 'Phone',
                    labelText: 'Phone',
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child:
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>
                          [
                            ElevatedButton(
                              style: raisedButtonStyle,
                              onPressed: () {
                                        setState(() {
                                          _users[mlogin.text] = MyStore(mlogin.text, mname.text, msurname.text, mphone.text);
                                            if ( keysel!.isEmpty==false)Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst); else Navigator.pop(context,_users);
                                        },);
                                                                    //

                              },
                              child: Text('Save'),
                            ),
                            ElevatedButton(
                              style: raisedButtonStyle,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            )
                          ]
                      )
                  ),
                ),
              ),
            ],
      ),
      ),

    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController error = TextEditingController();
  MyStore? storeValues;
   Map<String, MyStore> _users= Map();

  void _showScreen(BuildContext context,String keysel) async {

  await Navigator.push(
     context,
      MaterialPageRoute(builder: (context) =>
          MyWelcomeWidget(_users,keysel)),
    ).then((val){
      setState(() => _users=val);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    error.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: <Widget>[

             Expanded(child:
                    Padding(
                      child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: ListView.builder(
                            itemCount: _users.length,
                          //  itemExtent: 50.0,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index){
                              String key = _users.keys.elementAt(index);
                              return Padding(
                              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child:GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          _users[key]!.state=!_users[key]!.state;
                                        });
                                      },
                                      onTap:  () => showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false, // user must tap button!
                                                    builder: (BuildContext context) {
                                                      return  AlertDialog(
                                                        title: const Text('User Card'),
                                                        content: SingleChildScrollView(
                                                          child: ListBody(
                                                            children:  <Widget>
                                                            [
                                                              Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.all(10),
                                                                child:
                                                                Text(
                                                                  _users[key]!.login,
                                                                ) ,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.all(10),
                                                                child:
                                                                Text(
                                                                  _users[key]!.surname,
                                                                ) ,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.all(10),
                                                                child:
                                                                Text(
                                                                  _users[key]!.name,
                                                                ) ,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.all(10),
                                                                child:
                                                                Text(
                                                                  _users[key]!.phone,
                                                                ) ,
                                                              ),
                                                              ElevatedButton(
                                                                style: raisedButtonStyle,
                                                                onPressed: () {
                                                                  _showScreen(context,_users[key]!.login);
                                                                },
                                                                child: Text('Edit'),
                                                              )
                                                           ],
                                                          ),
                                                        ),
                                                      );
                                                    },

                                                  ),

                                      child: Material(
                                            elevation: 4.0,
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: _users[key]!.state== true ? Colors.green : Colors.blue,
                                            child:Container(
                                              height: 70,
                                              padding: const EdgeInsets.all(8),
                                                 child: Center(
                                                                  child: Text(
                                                                  "${key}",
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                          ),
                                            ),
                                      ),
                              )
                              );
                            },
                          )
                      ),
                      padding: const EdgeInsets.all(10),
                    )
             ),

            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>
                        [
                          ElevatedButton(
                            style: raisedButtonStyle,
                            onPressed: () {
                                     setState(()
                                            {
                                                      for(var v in _users.values)
                                                   {
                                                          if (v.state==true)  _users.remove(v.login);
                                                   }
                                            },
                                     );
                            },
                            child: Text('Delete'),
                          ),
                          ElevatedButton(
                            style: raisedButtonStyle,
                            onPressed: () {
                              _showScreen(context,"");
                            },
                            child: Text('Add'),
                          )
                        ]
                      )
                ),
              ),
            ),
          ],
        )
    );
  }
}