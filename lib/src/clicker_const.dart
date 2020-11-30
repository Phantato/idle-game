part of clicker;

final LocalStorage _storage = LocalStorage('Clicker.json');

const _nameIconMap = {
  'apple': Icons.apple,
  'beer': Icons.beer,
  'gold': Icons.gold_bar,
};

const _workerBasicMap = {
  'apple': [
    {
      'efficient': '10',
      'cost': {
        'apple': {'value': '5', 'numerator': '11', 'denominator': '10'},
      },
    },
    {
      'efficient': '100',
      'cost': {
        'apple': {'value': '50', 'numerator': '12', 'denominator': '10'},
        'beer': {'value': '5', 'numerator': '11', 'denominator': '10'},
      },
    }
  ],
  'beer': [
    {
      'efficient': '10',
      'cost': {
        'apple': {'value': '50', 'numerator': '12', 'denominator': '10'},
        'beer': {'value': '10', 'numerator': '11', 'denominator': '10'},
      }
    },
  ],
  'gold': [
    {
      'efficient': '1',
      'cost': {
        'beer': {'value': '100', 'numerator': '15', 'denominator': '10'},
      }
    },
  ],
};
