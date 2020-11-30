part of clicker;

class _Record {
  static final _record = _Record._internal();

  final _ResourceTabel _resource;
  final _WorkerTabel _worker;
  bool _justSaved = false;

  factory _Record() {
    return _record;
  }

  _Record._internal()
      : _resource = _ResourceTabel._load(_storage),
        _worker = _WorkerTabel._load(_storage) {
    _Increaser()._flush(_worker._workerListMap);
    // Increaser;
  }
  get _numberOf => _resource._numberOf;
  get _increase => _resource._increase;

  /// Increase the number of [name] by [value]
  get _increaseBy => _resource._increaseBy;

  /// Decrease the number of [name] by [value]
  // get _decreaseBy => _resource._decreaseBy;
  get _workerListLengthOf => _worker._lengthOf;
  get _workerOfAt => _worker._numberOfAt;
  get _requirementOfAt => _worker._requirementOfAt;
  get _efficientOfAt => _worker._efficientOfAt;
  bool _employWorkerOfAt(String name, int index) {
    if (_resource.meet(_requirementOfAt(name, index).value)) {
      _worker._increaseAtBy(name, index, _BigInt.one);
      _Increaser().regist(name, index, _BigInt.one);
      return true;
    } else
      return false;
  }

  get _increaseWorkerOfAtBy => noSuchMethod;

  Future<bool> _save() async {
    if (_justSaved) return false;

    await _storage.ready;

    _resource._save(_storage);
    _worker._save(_storage);

    _justSaved = true;
    Timer(Duration(seconds: 20), () {
      _justSaved = false;
    });
    return true;
  }

  static void _clear() async {
    await _storage.ready;
    _storage.clear();
    print('cleared!');
  }
}
