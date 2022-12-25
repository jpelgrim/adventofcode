import 'point.dart';

typedef Matrix = List<Row>;
typedef Row = List<int>;

extension MatrixExtensions on Matrix {
  void prettyPrint() {
    for (int y = 0; y < length; y++) {
      print(this[y]
          .map((e) {
            if (e == 0) return '💥';
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

  Set<Point> increaseEnergy() {
    final flashed = Set<Point>();
    for (int y = 0; y < length; y++) {
      for (int x = 0; x < length; x++) {
        var energy = this[y][x];
        if (energy == 9) {
          flashed.add(Point(x, y));
          this[y][x] = 0;
        } else {
          this[y][x] = energy + 1;
        }
      }
    }
    return flashed;
  }

  Iterable<Point> flashNeighbours(Iterable<Point> flashed) {
    final newFlashes = Set<Point>();
    flashed.forEach((point) {
      if (flash(Point(point.x - 1, point.y - 1))) newFlashes.add(Point(point.x - 1, point.y - 1));
      if (flash(Point(point.x, point.y - 1))) newFlashes.add(Point(point.x, point.y - 1));
      if (flash(Point(point.x + 1, point.y - 1))) newFlashes.add(Point(point.x + 1, point.y - 1));
      if (flash(Point(point.x - 1, point.y))) newFlashes.add(Point(point.x - 1, point.y));
      if (flash(Point(point.x + 1, point.y))) newFlashes.add(Point(point.x + 1, point.y));
      if (flash(Point(point.x - 1, point.y + 1))) newFlashes.add(Point(point.x - 1, point.y + 1));
      if (flash(Point(point.x, point.y + 1))) newFlashes.add(Point(point.x, point.y + 1));
      if (flash(Point(point.x + 1, point.y + 1))) newFlashes.add(Point(point.x + 1, point.y + 1));
    });
    return newFlashes;
  }

  bool flash(Point point) {
    if (point.x < 0 || point.x > 9 || point.y < 0 || point.y > 9) {
      // This is a non-existing point in the matrix
      return false;
    }
    var energy = this[point.y][point.x];
    if (energy == 0) {
      // This point already flashed
      return false;
    }

    if (energy == 9) {
      this[point.y][point.x] = 0;
      return true;
    } else {
      this[point.y][point.x] = energy + 1;
    }
    return false;
  }

  bool allZeroes() => sum() == 0;

  int sum() => fold<int>(0, (sum, row) => sum + row.sum());
}

extension RowExtensions on Row {
  int sum() => fold<int>(0, (sum, element) => sum + element);
}