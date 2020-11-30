part of clicker;

class _WorkerTabel {
  final _workerListMap = <String, List<_Worker>>{};

  int _lengthOf(String name) => _workerListMap[name].length;

  ValueNotifier<_BigInt> _numberOfAt(String name, int index) =>
      _workerListMap[name][index]._number;
  ValueNotifier<_Requirement> _requirementOfAt(String name, int index) =>
      _workerListMap[name][index]._requirement;
  _BigInt _efficientOfAt(String name, int index) =>
      _workerListMap[name][index]._efficient;
  void _increaseAtBy(String name, int index, _BigInt n) =>
      _workerListMap[name][index].increaseBy(n);
  void _decreaseAtBy(String name, int index, _BigInt n) =>
      _workerListMap[name][index].decreaseBy(n);

  _WorkerTabel.fromJson(Map<String, dynamic> jsonmap) {
    // print(json);
    jsonmap.forEach((name, list) {
      if (list is String) list = json.decode(list);
      _workerListMap[name] = list
          .map((workerJson) => _Worker.fromJson(workerJson))
          .toList()
          .cast<_Worker>();
    });
  }
  Map<String, dynamic> toJson() =>
      _workerListMap.map((name, value) => MapEntry(name, json.encode(value)));

  Future<bool> _save(LocalStorage storage) async {
    await storage.ready;
    storage.setItem('worker', this);
    return true;
  }

  static _WorkerTabel _load(LocalStorage storage) {
    // Future<bool> future = storage.ready;
    _WorkerTabel _workerTabel;
    // future.then((_) {
    dynamic json = storage.getItem('worker');
    // print(json.runtimeType);
    // print(_);
    _workerTabel = _WorkerTabel.fromJson(json ?? _workerBasicMap);
    // print(_workerBasicMap);?
    // });

    return _workerTabel;
  }
}

class _Worker {
  final ValueNotifier<_BigInt> _number;
  final ValueNotifier<_Requirement> _requirement;
  final _BigInt _efficient;

  _Worker.fromJson(Map<String, Object> json)
      : _number = ValueNotifier(_BigInt.parse(json['number'] ?? '0')),
        _requirement = ValueNotifier(_Requirement.fromJson(json['cost'])),
        _efficient = _BigInt.parse(json['efficient']);
  Map<String, dynamic> toJson() => {
        'number': '${_number.value}',
        'cost': _requirement.value.toJson(),
        'efficient': '$_efficient',
      };

  void increaseBy(_BigInt n) {
    _number.value += n;
    // Todo: More Efficient Implementation
    while (_BigInt.zero <= (n -= _BigInt.one)) _requirement.value._forward();
    _requirement.notifyListeners();
  }

  void decreaseBy(_BigInt n) {
    assert(n <= _number.value, 'Negative Workers!');
    _number.value -= n;
    while (_BigInt.zero <= (n -= _BigInt.one)) _requirement.value._backward();
    _requirement.notifyListeners();
  }
}

class _Requirement {
  final _requirementMap = <String, _SingleRequirement>{};
  int get length => _requirementMap.entries.length;
  Map<String, _BigInt> toMap() =>
      _requirementMap.map((name, req) => MapEntry(name, req.value));

  _Requirement.fromJson(Map<String, dynamic> json) {
    json.forEach((name, field) {
      _requirementMap[name] = _SingleRequirement.fromJson(field);
    });
  }
  Map<String, dynamic> toJson() =>
      _requirementMap.map((name, value) => MapEntry(name, value.toJson()));

  void _forward() => _requirementMap.updateAll((name, value) => value.next());
  void _backward() => _requirementMap.updateAll((name, value) => value.prev());
}

class _SingleRequirement {
  final _BigInt value;
  final _BigInt numerator;
  final _BigInt denominator;

  _SingleRequirement(this.value, this.numerator, this.denominator);

  _SingleRequirement.fromJson(Map<String, dynamic> field)
      : value = _BigInt.parse(field['value']),
        numerator = _BigInt.parse(field['numerator']),
        denominator = _BigInt.parse(field['denominator']);

  Map<String, dynamic> toJson() => {
        'value': value.toJson(),
        'numerator': numerator.toJson(),
        'denominator': denominator.toJson(),
      };

  _SingleRequirement next() {
    return _SingleRequirement(
        value * numerator / denominator, numerator, denominator);
  }

  _SingleRequirement prev() => _SingleRequirement(
      value * denominator ~/ numerator, numerator, denominator);
}
