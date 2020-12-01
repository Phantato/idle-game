part of clicker;

class _ResourceTabel {
  final _resourceMap = <String, ValueNotifier<_BigInt>>{};

  ValueNotifier<_BigInt> _numberOf(String name) => _resourceMap[name];

  bool meet(_Requirement req) {
    Iterable<MapEntry<String, _BigInt>> reqList = req.toMap().entries;
    if (reqList
        .map((entry) => entry.value <= _resourceMap[entry.key].value)
        .reduce((curr, next) => curr && next)) {
      reqList.forEach((entry) {
        _decreaseBy(entry.key, entry.value);
      });
      return true;
    }
    return false;
  }

  void _increase(String name) => _increaseBy(name, _BigInt.one);

  void _increaseBy(String name, _BigInt value) {
    _resourceMap[name].value += value;
  }

  void _decreaseBy(String name, _BigInt value) {
    _resourceMap[name].value -= value;
  }

  _ResourceTabel() {
    Clicker.resourceList.forEach((name) {
      _resourceMap[name] = ValueNotifier<_BigInt>(_BigInt.zero);
    });
  }
  _ResourceTabel.fromJson(Map<String, String> json) {
    json?.forEach((name, value) {
      _resourceMap[name] = _resourceMap[name] ?? ValueNotifier(_BigInt.zero);
      _resourceMap[name].value = _BigInt.parse(json[name]);
    });
  }

  Map<String, dynamic> toJson() => _resourceMap
      .map((name, notifier) => MapEntry(name, notifier.value.toJson()));

  Future<bool> _save(LocalStorage storage) async {
    await storage.ready;
    print(toJson());
    storage.setItem('resource', this);
    return true;
  }

  static _ResourceTabel _load(LocalStorage storage) {
    // Future<bool> future = storage.ready;
    _ResourceTabel _resource;
    // future.then((_) {
    dynamic json = storage.getItem('resource')?.cast<String, String>();
    _resource =
        (json != null) ? _ResourceTabel.fromJson(json) : _ResourceTabel();
    // });
    return _resource;
  }
}
