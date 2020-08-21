import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        channel: new IOWebSocketChannel.connect("ws://echo.websocket.org"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({@required this.channel});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController gondermesaj = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Socket"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                  child: TextFormField(
                controller: gondermesaj,
                decoration: InputDecoration(labelText: "Mesaj Gönder:"),
              )),
              RaisedButton(
                onPressed: mesajgonder,
                child: Row(
                  children: [Icon(Icons.send)],
                ),
              ),
              StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(snapshot.hasData
                          ? '${snapshot.data}'
                          : "Mesaj Yok !"));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void mesajgonder() {
    if (gondermesaj.text.isNotEmpty) {
      widget.channel.sink.add(gondermesaj.text);
    } else if (gondermesaj.text.isEmpty) {
      widget.channel.sink.close();
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
