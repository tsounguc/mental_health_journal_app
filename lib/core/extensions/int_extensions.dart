extension IntExt on int {
  String get estimate {
    if (this <= 10) return '$this';
    var data = this - (this % 10);
    if (data == this) data = this - 5;
    return 'over $data';
  }

  String get pluralize {
    return this > 1 ? 's' : '';
  }

  String get isLessThan {
    if (this <= 1) return '<1';
    return '$this';
  }
}
