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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Worker Level $index'),
                    Text(
                      '+${Clicker.efficientOfAt(widget.name, index - 1)}/s',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                VerticalDivider(),
                Text('Employment costs:'),
                VerticalDivider(),
                ValueListenableBuilder(
                  builder: (context, value, child) =>
                      // Expanded(child:
                      // child: Center(
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: value
                        .toMap()
                        .entries
                        .map((entry) => Column(
                              children: <Widget>[
                                Icon(Clicker.iconOf(entry.key)),
                                Text('${entry.value}'),
                              ],
                            ))
                        .toList()
                        .cast<Widget>(),
                    // ),
                  ),
                  // Text('${value.toMap().entries}'),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   // physics: ScrollPhysics(),
                  //   itemCount: value.length,
                  //   scrollDirection: Axis.horizontal,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(title: Text('1'));
                  //   },
                  // ),
                  valueListenable: Clicker.costOfAt(widget.name, index - 1),
                ),
                Expanded(child: Row()),
                ValueListenableBuilder(
                  builder: (context, value, child) => Text('Current: $value'),
                  valueListenable: Clicker.workerOfAt(widget.name, index - 1),
                ),
              ],
            ),
            onTap: () {
              if (!Clicker.employWorkerOfAt(widget.name, index - 1) &&
                  !_snackBarAppeared) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Insufficient resource!'),
                ));
                _snackBarAppeared = true;
                Timer(Duration(seconds: 3), () {
                  _snackBarAppeared = false;
                });
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.separated(
          itemCount: Clicker.workerLengthOf(widget.name) + 1,
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
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Handcraft'),
                  Text(
                    '+1/Tap',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              Expanded(
                child: Row(),
              ),
              SizedBox(
                width: 16,
              ),
              ValueListenableBuilder(
                builder: (context, value, child) {
                  return Text('Current: $value');
                },
                valueListenable: Clicker.numberOf(widget.name),
              ),
            ],
          ),
          onTap: () => Clicker.increase(widget.name),
        ),
      ],
    );
  }
}
