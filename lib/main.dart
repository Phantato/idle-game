import 'dart:async';
import 'package:flutter/material.dart';
import "package:clicker/clicker.dart";

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
  var _resourceButtonMap = <String, Widget>{};

  ClickerHomePage({Key key, this.title}) : super(key: key);

  @override
  _ClickerHomePageState createState() => _ClickerHomePageState();
}

class _ClickerHomePageState extends State<ClickerHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    
    Clicker.names.forEach((name) =>
      widget._resourceButtonMap[name] = FloatingActionButton.extended(
        heroTag: "btn${name}",
        tooltip: name,
        icon: Icon(Clicker.icon(name)),
        label: Text('${Clicker.records.resource(name)}'),
        onPressed: _pushResource(name),
      )
    );

    Timer.periodic(Duration(seconds: 1), (timer) {
      _incrementCounter();
    });

  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _resourceBody(name) {
    return Center(
      child:Text('${name}:${Clicker.records.resource(name)}')
    );
  }

  List<Widget> _buttonListWithout(name) {
    return Clicker.names.where((x) => x != name).expand(
      (x) => [
        widget._resourceButtonMap[x],
        SizedBox(height: 10),
      ],
    ).toList().cast<Widget>();
  }

  Function _pushResource(name) {
    return () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: <Widget>[
                    Icon(Clicker.icon(name)),
                    Text(' $name'),
                  ],
                ),
              ),
              body: _resourceBody(name),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buttonListWithout(name),
              ),
            );
          }
        ), ModalRoute.withName('/'),
      );
    };
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
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: Clicker.names.expand(
          (name) => [
            widget._resourceButtonMap[name],
            SizedBox(height: 10),
          ]).toList().cast<Widget>(),
      ),
    );
  }
}
