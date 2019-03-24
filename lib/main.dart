import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //for looking widgets like  native IOS
import 'package:flutter/foundation.dart';


final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.red,
);

const String defaultUserName = 'J';

void main()=> runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Chat Application',
      theme: defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: Chat(),
    );
  }
}

class Chat extends StatefulWidget{
  @override
  State createState() {
    // TODO: implement createState
    return _ChatWindow();
  }

}

class _ChatWindow extends State<Chat> with TickerProviderStateMixin{
  final List<Msg> _message = <Msg>[];
  final TextEditingController _textControler = new TextEditingController();
  bool _isWritting = false;
  @override
  Widget build(BuildContext ctx) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Application'),
        elevation:Theme.of(ctx).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              itemBuilder: (_, int index) => _message[index],
              itemCount: _message.length,
              reverse: true,
              padding: EdgeInsets.all(6.0),
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: BoxDecoration(color: Theme.of(ctx).cardColor), //accent color
          )
        ],
      ),
    );
  }

  Widget _buildComposer(){
    return new IconTheme(
        data: new IconThemeData(
            color:Theme.of(context).accentColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textControler,
                  onChanged: (String txt){
                    setState(() {
                      _isWritting = txt.length>0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Enter some text to send a message"),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                    child: Text("Submit"),
                    onPressed: _isWritting ? () => _submitMsg(_textControler.text)
                        : null
                )
                    : new IconButton(
                  icon: new Icon(Icons.message),
                  onPressed: _isWritting
                      ?() => _submitMsg(_textControler.text)
                      : null,
                ),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
              border:
              new Border(top: new BorderSide(color: Colors.brown)))
              :null,
        )
    );
  }

  void _submitMsg(String txt) {
    _textControler.clear();
    setState(() {
      _isWritting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this,
          duration: new Duration(milliseconds: 800)
      ),
    );
    setState(() {
      _message.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose(){
    for(Msg msg in _message){
      msg.animationController.dispose();
    }
    super.dispose();
  }


}

class Msg extends StatelessWidget{
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    // TODO: implement build
    return new SizeTransition(sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut
    ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: const CircleAvatar(
                  child:Text(defaultUserName)),
            ),
            new Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(defaultUserName, style: Theme.of(ctx).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: new Text(txt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
