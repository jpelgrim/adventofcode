extension IntListExtensions on List<int> {
  int min() =>
      fold(0, (min, element) => (min == 0 || element < min) ? element : min);
  int max() =>
      fold(0, (min, element) => (min == 0 || element > min) ? element : min);
}


extension StringListExtensions on List<String> {
  List<String> copy() {
    final copy = <String>[];
    forEach((string) {
      copy.add(string);
    });
    return copy;
  }
}
