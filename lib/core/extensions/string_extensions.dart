extension StringExtensions on String {
  String get obscureEmail => replaceRange(
        1,
        indexOf('@'),
        '****',
      );

  String capitalizeFirstLetter() => isEmpty
      ? ''
      : '${this[0].toUpperCase()}'
          '${substring(1)}';

  String capitalizeEveryWord(String splitPattern) => split(splitPattern)
      .map(
        (word) => word.capitalizeFirstLetter(),
      )
      .join(splitPattern);

  String lowerCaseFirstLetter() => isEmpty
      ? ''
      : '${this[0].toLowerCase()}'
          '${substring(1)}';

  String lowerCaseEveryWord(String splitPattern) => isEmpty
      ? ''
      : split(splitPattern)
          .map(
            (word) => word.lowerCaseFirstLetter(),
          )
          .join(splitPattern);

  String camelCase() => isEmpty
      ? ''
      : toLowerCase()
          .capitalizeEveryWord(
            ' ',
          )
          .lowerCaseFirstLetter()
          .replaceAll(' ', '');

  String snakeCase() => isEmpty ? '' : toLowerCase().replaceAll(' ', '_');
}
