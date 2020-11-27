import 'dart:async';
import 'package:flutter/material.dart';
import "package:clicker/clicker.dart";
import 'package:clicker/clicker_ui.dart';
// import 'icon/clicker_icons.dart';
// import 'data/clicker_record.dart';


void main() {
  runApp(ClickerApp());
}

class ClickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClickerHomePage(title: 'Clicker Home Page'),
    );
  }
}

class ClickerHomePage extends StatefulWidget {
  final String title;
  ClickerHomePage({Key key, this.title}) : super(key: key);
  @override
  _ClickerHomePageState createState() => _ClickerHomePageState();
}
int _counter = 0;


class _ClickerHomePageState extends State<ClickerHomePage> {

  int _timeCounter;
  @override
  void initState() {
    super.initState();

    _timeCounter = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      _incrementCounter();
    });

  }
  
  void _incrementCounter() {
    setState(() {
      Clicker.records.increase('gold');
      Clicker.records.increase('beer');
      Clicker.records.increase('beer');
      Clicker.records.increase('apple');
      Clicker.records.increase('apple');
      Clicker.records.increase('apple');
      ++_timeCounter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),  
      drawer: Drawer(
        child: Center(child: Text('This is a drawer!'))
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Time have passed:',
            ),
            Text(
              '$_timeCounter s',
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
      ),
      floatingActionButton: ResourceColumn(),
    );
  }
}
