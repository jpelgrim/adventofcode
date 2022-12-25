class Point {
  Point(this.x, this.y);

  int x;
  int y;

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => 31 * x + y;
}
