library clicker;

import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'icon/clicker_icons.dart';
part 'src/clicker_bigint.dart';
part 'src/clicker_const.dart';
part 'src/clicker_resource.dart';
part 'src/clicker_worker.dart';
part 'src/clicker_increaser.dart';
part 'src/clicker_record.dart';

class Clicker {
  static _Record _record = _Record();

  // storage:
  static get storageReady => _storage.ready;
  // names:
  static get resourceList => _nameIconMap.keys.toList();
  static get abaliableResourceList => _nameIconMap.keys.toList();

  // Resource operators:
  static get numberOf => _record._numberOf;
  static get increase => _record._increase;
  // Worker operator
  static get workerLengthOf => _record._workerListLengthOf;
  static get workerOfAt => _record._workerOfAt;
  static get costOfAt => _record._requirementOfAt;
  static get efficientOfAt => _record._efficientOfAt;
  static get employWorkerOfAt => _record._employWorkerOfAt;
  // static get increaseWorkerOfAtBy => _record._increaseWorkerOfAtBy;
  static get _increaser => _Increaser();
  static IconData iconOf(String name) => _nameIconMap[name];

  static void schedule() {
    _increaser.harvest();
  }

  static Future<bool> save() async => _record._save();
  static void clear() => _Record._clear();
}
