part of clicker_ui;

class _MinerList extends StatefulWidget {
  final name;
  _MinerList({Key key, this.name}) : super(key : key);
  @override
  _MinerListState createState() => _MinerListState();
}

class _MinerListState extends State<_MinerList> {

  Widget _itemBuild(BuildContext context, int i) {
    return i == 0 ? ListTile(
      leading: Icon(Clicker.iconOf(widget.name)),
      title: Text('Handmade'),
      trailing:  ValueListenableBuilder(
          builder: (context, value, child) {
            return Text('Current: $value');
          },
          valueListenable: Clicker.records.numberOf(widget.name),
        ),
      onTap: () => Clicker.records.increase(widget.name)
    ) : ListTile(
      leading: Icon(Clicker.iconOf(widget.name)),
      title: Text('Developing!'),
      onTap: () => {},
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: _itemBuild,
      separatorBuilder: (c, i) => Divider(),
    );
  }
}

