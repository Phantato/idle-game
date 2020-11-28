library clicker;

import 'dart:math';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
part 'src/clicker_record.dart';
part 'src/clicker_bigint.dart';
part 'src/clicker_increaser.dart';
part 'icon/clicker_icons.dart';

class Clicker {
  static const _nameIconPair = {
    'apple': _Icons.apple,
    'gold': _Icons.gold_bar,
    'beer': _Icons.beer,
  };

  static get names => _nameIconPair.keys.toList();
  static get records => _Records();
  static get _increaser => _Increaser();
  static IconData iconOf(String name) => _nameIconPair[name];

  static void schedule() {
    _increaser.harvest();
  }

  static void save() => _Records().save();
  static void load() => _Records().load();
  static void clear() => _Records().clear();
}
