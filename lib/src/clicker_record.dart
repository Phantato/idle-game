part of clicker;

class _Records {
  static final _record = _Records._internal();

  final _resourceTabel = <String, ValueNotifier<_BigInt>>{};
  final _workerListTabel = <String, List<ValueNotifier<_BigInt>>>{};
  final _workerCostListTabel = <String, List<ValueNotifier<_BigInt>>>{};
  final LocalStorage _localStorage = LocalStorage('Clicker.json');
  bool _justSaved = false;

  factory _Records() {
    return _record;
  }

  _Records._internal() {
    Clicker.names.forEach((name) {
      _resourceTabel[name] = ValueNotifier<_BigInt>(_BigInt.zero);
      _workerListTabel[name] = <ValueNotifier<_BigInt>>[];
      _workerListTabel[name].add(ValueNotifier(_BigInt.zero));
      _workerCostListTabel[name] = <ValueNotifier<_BigInt>>[];
      _workerCostListTabel[name].add(ValueNotifier(_BigInt.from(10)));
    });
  }

  ValueNotifier<_BigInt> numberOf(String name) => _resourceTabel[name];
  ValueNotifier<_BigInt> workerOfAt(String name, int index) =>
      _workerListTabel[name][index];
  ValueNotifier<_BigInt> workerCostOfAt(String name, int index) =>
      _workerCostListTabel[name][index];
  List<ValueNotifier<_BigInt>> workerListOf(String name) =>
      _workerListTabel[name];

  Future<bool> save() async {
    await _localStorage.ready;
    if (_justSaved) return false;
    // print(_resourceTabel.map((key, value) => MapEntry(key, value.value)));
    _localStorage.setItem('resource',
        _resourceTabel.map((key, value) => MapEntry(key, value.value)));
    _localStorage.setItem(
        'worker',
        _workerListTabel.map(
            (key, list) => MapEntry(key, list.map((e) => e.value).toList())));
    _justSaved = true;
    Timer(Duration(seconds: 20), () {
      _justSaved = false;
    });
    return true;
  }

  void load() async {
    await _localStorage.ready;
    _localStorage.getItem('resource')?.forEach((name, value) {
      _resourceTabel[name].value = _BigInt.parse(value['data']);
    });
    _localStorage.getItem('worker')?.forEach((name, list) {
      list.asMap().forEach((index, value) {
        value = _BigInt.parse(value['data']);
        if (index < _workerListTabel[name].length) {
          _workerListTabel[name][index].value = value;
          _workerCostListTabel[name][index].value =
              (value + _BigInt.one) * _BigInt.from(10);
        } else {
          _workerListTabel[name].add(ValueNotifier(value));
          _workerListTabel[name]
              .add(ValueNotifier((value + _BigInt.one) * _BigInt.from(10)));
        }
      });
    });
    Clicker._increaser.clear();
    _workerListTabel.forEach((name, list) {
      list.asMap().forEach((index, value) {
        Clicker._increaser.regist(name, index, value.value);
      });
    });
  }

  void clear() async {
    await _localStorage.ready;
    _localStorage.clear();
    // print('cleared!');
  }

  void increase(String name) {
    increaseBy(name, _BigInt.one);
  }

  void increaseBy(String name, _BigInt value) {
    _resourceTabel[name].value += value;
  }

  void decreaseBy(String name, _BigInt value) {
    _resourceTabel[name].value -= value;
  }

  void increaseWorkerOf(String name, int index) {
    _increaseWorkerOfBy(name, index, _BigInt.one);
  }

  void _increaseWorkerOfBy(String name, int index, _BigInt value) {
    _workerListTabel[name][index].value += value;
    _workerCostListTabel[name][index].value += value * _BigInt.from(10);
    Clicker._increaser.regist(name, index, value);
  }
}
