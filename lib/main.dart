import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import "package:clicker/clicker.dart";
import 'package:clicker/clicker_ui.dart';
import 'icon/clicker_icons.dart' as ClickerIcon;
// import 'data/clicker_record.dart';

Timer _timer;
void main() async {
  await Clicker.storageReady;
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
    _timer = Timer.periodic(Duration(seconds: 1), _periodTask);
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

  void _periodTask(Timer timer) {
    Clicker.schedule();
    if (timer.tick % 30 == 0) Clicker.save();
    setState(() {
      ++_timeCounter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: MainDrawer(),
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
                  _timer = Timer.periodic(Duration(seconds: 1), _periodTask);
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

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Clicker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(ClickerIcon.Icons.save),
            title: Text('Save Progress'),
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              Future<bool> future = Clicker.save();
              future.then((isSaved) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      isSaved ? 'Progress Saved!' : 'You have just saved!'),
                ));
              });
            },
          ),
          // ListTile(
          //     leading: Icon(ClickerIcon.Icons.load),
          //     title: Text('Load Progress'),
          //     onTap: () {
          //       Navigator.of(context).pop();
          //       Clicker.load();
          //     }),
          ListTile(
            leading: Icon(ClickerIcon.Icons.bomb_explosion),
            title: Text('Clear Progress'),
            onTap: () async {
              Navigator.of(context).pop();
              Future<bool> future = showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Clear Warning!'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('This process will clear your saved progress'),
                          Text('but will not affect your current progress.'),
                          Text('Are you sure to clear your saved progress?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Confirm!'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
              future.then((isConfirmed) {
                if (isConfirmed) Clicker.clear();
              });
            },
          ),
          Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          // AboutListTile(
          //   child: Text('View Github'),
          // ),
        ],
      ),
    );
  }
}
