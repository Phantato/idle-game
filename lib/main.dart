import 'dart:async';
import 'package:flutter/material.dart';
import "package:clicker/clicker.dart";
import 'package:clicker/clicker_ui.dart';
// import 'icon/clicker_icons.dart';
// import 'data/clicker_record.dart';

Timer _timer;
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

class _ClickerHomePageState extends State<ClickerHomePage>
    with SingleTickerProviderStateMixin {
  int _timeCounter;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _timeCounter = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _incrementCounter();
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();

    if (_timer.isActive) _timer.cancel();
    _animationController.dispose();
  }

  void _incrementCounter() {
    setState(() {
      Clicker.schedule();
      ++_timeCounter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(child: Center(child: Text('This is a drawer!'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Time have passed:'),
            Text(
              '$_timeCounter s',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animationController,
              ),
              onPressed: () {
                _timer.isActive
                    ? _animationController.forward()
                    : _animationController.reverse();
                if (_timer.isActive) {
                  _timer.cancel();
                } else {
                  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                    _incrementCounter();
                  });
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: ResourceColumn(),
    );
  }
}
