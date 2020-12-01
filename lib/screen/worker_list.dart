part of clicker_ui;

class _WorkerList extends StatefulWidget {
  final name;
  _WorkerList({Key key, this.name}) : super(key: key);
  @override
  _WorkerListState createState() => _WorkerListState();
}

class _WorkerListState extends State<_WorkerList> {
  bool _snackBarAppeared = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _handRowBuild(context),
      Divider(thickness: 1, indent: 20, endIndent: 20),
      Expanded(
        child: ListView.builder(
          itemCount: Clicker.workerLengthOf(widget.name),
          itemBuilder: _itemBuild,
        ),
      ),
    ]);
  }

  Widget _handRowBuild(BuildContext context) {
    return ListTile(
      leading: Icon(Clicker.iconOf(widget.name)),
      title: Row(
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
          Expanded(child: Row()),
          ValueListenableBuilder(
            builder: (context, value, child) {
              return Text('Current: $value');
            },
            valueListenable: Clicker.numberOf(widget.name),
          ),
        ],
      ),
      onTap: () => Clicker.increase(widget.name),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    return ExpansionTile(
        leading: Icon(Clicker.iconOf(widget.name)),
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Worker Level $index'),
                Text(
                  '+${Clicker.efficientOfAt(widget.name, index)}/s',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            VerticalDivider(),
            Expanded(child: Row()),
            ValueListenableBuilder(
              builder: (context, value, child) => Text('Current: $value'),
              valueListenable: Clicker.workerOfAt(widget.name, index),
            ),
          ],
        ),
        children: _requirementRow(context, index));
  }

  List<Widget> _requirementRow(BuildContext context, index) {
    return <Widget>[
      ListTile(
        title: Row(
          children: <Widget>[
            Text('Employment costs:'),
            VerticalDivider(),
            ValueListenableBuilder(
              builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: value
                      .toMap()
                      .entries
                      .map((entry) => Column(children: <Widget>[
                            Icon(Clicker.iconOf(entry.key)),
                            Text('${entry.value}'),
                          ]))
                      .toList()
                      .cast<Widget>()),
              valueListenable: Clicker.costOfAt(widget.name, index),
            ),
          ],
        ),
        onTap: () {
          if (!Clicker.employWorkerOfAt(widget.name, index) &&
              !_snackBarAppeared) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Insufficient resource!')));
            _snackBarAppeared = true;
            Timer(Duration(seconds: 3), () {
              _snackBarAppeared = false;
            });
          }
        },
      )
    ];
  }
}
