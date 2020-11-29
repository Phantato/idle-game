part of clicker_ui;

class _WorkerList extends StatefulWidget {
  final name;
  _WorkerList({Key key, this.name}) : super(key: key);
  @override
  _WorkerListState createState() => _WorkerListState();
}

class _WorkerListState extends State<_WorkerList> {
  bool _snackBarAppeared = false;
  Widget _itemBuild(BuildContext context, int index) {
    return index == 0
        ? ListTile()
        : ListTile(
            leading: Icon(Clicker.iconOf(widget.name)),
            title: Row(
              // crossAxisAlignment: CrossAxisAlignment.baseline,
              // textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('Lazy worker'),
                Expanded(
                  child: Row(),
                ),
                Column(
                  children: <Widget>[
                    ValueListenableBuilder(
                      builder: (context, value, child) => Text('Cost: $value'),
                      valueListenable: Clicker.records
                          .workerCostOfAt(widget.name, index - 1),
                    ),
                    Text('+1/s'),
                  ],
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
                  Clicker.records
                      .workerCostOfAt(widget.name, index - 1)
                      .value) {
                if (!_snackBarAppeared) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Insufficient resource!'),
                  ));
                  _snackBarAppeared = true;
                  Timer(Duration(seconds: 3), () {
                    _snackBarAppeared = false;
                  });
                }
              } else {
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
          separatorBuilder: (c, i) => Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
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
              Text('+1/Tap'),
              // VerticalDivider(
              //   thickness: 0,
              // ),
              SizedBox(
                width: 16,
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
