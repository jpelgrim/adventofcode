import 'dart:math';

enum State {
  on,
  off,
}

class BootStep {
  BootStep(this.action, this.cuboid);

  factory BootStep.fromString(String s) {
    List<String> actionCuboid = s.split(' ');
    return BootStep(
      State.values.byName(actionCuboid[0]),
      Cuboid.fromString(actionCuboid[1]),
    );
  }

  final State action;
  final Cuboid cuboid;

  bool intersects(Cuboid other) => cuboid.intersects(other);
}

class Cuboid {
  Cuboid(this.from, this.to);

  factory Cuboid.fromString(String line) {
    List<String> parts = line.split(',');
    List<int> x = parts[0].substring(2).split('..').map(int.parse).toList();
    List<int> y = parts[1].substring(2).split('..').map(int.parse).toList();
    List<int> z = parts[2].substring(2).split('..').map(int.parse).toList();
    return Cuboid(Point(x[0], y[0], z[0]), Point(x[1], y[1], z[1]));
  }

  bool valid() => from.x <= to.x && from.y <= to.y && from.z <= to.z;

  static final INVALID = Cuboid(Point(-1, -1, -1), Point(1, 1, 1));

  // -5......2
  //    -2......5
  //
  //    -2..1
  //        1...5
  //
  //      0..2
  //    -2......5
  //
  //      0........7
  //    -2......5
  bool intersects(Cuboid other) =>
      to.x >= other.from.x &&
      from.x <= other.to.x &&
      to.y >= other.from.y &&
      from.y <= other.to.y &&
      to.z >= other.from.z &&
      from.z <= other.to.z;

  final Point from;
  final Point to;

  contains(Point point) =>
      point.x >= from.x &&
      point.x <= to.x &&
      point.y >= from.y &&
      point.y <= to.y &&
      point.z >= from.z &&
      point.z <= to.z;

  int size() => (to.x >= from.x && to.y >= from.y && to.z >= from.z)
      ? (to.x - from.x + 1) * (to.y - from.y + 1) * (to.z - from.z + 1)
      : 0;

  List<Cuboid> operator -(Cuboid o) {
    if (!intersects(o)) return [this];
    final result = <Cuboid>[];
    // For example on one axis, the x-axis:
    // this  -5......2
    // other    -2......5
    //
    // We want this to only keep the residue on the left
    // if (from.x < o.from.x)
    // add (from.x, o.from.x -1) [this is (-5,-3)]
    //
    // if (to.x > o.to.x) 2>5 is not true, so no residue on the right
    //
    // Another example
    // this  -5.............7
    // other    -2......5
    //
    // (from.x < o.from.x) -5<-2 is still true, so that gives -5.-3 again
    // if (to.x > o.to.x) 7>5 is true in this case
    // then also add (o.to.x + 1, to.x)
    //
    // Last overlapping case
    //
    // this          3......7
    // other    -2......5
    // (from.x < o.from.x) 3<-1  is not true so no residue on the left
    // if (to.x > o.to.x) 7>5 is true now so there's residue on the right
    // so we only add (o.to.x + 1, to.x) which is (6,7) in this case.
    //
    // So we've got this bit of pseudo code
    //
    // if (from.x < o.from.x) {
    //   add (from.x, o.from.x -1)
    // }
    // if (to.x > o.to.x) {
    //  add(o.to.x + 1, to.x)
    // }
    //
    // Let's see if our pseudo code works for the last three cases
    //
    // this  -5....0
    // other       0....5
    //
    // if (from.x < o.from.x) {         yes it does because -5 < 0
    //   add (from.x, o.from.x -1)      we add (-5,-1) nice!
    // }
    // if (to.x > o.to.x) {             no, 0 > 5 is not true
    //  add(o.to.x + 1, to.x)
    // }
    //
    // this        0....5
    // other -5....0
    //
    // if (from.x < o.from.x) {         no, 0 < -5 is not true
    //   add (from.x, o.from.x -1)
    // }
    // if (to.x > o.to.x) {             yes it does because 5 > 0
    //  add(o.to.x + 1, to.x)           we add (1,5) nice!
    // }
    //
    // this         1...5
    // other -5...1
    //
    // if (from.x < o.from.x) {         no, 1 < -5 is not true
    //   add (from.x, o.from.x -1)
    // }
    // if (to.x > o.to.x) {             no, 5 > 1 is not true either
    //  add(o.to.x + 1, to.x)
    // }
    //
    // Okay, seems to work. Let's implement this and repeat for all axis
    //
    // if (from.x < o.from.x) result.add(this.copyWithToX(o.from.x - 1));
    // if (to.x > o.to.x) result.add(this.copyWithFromX(o.to.x + 1));
    // if (from.y < o.from.y) result.add(this.copyWithToY(o.from.y - 1));
    // if (to.y > o.to.y) result.add(this.copyWithFromY(o.to.y + 1));
    // if (from.z < o.from.z) result.add(o.copyWithToZ(o.from.z - 1));
    // if (to.z > o.to.z) result.add(o.copyWithFromZ(o.to.z + 1));
    //
    // Hmm... doesn't work right away
    // Checking the small sample
    // on x=10..12,y=10..12,z=10..12
    // on x=11..13,y=11..13,z=11..13
    //
    // if (from.x < o.from.x) result.add(this.copyWithToX(o.from.x - 1));
    // results in: if (10 < 11) which is true. We add x(from:10,to:10)
    // Seems correct.. but maybe we should also directly remove the y and z
    // cubes because now we end up with x(from:10,to:10) and y(from:10,to:12)
    // and z(from:10,to:12) Hmm... We have some overlap I'm afraid...
    //
    // Maybe if we find the first residue plane, we don't need to include that
    // in the other axis anymore... So maybe
    // if (from.x < o.from.x) result.add(this.copyWithToX(o.from.x - 1));
    // if (to.x > o.to.x) result.add(this.copyWithFromX(o.to.x + 1));
    // is correct.. but then we only copy the y-part without the x-part from
    // our own cubit and use the x from the other cubit, so the first bit is fine
    //
    // if (from.x < o.from.x) result.add(this.copyWithToX(o.from.x - 1));
    // if (to.x > o.to.x) result.add(this.copyWithFromX(o.to.x + 1));
    //
    // Now add "o" as another argument to copy the from and to x in the y-case
    // if (from.y < o.from.y) result.add(this.copyWithToY(o, o.from.y - 1));
    // if (to.y > o.to.y) result.add(this.copyWithFromY(o, o.to.y + 1));
    // Same for the z-axis and then copy from/to X and Y from "o"
    // if (from.z < o.from.z) result.add(this.copyWithToZ(o, o.from.z - 1));
    // if (to.z > o.to.z) result.add(this.copyWithFromZ(o, o.to.z + 1));
    //
    // Here goes nothing again
    // if (from.x < o.from.x) result.add(copyWithToX(o.from.x - 1));
    // if (to.x > o.to.x) result.add(copyWithFromX(o.to.x + 1));
    // if (from.y < o.from.y) result.add(copyWithToY(o, o.from.y - 1));
    // if (to.y > o.to.y) result.add(copyWithFromY(o, o.to.y + 1));
    // if (from.z < o.from.z) result.add(copyWithToZ(o, o.from.z - 1));
    // if (to.z > o.to.z) result.add(copyWithFromZ(o, o.to.z + 1));
    //
    // Bloody hell... also doesn't work correctly
    // Time to draw it out in the 3D case I'm afraid
    // So the small example has c1 (10..12,10..12,10..12)
    // and we are extracting c2 (11..13,11..13,11..13)
    // With the above mechanism I end up with three planes of size 9 each
    // - (10..10,10..12,11..12) this one seems to be correct
    // - (11..13,10..10,10..12) This is too wide... it should be (11..12,10..10,10..12)
    // - (11..13,11..13,10..10) Again this is too wide it should be (11..12,11..12,10..10)
    // So I'm doing something wrong with the copied y and z to values
    //
    //... Several hours later ... added some min / maxing around the y and z
    // intersections to not add too much cubes.
    if (from.x < o.from.x) result.add(cuboidToTheLeft(o));
    if (to.x > o.to.x) result.add(cuboidToTheRight(o));
    if (from.y < o.from.y) result.add(cuboidInFront(o));
    if (to.y > o.to.y) result.add(cuboidInBack(o));
    if (from.z < o.from.z) result.add(cuboidBelow(o));
    if (to.z > o.to.z) result.add(cuboidAbove(o));
    return result;
  }
}

