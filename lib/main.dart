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
  ClickerHomePage({Key key, this.title}) : super(key: key);
  @override
  _ClickerHomePageState createState() => _ClickerHomePageState();
}
int _counter = 0;

void _incrementCounter(State<ClickerHomePage> state) {
  state.setState(() {
    Clicker.records.increase('gold');
  });
}

class _ClickerHomePageState extends State<ClickerHomePage> {

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      _incrementCounter(this);
    });

  }



  // List<Widget> _buttonListWithout(name) {
  //   return Clicker.names.where((x) => x != name).expand(
  //     (x) => [
  //       widget._resourceButtonMap[x],
  //       SizedBox(height: 10),
  //     ],
  //   ).toList().cast<Widget>();
  // }


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
      floatingActionButton: ResourceColumn(),
    );
  }
}

class ResourceColumn extends StatefulWidget {
  var _resourceButtonMap = <String, Widget>{};
  String excludedName;
  ResourceColumn() : excludedName='';
  ResourceColumn.without(this.excludedName);
  @override
  _ResourceColumnState createState() => _ResourceColumnState();
}

class _ResourceColumnState extends State<ResourceColumn> {

  Widget _resourceBody(name) {
    Clicker.records.increase(name);
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, i) {
        if (i == 0) {
          return ListTile(
            leading: Icon(Clicker.iconOf(name)),
            title: Text('Handmade'),
            trailing: Text('${Clicker.records.numberOf(name)}'),
            onTap: () {
              setState(() => Clicker.records.increase(name)
              );
            }
          );
        }

        if (i.isOdd) {
          return Divider();
        }
        
        return ListTile(
          leading: Icon(Clicker.iconOf(name)),
          title: Text('Developing!'),
        );
      },
    );
  }

  Function _pushResourcePage(String name) {
    return () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: <Widget>[
                    Icon(Clicker.iconOf(name)),
                    Text(' $name'),
                  ],
                ),
              ),
              body: _resourceBody(name),
              floatingActionButton: ResourceColumn.without(name),
            );
          }
        ), ModalRoute.withName('/'),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    Clicker.names.where((x) => x != widget.excludedName).forEach((name) =>
      widget._resourceButtonMap[name] = FloatingActionButton.extended(
        heroTag: "btn${name}",
        tooltip: name,
        icon: Icon(Clicker.iconOf(name)),
        label: Text('${Clicker.records.numberOf(name)}'),
        onPressed: _pushResourcePage(name),
      )
    );

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: Clicker.names.where((x) => x != widget.excludedName).expand(
          (name) => [
            widget._resourceButtonMap[name],
            SizedBox(height: 10),
          ]).toList().cast<Widget>(),
    );
  }
}