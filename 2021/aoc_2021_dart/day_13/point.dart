class Point {
  Point(this.x, this.y);

  int x;
  int y;

  Point.fromList(List<String> coordinates)
      : this(int.parse(coordinates[0]), int.parse(coordinates[1]));

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => 31 * x + y;
}