extension CuboidExtensions on Cuboid {
  // from.x < o.from.x
  // So there's a cuboid to the left of o.from.x
  Cuboid cuboidToTheLeft(Cuboid o) =>
      Cuboid(from.copy(), Point(o.from.x - 1, to.y, to.z));

  // from.y < o.from.y
  // There's a plane in front of the other, but we need to exclude the plane to the left, so we start at o.from.x
  Cuboid cuboidInFront(Cuboid o) => Cuboid(
      Point(max(from.x, o.from.x), from.y, from.z),
      Point(min(to.x, o.to.x), o.from.y - 1, to.z));

  // from.z < o.from.z
  // There's a cuboid below
  Cuboid cuboidBelow(Cuboid o) => Cuboid(
      Point(max(from.x, o.from.x), max(from.y, o.from.y), from.z),
      Point(min(to.x, o.to.x), min(to.y, o.to.y), o.from.z - 1));

  // to.x > o.to.x
  // So there's a cuboid to the right
  Cuboid cuboidToTheRight(Cuboid o) =>
      Cuboid(Point(o.to.x + 1, from.y, from.z), to.copy());

  // to.y > o.to.y
  // There's a cuboid in the back of the other cuboid
  Cuboid cuboidInBack(Cuboid o) => Cuboid(
      Point(max(from.x, o.from.x), o.to.y + 1, from.z),
      Point(min(to.x, o.to.x), to.y, to.z));

  // to.z > o.to.z
  // There's a cuboid above
  Cuboid cuboidAbove(Cuboid o) => Cuboid(
      Point(max(from.x, o.from.x), max(from.y, o.from.y), o.to.z + 1),
      Point(min(to.x, o.to.x), min(to.y, o.to.y), to.z));
}

extension CuboidListExtensions on List<Cuboid> {
  List<Cuboid> minus(Cuboid o) {
    final result = <Cuboid>[];
    for (int i = 0; i < length; i++) {
      result.addAll(this[i] - o);
    }
    return result;
  }

  int size() => fold<int>(0, (sum, cuboid) => sum + cuboid.size());
}

class Point {
  const Point(this.x, this.y, this.z);

  final int x, y, z;

  factory Point.fromList(List<int> list) => Point(list[0], list[1], list[2]);

  Point operator +(Point o) => Point(x + o.x, y + o.y, z + o.z);

  Point operator -(Point o) => Point(x - o.x, y - o.y, z - o.z);

  bool operator ==(Object o) => o is Point && o.x == x && o.y == y && o.z == z;

  int get hashCode => x + 31 * y + 17 * 31 * z;

  @override
  String toString() => '($x,$y,$z)';

  Point copy() => Point(x, y, z);
}
