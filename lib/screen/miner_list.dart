part of clicker_ui;

class _MinerList extends StatefulWidget {
  final name;
  _MinerList({Key key, this.name}) : super(key: key);
  @override
  _MinerListState createState() => _MinerListState();
}

class _MinerListState extends State<_MinerList> {
  Widget _itemBuild(BuildContext context, int index) {
    return index == 0
        ? ListTile(
            leading: Icon(Clicker.iconOf(widget.name)),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('Handcraft'),
                Expanded(
                  child: Row(),
                ),
                ValueListenableBuilder(
                  builder: (context, value, child) {
                    return Text('Current: $value');
                  },
                  valueListenable: Clicker.records.numberOf(widget.name),
                ),
              ],
            ),
            onTap: () => Clicker.records.increase(widget.name),
          )
        : ListTile(
            leading: Icon(Clicker.iconOf(widget.name)),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('Basic miner'),
                Expanded(
                  child: Row(),
                ),
                ValueListenableBuilder(
                  builder: (context, value, child) => Text('Cost: $value'),
                  valueListenable:
                      Clicker.records.minerCostOfAt(widget.name, index - 1),
                ),
                VerticalDivider(),
                ValueListenableBuilder(
                  builder: (context, value, child) => Text('Current: $value'),
                  valueListenable:
                      Clicker.records.minerOfAt(widget.name, index - 1),
                ),
              ],
            ),
            onTap: () {
              if (Clicker.records.numberOf(widget.name).value <
                  Clicker.records.minerCostOfAt(widget.name, index - 1).value)
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Insufficient resource!'),
                ));
              else {
                Clicker.records.decreaseBy(
                    widget.name,
                    Clicker.records
                        .minerCostOfAt(widget.name, index - 1)
                        .value);
                Clicker.records.increaseMinerOf(widget.name, index - 1);
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: Clicker.records.minerListOf(widget.name).length + 1,
      itemBuilder: _itemBuild,
      separatorBuilder: (c, i) => Divider(),
    );
  }
}
