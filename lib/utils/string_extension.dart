extension StringExtension on String {

  /// Capitalize the first letter of each word in the string.
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  /// Parse a string to an integer.
  int parseInt() {
    return int.parse(this);
  }

}