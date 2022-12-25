import 'point.dart';

class Area {
  Area(this.p1, this.p2);

  Point p1;
  Point p2;

  @override
  bool operator ==(Object other) =>
      other is Area && other.p1 == p1 && other.p2 == p2;

  @override
  int get hashCode => 31 * p1.hashCode + p2.hashCode;

  @override
  String toString() {
    return '($p1,$p2)';
  }

  bool hit(Point point) =>
      point.x >= p1.x && point.x <= p2.x && point.y >= p1.y && point.y <= p2.y;

  bool overshoot(Point point) => point.y < p1.y;
}
