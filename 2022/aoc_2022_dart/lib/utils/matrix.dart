typedef Matrix<T> = List<Row<T>>;
typedef Row<T> = List<T>;

extension IntMatrixExtensions on Matrix<int> {
  void prettyPrint() {
    for (int y = 0; y < length; y++) {
      print(this[y]
          .map((e) {
        if (e == 0) return '0️⃣';
        if (e == 1) return '1️⃣';
        if (e == 2) return '2️⃣';
        if (e == 3) return '3️⃣';
        if (e == 4) return '4️⃣';
        if (e == 5) return '5️⃣';
        if (e == 6) return '6️⃣';
        if (e == 7) return '7️⃣';
        if (e == 8) return '8️⃣';
        if (e == 9) return '9️⃣';
      })
          .toList()
          .join(''));
    }
    print('');
  }

  void simplePrint() {
    for (int y = 0; y < length; y++) {
      print(this[y].join(''));
    }
    print('');
  }

  String asString() {
    var result = '';
    for (int y = 0; y < length; y++) {
      result += '[${this[y].join(',')}]\n';
    }
    return result;
  }

  bool allZeroes() => sum() == 0;

  int sum() => fold<int>(0, (sum, row) => sum + row.sum());
}

extension MatrixExtensions on Matrix<bool> {

  void sPrint() {
    for (int y = 0; y < length; y++) {
      print(this[y].map((e) => e ? 't' : 'f').toList().join(''));
    }
    print('');
  }

  String sString() {
    var result = '';
    for (int y = 0; y < length; y++) {
      result += '[${this[y].join(',')}]\n';
    }
    return result;
  }

}

extension IntRowExtensions on Row<int> {
  int sum() => fold<int>(0, (sum, element) => sum + element);
}
