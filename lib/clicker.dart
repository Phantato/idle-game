library clicker;

import 'package:flutter/widgets.dart';
part 'src/clicker_record.dart';
part 'src/clicker_bigint.dart';
part 'icon/clicker_icons.dart';

class Clicker {
  static const _nameIconPair = {
    'apple': _Icons.apple,
    'gold': _Icons.gold_bar,
    'beer': _Icons.beer,
  };
  static IconData iconOf(String name) => _nameIconPair[name];
  static get names => _nameIconPair.keys.toList();
  static get records => _Records();
}
