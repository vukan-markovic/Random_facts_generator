import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random fact generator',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Montserrat',
        primaryColorBrightness: Brightness.light,
        textSelectionColor: Colors.red,
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 32.0,
              fontStyle: FontStyle.italic,
              color: Colors.deepOrange,
              letterSpacing: 0.5),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future fact = fetchFact();

  void _generateFact() {
    setState(() {
      fact = fetchFact();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random fact generator',
            style: Theme.of(context).primaryTextTheme.title),
        elevation: 4.0,
        leading: IconButton(
          icon: ImageIcon(AssetImage('graphics/icon.png')),
          tooltip: 'Random fact generator',
          onPressed: null,
        ),
      ),
      body: Center(
        child: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              image: DecorationImage(
                image: AssetImage('graphics/background.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: fact,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      snapshot.data.toString().substring(
                          2, snapshot.data.toString().indexOf('Source:')),
                      style: Theme.of(context).textTheme.title,
                    );
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.deepOrange),
        child: FloatingActionButton(
          onPressed: _generateFact,
          tooltip: 'Generate fact',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}

Future fetchFact() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await http
        .get('http://randomuselessfact.appspot.com/random.txt?language=en');
    if (response.statusCode == 200)
      return response.body.toString();
    else
      return "Error on sending request!";
  } else
    return "You must be connected to internet to get facts!";
}
