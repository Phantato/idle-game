part of clicker_ui;

class ResourceColumn extends StatefulWidget {
  final String excludedName;
  ResourceColumn() : excludedName='';
  ResourceColumn.without(this.excludedName);
  @override
  _ResourceColumnState createState() => _ResourceColumnState();
}

class _ResourceColumnState extends State<ResourceColumn> {
  var _resourceButtonMap = <String, Widget>{};

  Function _pushMinerList(String name) {
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
              body: _MinerList(name: name),
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
      _resourceButtonMap[name] = FloatingActionButton.extended(
        heroTag: "btn${name}",
        tooltip: name,
        icon: Icon(Clicker.iconOf(name)),
        label: ValueListenableBuilder(
          builder: (context, value, child) => Text('$value'),
          valueListenable: Clicker.records.numberOf(name),
        ),
        // Text('${Clicker.records.numberOf(name)}'),
        onPressed: _pushMinerList(name),
      )
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: Clicker.names.where((x) => x != widget.excludedName).expand(
        (name) => [
          _resourceButtonMap[name],
          SizedBox(height: 8),
        ]
      ).toList().cast<Widget>(),
    );
  }
}