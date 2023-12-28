// https://adventofcode.com/2021/day/2
import 'dart:io';

void main() {
  print('--- Day 2: Dive! ---');

  Location position = File('input.txt')
      .readAsLinesSync()
      .fold<Location>(Location(0, 0), (location, data) {
    final command = data.split(' ');
    Location commandLocation = Location(0, 0);
    switch (command[0]) {
      case 'forward':
        commandLocation = Location(0, int.parse(command[1]));
        break;
      case 'up':
        commandLocation = Location(-int.parse(command[1]), 0);
        break;
      case 'down':
        commandLocation = Location(int.parse(command[1]), 0);
        break;
    }
    return location + commandLocation;
  });
  print('    Part 1: ${position.depth * position.position}');
}

class Location {
  Location(this.depth, this.position);

  int depth;
  int position;

  Location operator +(Location other) {
    return Location(depth + other.depth, position + other.position);
  }
}
