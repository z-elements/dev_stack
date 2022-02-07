import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final SharedPreferences prefs;
  final String chatId;
  final String title;
  ChatPage({required this.prefs, required this.chatId,required this.title});
  @override
  ChatPageState createState() {
    return  ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  final db = FirebaseFirestore.instance;
  CollectionReference? chatReference;
  final TextEditingController _textController =
       TextEditingController();
      bool _isWritting = false;

  @override
  void initState() {
    super.initState();
    chatReference =
        db.collection("chats").doc(widget.chatId).collection('messages');
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      Expanded(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
             Text(documentSnapshot['sender_name'],
                style:  const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
             Container(
              margin: const EdgeInsets.only(top: 5.0),
              child:  Text(documentSnapshot['text']),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
        Expanded(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Text(documentSnapshot['sender_name'],
                style:  TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
             Container(
              margin:  EdgeInsets.only(top: 5.0),
              child:  Text(documentSnapshot['text']),
            ),
          ],
        ),
      ),
    ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data?.docs.map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child:  Row(
                children: doc['sender_id'] != widget.prefs.getString('uid')
                    ? generateReceiverLayout(doc)
                    : generateSenderLayout(doc),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child:  Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: chatReference?.orderBy('time',descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text("No Chat");
                return Expanded(
                  child:  ListView(
                    reverse: true,
                    children: generateMessages(snapshot),
                  ),
                );
              },
            ),
             Divider(height: 1.0),
             Container(
              decoration:  BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
             Builder(builder: (BuildContext context) {
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }

  IconButton getDefaultSendButton() {
    return  IconButton(
      icon:  Icon(Icons.send),
      onPressed: _isWritting
          ? () => _sendText(_textController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return  IconTheme(
        data:  IconThemeData(
          color: _isWritting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child:  Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child:  Row(
            children: <Widget>[
               Container(
                margin:  EdgeInsets.symmetric(horizontal: 4.0),
                child:  IconButton(
                    icon:  Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                    /*  var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      CollectionReference  storageReference = FirebaseFirestore
                          .instance
                          .ref()
                          .child('chats/img_' + timestamp.toString() + '.jpg');
                      StorageUploadTask uploadTask =
                          storageReference.putFile(image);
                      await uploadTask.onComplete;
                      String fileUrl = await storageReference.getDownloadURL();
                      _sendImage(messageText: null, imageUrl: fileUrl);*/
                    }),
              ),
               Flexible(
                child:  TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.length > 0;
                    });
                  },
                  onSubmitted: _sendText,
                  decoration:
                       InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference?.add({
      'text': text,
      'sender_id': widget.prefs.getString('uid'),
      'sender_name': widget.prefs.getString('name'),
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }

  void _sendImage({required String messageText, required String imageUrl}) {
    chatReference?.add({
      'text': messageText,
      'sender_id': widget.prefs.getString('uid'),
      'sender_name': widget.prefs.getString('name'),

      'time': FieldValue.serverTimestamp(),
    });
  }
}
