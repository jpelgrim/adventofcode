// https://adventofcode.com/2021/day/2
import 'dart:io';

void main() {
  Location position = File('input.txt')
      .readAsLinesSync()
      .fold<Location>(Location(0, 0, 0), (location, data) {
    final command = data.split(' ');
    Location commandLocation = Location(0, 0, 0);
    switch (command[0]) {
      case 'forward':
        final value = int.parse(command[1]);
        final depthIncrease = location.aim * value;
        commandLocation = Location(depthIncrease, value, 0);
        break;
      case 'up':
        commandLocation = Location(0, 0, -int.parse(command[1]));
        break;
      case 'down':
        commandLocation = Location(0, 0, int.parse(command[1]));
        break;
    }
    return location + commandLocation;
  });
  print('    Part 2: ${position.depth * position.position}');
}

class Location {
  Location(this.depth, this.position, this.aim);

  int depth;
  int position;
  int aim;

  Location operator +(Location other) {
    return Location(
        depth + other.depth, position + other.position, aim + other.aim);
  }
}
