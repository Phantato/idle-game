part of clicker_ui;

class _WorkerList extends StatefulWidget {
  final name;
  _WorkerList({Key key, this.name}) : super(key: key);
  @override
  _WorkerListState createState() => _WorkerListState();
}

class _WorkerListState extends State<_WorkerList> {
  Widget _itemBuild(BuildContext context, int index) {
    return index == 0
        ? ListTile(
            // leading: Icon(Clicker.iconOf(widget.name)),
            // title: Row(
            //   crossAxisAlignment: CrossAxisAlignment.baseline,
            //   textBaseline: TextBaseline.alphabetic,
            //   children: <Widget>[
            //     Text('Handcraft'),
            //     Expanded(
            //       child: Row(),
            //     ),
            //     ValueListenableBuilder(
            //       builder: (context, value, child) {
            //         return Text('Current: $value');
            //       },
            //       valueListenable: Clicker.records.numberOf(widget.name),
            //     ),
            //   ],
            // ),
            // onTap: () => Clicker.records.increase(widget.name),
            )
        : ListTile(
            leading: Icon(Clicker.iconOf(widget.name)),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('Lazy worker'),
                Expanded(
                  child: Row(),
                ),
                ValueListenableBuilder(
                  builder: (context, value, child) => Text('Cost: $value'),
                  valueListenable:
                      Clicker.records.workerCostOfAt(widget.name, index - 1),
                ),
                VerticalDivider(),
                ValueListenableBuilder(
                  builder: (context, value, child) => Text('Current: $value'),
                  valueListenable:
                      Clicker.records.workerOfAt(widget.name, index - 1),
                ),
              ],
            ),
            onTap: () {
              if (Clicker.records.numberOf(widget.name).value <
                  Clicker.records.workerCostOfAt(widget.name, index - 1).value)
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Insufficient resource!'),
                ));
              else {
                Clicker.records.decreaseBy(
                    widget.name,
                    Clicker.records
                        .workerCostOfAt(widget.name, index - 1)
                        .value);
                Clicker.records.increaseWorkerOf(widget.name, index - 1);
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.separated(
          itemCount: Clicker.records.workerListOf(widget.name).length + 1,
          itemBuilder: _itemBuild,
          separatorBuilder: (c, i) => Divider(),
        ),
        ListTile(
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
        ),
      ],
    );
  }
}
