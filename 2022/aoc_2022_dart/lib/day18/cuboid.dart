class Cuboid {
  Cuboid(this.x, this.y, this.z);

  int x;
  int y;
  int z;

  String toString() => 'Cuboid($x, $y, $z)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cuboid &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}