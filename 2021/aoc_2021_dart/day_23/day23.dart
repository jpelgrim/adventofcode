// https://adventofcode.com/2021/day/23
import 'dart:io';

import 'priority_queue.dart';

final hallwayPoints = [
  Point(0, 0),
  Point(1, 0),
  Point(3, 0),
  Point(5, 0),
  Point(7, 0),
  Point(9, 0),
  Point(10, 0),
];

const typeStrings = ['A', 'B', 'C', 'D'];
const roomIndices = [2, 4, 6, 8];

final sampleInput = 'input-sample.txt';
final realInput = 'input.txt';
final input = realInput;

// #############
// #.A.C.....B.#
// ###.#.#.#D###
//   #A#D#C#B#
//   #########
final testAvailablePositions =
    'A(1,0)-A(2,2)-B(8,2)-B(9,0)-C(3,0)-C(6,2)-D(4,2)-D(8,1)'.toAmphipods();

void main() {
  print('--- Day 23: Amphipod ---');

  //runTests();
  part1();
  part2();
}

void part1() {
  final amphipods = readAmphipods(fileName: input);
  final answer = calculateLowestEnergy(amphipods, 2);
  print('    Part 1: $answer');
}

void part2() {
  final amphipods = readAmphipods(fileName: input, part1: false);
  final answer = calculateLowestEnergy(amphipods, 4);
  print('    Part 2: $answer');
}

void runTests() {
  pointTests();
  availableMovesTests();
  dirtyTests();
  moversTests();
}

void pointTests() {
  final point = Point(3, 4);
  final pointString = point.toString();
  final pointFromString = Point.fromString(pointString);
  assert(point == pointFromString);
}

void dirtyTests() {
  // #############
  // #.A.C.....B.#
  // ###.#.#.#D###
  //   #A#D#C#B#
  //   #########
  assert(testAvailablePositions.isDirty(2) == false);
  assert(testAvailablePositions.isDirty(4));
  assert(testAvailablePositions.isDirty(6) == false);
  assert(testAvailablePositions.isDirty(8));
  // Or via another method
  assert(testAvailablePositions.isAccessible(2));
  assert(testAvailablePositions.isAccessible(4) == false);
  assert(testAvailablePositions.isAccessible(6));
  assert(testAvailablePositions.isAccessible(8) == false);
}

void moversTests() {
  // #############
  // #.A.C.....B.#
  // ###.#.#.#D###
  //   #A#D#C#B#
  //   #########
  var topMovers = testAvailablePositions.topMovers();
  assert(topMovers.length == 2);
  assert(topMovers[0] == 'D'.asAmphipod(4, 2));
  assert(topMovers[1] == 'D'.asAmphipod(8, 1));

  var movers = testAvailablePositions.movers();
  assert(movers.length == 5);
  assert(movers[0] == 'A'.asAmphipod(1, 0));
  assert(movers[1] == 'B'.asAmphipod(9, 0));
  assert(movers[2] == 'C'.asAmphipod(3, 0));
  assert(movers[3] == 'D'.asAmphipod(4, 2));
  assert(movers[4] == 'D'.asAmphipod(8, 1));

  // #############
  // #...........#
  // ###B#C#B#D###
  //   #A#D#C#A#
  //   #########
  var sampleInput =
      'A(2,2)-A(8,2)-B(2,1)-B(6,1)-C(4,1)-C(6,2)-D(4,2)-D(8,1)'.toAmphipods();
  movers = sampleInput.movers();
  assert(movers.length == 4);
  var B21 = 'B'.asAmphipod(2, 1);
  assert(movers[0] == B21);
  var C41 = 'C'.asAmphipod(4, 1);
  assert(movers[1] == C41);
  var B61 = 'B'.asAmphipod(6, 1);
  assert(movers[2] == B61);
  var D81 = 'D'.asAmphipod(8, 1);
  assert(movers[3] == D81);

  var moves = availableMoves(B21, sampleInput, 2);
  assert(moves.length == 7);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));
  assert(moves.contains(hallwayPoints[6]));

  moves = availableMoves(C41, sampleInput, 2);
  assert(moves.length == 7);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));
  assert(moves.contains(hallwayPoints[6]));

  moves = availableMoves(B61, sampleInput, 2);
  assert(moves.length == 7);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));
  assert(moves.contains(hallwayPoints[6]));

  moves = availableMoves(D81, sampleInput, 2);
  assert(moves.length == 7);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));
  assert(moves.contains(hallwayPoints[6]));

  // #############
  // #..........D#
  // ###B#C#B#.###
  //   #D#C#B#A#
  //   #D#B#A#C#
  //   #A#D#C#A#
  //   #########
  sampleInput =
      'A(2,4)-A(6,3)-A(8,2)-A(8,4)-B(2,1)-B(4,3)-B(6,1)-B(6,2)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)'
          .toAmphipods();

  movers = sampleInput.movers();
  assert(movers.length == 5);
  B21 = 'B'.asAmphipod(2, 1);
  assert(movers.contains(B21));
  C41 = 'C'.asAmphipod(4, 1);
  assert(movers.contains(C41));
  B61 = 'B'.asAmphipod(6, 1);
  assert(movers.contains(B61));
  var DX0 = 'D'.asAmphipod(10, 0);
  assert(movers.contains(DX0));
  var A82 = 'A'.asAmphipod(8, 2);
  assert(movers.contains(A82));

  moves = availableMoves(B21, sampleInput, 4);
  assert(moves.length == 6);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));

  moves = availableMoves(C41, sampleInput, 4);
  assert(moves.length == 6);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));

  moves = availableMoves(B61, sampleInput, 4);
  assert(moves.length == 6);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));

  moves = availableMoves(A82, sampleInput, 4);
  assert(moves.length == 6);
  assert(moves.contains(hallwayPoints[0]));
  assert(moves.contains(hallwayPoints[1]));
  assert(moves.contains(hallwayPoints[2]));
  assert(moves.contains(hallwayPoints[3]));
  assert(moves.contains(hallwayPoints[4]));
  assert(moves.contains(hallwayPoints[5]));

  moves = availableMoves(DX0, sampleInput, 4);
  assert(moves.isEmpty);
}

void availableMovesTests() {
  // #############
  // #.A.C.....B.#
  // ###.#.#.#D###
  //   #A#D#C#B#
  //   #########
  var moves = availableMoves('A'.asAmphipod(1, 0), testAvailablePositions, 2);
  assert(moves.length == 1);
  assert(moves.contains(Point(2, 1)));

  moves = availableMoves('C'.asAmphipod(3, 0), testAvailablePositions, 2);
  assert(moves.length == 1);
  assert(moves.contains(Point(6, 1)));

  moves = availableMoves('B'.asAmphipod(9, 0), testAvailablePositions, 2);
  assert(moves.isEmpty);

  moves = availableMoves('D'.asAmphipod(4, 2), testAvailablePositions, 2);
  assert(moves.length == 2);
  assert(moves.contains(Point(5, 0)));
  assert(moves.contains(Point(7, 0)));

  moves = availableMoves('D'.asAmphipod(8, 1), testAvailablePositions, 2);
  assert(moves.length == 2);
  assert(moves.contains(Point(5, 0)));
  assert(moves.contains(Point(7, 0)));

  // #############
  // #...B.D.....#
  // ###B#.#C#D###
  //   #A#.#C#A#
  //   #########
  final step3 =
      'A(2,2)-A(8,2)-B(2,1)-B(3,0)-C(6,1)-C(6,2)-D(5,0)-D(8,1)'.toAmphipods();
  moves = availableMoves('B'.asAmphipod(3, 0), step3, 2);
  assert(moves.length == 1);
  assert(moves[0] == Point(4, 2));

  // #############
  // #..........D#
  // ###A#B#C#.###
  //   #A#B#C#D#
  //   #A#B#C#D#
  //   #A#B#C#D#
  //   #########

  final step22 =
      'A(2,1)-A(2,2)-A(2,3)-A(2,4)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(8,2)-D(8,3)-D(8,4)-D(10,0)'
          .toAmphipods();
  var movers = step22.movers();
  assert(movers.length == 1);
  moves = availableMoves(movers[0], step22, 4);
  assert(moves.length == 1);
  assert(moves[0] == Point(8, 1));
}

List<Amphipod> readAmphipods({required String fileName, bool part1 = true}) {
  final amphipods = <Amphipod>[];
  final lines = File(fileName).readAsLinesSync();
  if (lines[1][1].isAmphipod()) amphipods.add(lines[1][1].asAmphipod(0, 0));
  if (lines[1][2].isAmphipod()) amphipods.add(lines[1][2].asAmphipod(1, 0));
  if (lines[1][3].isAmphipod()) amphipods.add(lines[1][3].asAmphipod(2, 0));
  if (lines[1][4].isAmphipod()) amphipods.add(lines[1][4].asAmphipod(3, 0));
  if (lines[1][5].isAmphipod()) amphipods.add(lines[1][5].asAmphipod(4, 0));
  if (lines[1][6].isAmphipod()) amphipods.add(lines[1][6].asAmphipod(5, 0));
  if (lines[1][7].isAmphipod()) amphipods.add(lines[1][7].asAmphipod(6, 0));
  if (lines[1][8].isAmphipod()) amphipods.add(lines[1][8].asAmphipod(7, 0));
  if (lines[1][9].isAmphipod()) amphipods.add(lines[1][9].asAmphipod(8, 0));
  if (lines[1][10].isAmphipod()) amphipods.add(lines[1][10].asAmphipod(9, 0));
  if (lines[1][11].isAmphipod()) amphipods.add(lines[1][11].asAmphipod(10, 0));
  if (lines[2][3].isAmphipod()) amphipods.add(lines[2][3].asAmphipod(2, 1));
  if (lines[2][5].isAmphipod()) amphipods.add(lines[2][5].asAmphipod(4, 1));
  if (lines[2][7].isAmphipod()) amphipods.add(lines[2][7].asAmphipod(6, 1));
  if (lines[2][9].isAmphipod()) amphipods.add(lines[2][9].asAmphipod(8, 1));

  if (part1) {
    if (lines[3][3].isAmphipod()) amphipods.add(lines[3][3].asAmphipod(2, 2));
    if (lines[3][5].isAmphipod()) amphipods.add(lines[3][5].asAmphipod(4, 2));
    if (lines[3][7].isAmphipod()) amphipods.add(lines[3][7].asAmphipod(6, 2));
    if (lines[3][9].isAmphipod()) amphipods.add(lines[3][9].asAmphipod(8, 2));
  } else {
    //   #D#C#B#A#
    amphipods.add('D'.asAmphipod(2, 2));
    amphipods.add('C'.asAmphipod(4, 2));
    amphipods.add('B'.asAmphipod(6, 2));
    amphipods.add('A'.asAmphipod(8, 2));
    //   #D#B#A#C#
    amphipods.add('D'.asAmphipod(2, 3));
    amphipods.add('B'.asAmphipod(4, 3));
    amphipods.add('A'.asAmphipod(6, 3));
    amphipods.add('C'.asAmphipod(8, 3));

    if (lines[3][3].isAmphipod()) amphipods.add(lines[3][3].asAmphipod(2, 4));
    if (lines[3][5].isAmphipod()) amphipods.add(lines[3][5].asAmphipod(4, 4));
    if (lines[3][7].isAmphipod()) amphipods.add(lines[3][7].asAmphipod(6, 4));
    if (lines[3][9].isAmphipod()) amphipods.add(lines[3][9].asAmphipod(8, 4));
  }

  return amphipods;
}

enum Type { amber, bronze, copper, desert }

class Amphipod extends Comparable {
  Amphipod(this.typeString, this.pos)
      : this.type = typeString.toPodType(),
        this.energy = typeString.toEnergyLevel(),
        this.roomIndex = typeString.toRoomIndex();
  String typeString;
  Point pos;
  Type type;
  int energy;
  int roomIndex;

  @override
  bool operator ==(Object other) =>
      other is Amphipod && other.typeString == typeString && other.pos == pos;

  @override
  int get hashCode => 31 * pos.hashCode + typeString.hashCode;

  @override
  String toString() {
    return '$typeString$pos';
  }

  @override
  int compareTo(other) {
    if (typeString == other.typeString && pos == other.pos) return 0;
    if (typeString == other.typeString) return pos.compareTo(other.pos);
    return typeString.compareTo(other.typeString);
  }
}

// Calculating the lowest energy with Dijkstra's shortest path algorithm
// https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Using_a_priority_queue
int calculateLowestEnergy(List<Amphipod> amphipods, int maxY) {
  final calculatedEnergy = <String, int>{};
  calculatedEnergy[amphipods.fingerPrint()] = 0;

  final toVisit = HeapPriorityQueue<String>((g1, g2) =>
      (calculatedEnergy[g1] ?? 9999999999)
          .compareTo(calculatedEnergy[g2] ?? 9999999999));
  final visited = <String>{};
  toVisit.add(amphipods.fingerPrint());

  while (toVisit.isNotEmpty) {
    final visitingFingerPrint = toVisit.removeFirst();
    final visitingAmphipods = visitingFingerPrint.toAmphipods();
    final visitingEnergy = calculatedEnergy[visitingFingerPrint];
    visited.add(visitingFingerPrint);
    visitingAmphipods.movers().forEach((pod) {
      availableMoves(pod, visitingAmphipods, maxY).forEach((destination) {
        final newEnergy =
            (pod.pos.distance(destination) * pod.energy) + visitingEnergy;
        final destinationFingerPrint = visitingFingerPrint.replaceFirst(
            pod.toString(), '${pod.typeString}${destination}');
        final destinationAmphipods = destinationFingerPrint.toAmphipods();
        final key = destinationAmphipods.fingerPrint();
        assert(destinationAmphipods.length == (maxY == 2 ? 8 : 16));
        if (!visited.contains(key)) {
          if (newEnergy < (calculatedEnergy[key] ?? 9999999999)) {
            calculatedEnergy[key] = newEnergy;
            toVisit.add(key);
          }
        }
      });
    });
  }

  if (input == sampleInput && maxY == 2) {
    // #############
    // #...B.......#
    // ###B#C#.#D###
    //   #A#D#C#A#
    //   #########
    print(
        'Step 1: ${calculatedEnergy['A(2,2)-A(8,2)-B(2,1)-B(3,0)-C(4,1)-C(6,2)-D(4,2)-D(8,1)']}');

    // #############
    // #...B.......#
    // ###B#.#C#D###
    //   #A#D#C#A#
    //   #########
    print(
        'Step 2: ${calculatedEnergy['A(2,2)-A(8,2)-B(2,1)-B(3,0)-C(6,1)-C(6,2)-D(4,2)-D(8,1)']}');

    // #############
    // #...B.D.....#
    // ###B#.#C#D###
    //   #A#.#C#A#
    //   #########
    print(
        'Step 3: ${calculatedEnergy['A(2,2)-A(8,2)-B(2,1)-B(3,0)-C(6,1)-C(6,2)-D(5,0)-D(8,1)']}');

    // #############
    // #.....D.....#
    // ###B#.#C#D###
    //   #A#B#C#A#
    //   #########
    print(
        'Step 4: ${calculatedEnergy['A(2,2)-A(8,2)-B(2,1)-B(4,2)-C(6,1)-C(6,2)-D(5,0)-D(8,1)']}');

    // #############
    // #.....D.....#
    // ###.#B#C#D###
    //   #A#B#C#A#
    //   #########
    print(
        'Step 5: ${calculatedEnergy['A(2,2)-A(8,2)-B(4,1)-B(4,2)-C(6,1)-C(6,2)-D(5,0)-D(8,1)']}');

    // #############
    // #.....D.D...#
    // ###.#B#C#.###
    //   #A#B#C#A#
    //   #########
    print(
        'Step 6: ${calculatedEnergy['A(2,2)-A(8,2)-B(4,1)-B(4,2)-C(6,1)-C(6,2)-D(5,0)-D(7,0)']}');

    // #############
    // #.....D.D.A.#
    // ###.#B#C#.###
    //   #A#B#C#.#
    //   #########
    print(
        'Step 7: ${calculatedEnergy['A(2,2)-A(9,0)-B(4,1)-B(4,2)-C(6,1)-C(6,2)-D(5,0)-D(7,0)']}');

    // #############
    // #.....D...A.#
    // ###.#B#C#.###
    //   #A#B#C#D#
    //   #########
    print(
        'Step 8: ${calculatedEnergy['A(2,2)-A(9,0)-B(4,1)-B(4,2)-C(6,1)-C(6,2)-D(5,0)-D(8,2)']}');

    // #############
    // #.........A.#
    // ###.#B#C#D###
    //   #A#B#C#D#
    //   #########
    print(
        'Step 9: ${calculatedEnergy['A(2,2)-A(9,0)-B(4,1)-B(4,2)-C(6,1)-C(6,2)-D(8,1)-D(8,2)']}');

    // #############
    // #...........#
    // ###A#B#C#D###
    //   #A#B#C#D#
    //   #########
    print(
        'Step 10: ${calculatedEnergy['A(2,1)-A(2,2)-B(4,1)-B(4,2)-C(6,1)-C(6,2)-D(8,1)-D(8,2)']}');
  }

  if (input == sampleInput && maxY == 4) {
    // #############
    // #...........#
    // ###B#C#B#D###
    //   #D#C#B#A#
    //   #D#B#A#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 0: ${calculatedEnergy['A(2,4)-A(6,3)-A(8,2)-A(8,4)-B(2,1)-B(4,3)-B(6,1)-B(6,2)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(8,1)']}');

    // #############
    // #..........D#
    // ###B#C#B#.###
    //   #D#C#B#A#
    //   #D#B#A#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 1: ${calculatedEnergy['A(2,4)-A(6,3)-A(8,2)-A(8,4)-B(2,1)-B(4,3)-B(6,1)-B(6,2)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #A.........D#
    // ###B#C#B#.###
    //   #D#C#B#.#
    //   #D#B#A#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 2: ${calculatedEnergy['A(0,0)-A(2,4)-A(6,3)-A(8,4)-B(2,1)-B(4,3)-B(6,1)-B(6,2)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #A........BD#
    // ###B#C#.#.###
    //   #D#C#B#.#
    //   #D#B#A#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 3: ${calculatedEnergy['A(0,0)-A(2,4)-A(6,3)-A(8,4)-B(2,1)-B(4,3)-B(6,2)-B(9,0)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #A......B.BD#
    // ###B#C#.#.###
    //   #D#C#.#.#
    //   #D#B#A#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 4: ${calculatedEnergy['A(0,0)-A(2,4)-A(6,3)-A(8,4)-B(2,1)-B(4,3)-B(7,0)-B(9,0)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #AA.....B.BD#
    // ###B#C#.#.###
    //   #D#C#.#.#
    //   #D#B#.#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 5: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,3)-B(7,0)-B(9,0)-C(4,1)-C(4,2)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #AA.....B.BD#
    // ###B#.#.#.###
    //   #D#C#.#.#
    //   #D#B#C#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 6: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,3)-B(7,0)-B(9,0)-C(4,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #AA.....B.BD#
    // ###B#.#.#.###
    //   #D#.#C#.#
    //   #D#B#C#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 7: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,3)-B(7,0)-B(9,0)-C(6,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #AA...B.B.BD#
    // ###B#.#.#.###
    //   #D#.#C#.#
    //   #D#.#C#C#
    //   #A#D#C#A#
    //   #########
    print(
        'Step 8: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(5,0)-B(7,0)-B(9,0)-C(6,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(4,4)-D(10,0)']}');

    // #############
    // #AA.D.B.B.BD#
    // ###B#.#.#.###
    //   #D#.#C#.#
    //   #D#.#C#C#
    //   #A#.#C#A#
    //   #########
    print(
        'Step 9: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(5,0)-B(7,0)-B(9,0)-C(6,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(3,0)-D(10,0)']}');

    // #############
    // #AA.D...B.BD#
    // ###B#.#.#.###
    //   #D#.#C#.#
    //   #D#.#C#C#
    //   #A#B#C#A#
    //   #########
    print(
        'Step 10: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,4)-B(7,0)-B(9,0)-C(6,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(3,0)-D(10,0)']}');

    // #############
    // #AA.D.....BD#
    // ###B#.#.#.###
    //   #D#.#C#.#
    //   #D#B#C#C#
    //   #A#B#C#A#
    //   #########
    print(
        'Step 11: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,3)-B(4,4)-B(9,0)-C(6,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(3,0)-D(10,0)']}');

    // #############
    // #AA.D......D#
    // ###B#.#.#.###
    //   #D#B#C#.#
    //   #D#B#C#C#
    //   #A#B#C#A#
    //   #########
    print(
        'Step 12: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,2)-B(4,3)-B(4,4)-C(6,2)-C(6,3)-C(6,4)-C(8,3)-D(2,2)-D(2,3)-D(3,0)-D(10,0)']}');

    // #############
    // #AA.D......D#
    // ###B#.#C#.###
    //   #D#B#C#.#
    //   #D#B#C#.#
    //   #A#B#C#A#
    //   #########
    print(
        'Step 13: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(8,4)-B(2,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(2,2)-D(2,3)-D(3,0)-D(10,0)']}');

    // #############
    // #AA.D.....AD#
    // ###B#.#C#.###
    //   #D#B#C#.#
    //   #D#B#C#.#
    //   #A#B#C#.#
    //   #########
    print(
        'Step 14: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(9,0)-B(2,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(2,2)-D(2,3)-D(3,0)-D(10,0)']}');

    // #############
    // #AA.......AD#
    // ###B#.#C#.###
    //   #D#B#C#.#
    //   #D#B#C#.#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 15: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(9,0)-B(2,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(2,2)-D(2,3)-D(8,4)-D(10,0)']}');

    // #############
    // #AA.......AD#
    // ###.#B#C#.###
    //   #D#B#C#.#
    //   #D#B#C#.#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 16: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(9,0)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(2,2)-D(2,3)-D(8,4)-D(10,0)']}');

    // #############
    // #AA.......AD#
    // ###.#B#C#.###
    //   #.#B#C#.#
    //   #D#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 17: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(9,0)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(2,3)-D(8,3)-D(8,4)-D(10,0)']}');

    // #############
    // #AA.D.....AD#
    // ###.#B#C#.###
    //   #.#B#C#.#
    //   #.#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 18: ${calculatedEnergy['A(0,0)-A(1,0)-A(2,4)-A(9,0)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(3,0)-D(8,3)-D(8,4)-D(10,0)']}');

    // #############
    // #A..D.....AD#
    // ###.#B#C#.###
    //   #.#B#C#.#
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 19: ${calculatedEnergy['A(0,0)-A(2,3)-A(2,4)-A(9,0)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(3,0)-D(8,3)-D(8,4)-D(10,0)']}');

    // #############
    // #...D.....AD#
    // ###.#B#C#.###
    //   #A#B#C#.#
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 20: ${calculatedEnergy['A(2,2)-A(2,3)-A(2,4)-A(9,0)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(3,0)-D(8,3)-D(8,4)-D(10,0)']}');

    // #############
    // #.........AD#
    // ###.#B#C#.###
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 21: ${calculatedEnergy['A(2,2)-A(2,3)-A(2,4)-A(9,0)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(8,2)-D(8,3)-D(8,4)-D(10,0)']}');

    // #############
    // #..........D#
    // ###A#B#C#.###
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 22: ${calculatedEnergy['A(2,1)-A(2,2)-A(2,3)-A(2,4)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(8,2)-D(8,3)-D(8,4)-D(10,0)']}');

    // #############
    // #...........#
    // ###A#B#C#D###
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #A#B#C#D#
    //   #########
    print(
        'Step 23: ${calculatedEnergy['A(2,1)-A(2,2)-A(2,3)-A(2,4)-B(4,1)-B(4,2)-B(4,3)-B(4,4)-C(6,1)-C(6,2)-C(6,3)-C(6,4)-D(8,1)-D(8,2)-D(8,3)-D(8,4)']}');
  }

  return calculatedEnergy[amphipods.fingerPrintSolved()] ?? 9999999999;
}

// For any give amphipod and list of all pods find all the available points
// this amphipod can move to
List<Point> availableMoves(Amphipod pod, List<Amphipod> amphipods, int maxY) {
  var lowestAccessiblePoint =
      amphipods.lowestAccessiblePoint(pod.roomIndex, maxY);
  var result = [
    ...hallwayPoints,
    if (lowestAccessiblePoint != null) lowestAccessiblePoint
  ];
  // Remove all open spaces which are current occupied by amphipods
  amphipods.forEach((pod) => result.remove(pod.pos));

  // Remove all opens spaces left and right of pods blocking their access
  amphipods.where((otherPod) => otherPod.pos.y == 0).forEach((zeroPod) {
    if (zeroPod != pod) {
      if (pod.pos.x > zeroPod.pos.x) {
        result.removeWhere((point) => point.x < zeroPod.pos.x);
      }
      if (pod.pos.x < zeroPod.pos.x) {
        result.removeWhere((point) => point.x > zeroPod.pos.x);
      }
    }
  });

  // If we are in the hallway we are only allowed to enter our room directly
  if (pod.pos.y == 0) {
    result.removeWhere((element) => element.y == 0);
  }

  return result;
}

class Point extends Comparable {
  Point(this.x, this.y);

  int x;
  int y;

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => 31 * x + y;

  @override
  String toString() => '($x,$y)';

  factory Point.fromString(String s) {
    final coords =
        s.substring(1, s.length - 1).split(',').map(int.parse).toList();
    return Point(coords[0], coords[1]);
  }

  distance(Point other) {
    if (x == other.x) return (x - other.x).abs() + (y - other.y).abs();
    return y + other.y + (x - other.x).abs();
  }

  @override
  int compareTo(other) {
    if (x == other.x && y == other.y) return 0;
    if (x == other.x) return y < other.y ? -1 : 1;
    return x < other.x ? -1 : 1;
  }
}

extension on String {
  Type toPodType() {
    switch (this) {
      case 'A':
        return Type.amber;
      case 'B':
        return Type.bronze;
      case 'C':
        return Type.copper;
    }
    return Type.desert;
  }

  int toEnergyLevel() {
    switch (this) {
      case 'A':
        return 1;
      case 'B':
        return 10;
      case 'C':
        return 100;
    }
    return 1000;
  }

  int toRoomIndex() {
    switch (this) {
      case 'A':
        return 2;
      case 'B':
        return 4;
      case 'C':
        return 6;
    }
    return 8;
  }

  isAmphipod() => typeStrings.contains(this);

  asAmphipod(int x, int y) => Amphipod(this, Point(x, y));

  List<Amphipod> toAmphipods() => split('-')
      .map((e) => Amphipod(e[0], Point.fromString(e.substring(1))))
      .toList();
}

extension on List<Amphipod> {
  List<Amphipod> movers() => [
        ...where((pod) => pod.pos.y == 0),
        ...topMovers(),
      ];

  bool isDirty(int index) =>
      any((pod) => pod.pos.x == index && pod.roomIndex != index);

  bool isAccessible(int index) =>
      where((pod) => pod.pos.x == index).every((pod) => pod.roomIndex == index);

  List<Amphipod> topMovers() {
    var result = <Amphipod>[];
    roomIndices.forEach((index) {
      if (this.isDirty(index)) result.add(topPod(index));
    });
    return result;
  }

  Point? lowestAccessiblePoint(int index, int maxY) {
    if (this.isDirty(index)) return null;
    final highestY = where((pod) => pod.pos.x == index).fold<int>(
        0,
        (previousValue, element) =>
            (previousValue == 0 || element.pos.y < previousValue)
                ? element.pos.y
                : previousValue);
    if (highestY == 0) return Point(index, maxY);
    return (highestY > 1) ? Point(index, highestY - 1) : null;
  }

  Amphipod topPod(int index) =>
      where((pod) => pod.pos.x == index).fold<Amphipod?>(
          null,
          (previousValue, element) =>
              (previousValue == null || element.pos.y < previousValue.pos.y)
                  ? element
                  : previousValue)!;

  void simplePrint(String title, int maxY) {
    print(title);
    print('#############');
    print(
        '#${_p(0, 0)}${_p(1, 0)}${_p(2, 0)}${_p(3, 0)}${_p(4, 0)}${_p(5, 0)}${_p(6, 0)}${_p(7, 0)}${_p(8, 0)}${_p(9, 0)}${_p(10, 0)}#');
    print('###${_p(2, 1)}#${_p(4, 1)}#${_p(6, 1)}#${_p(8, 1)}###');
    print('  #${_p(2, 2)}#${_p(4, 2)}#${_p(6, 2)}#${_p(8, 2)}#  ');
    if (maxY == 4) {
      print('  #${_p(2, 3)}#${_p(4, 3)}#${_p(6, 3)}#${_p(8, 3)}#  ');
      print('  #${_p(2, 4)}#${_p(4, 4)}#${_p(6, 4)}#${_p(8, 4)}#  ');
    }
    print('  #########  ');
    print('');
  }

  String _p(int x, int y) {
    var podAtPosition = where((pod) => pod.pos.x == x && pod.pos.y == y);
    return podAtPosition.isEmpty ? '.' : podAtPosition.first.typeString;
  }

  List<Amphipod> copy() {
    final copy = <Amphipod>[];
    forEach((pod) {
      copy.add(Amphipod(pod.typeString, Point(pod.pos.x, pod.pos.y)));
    });
    return copy;
  }

  String fingerPrint() {
    var result = <String>[];
    var c = copy();
    c.sort((p1, p2) => p1.compareTo(p2));
    c.forEach((element) {
      result.add('${element.typeString}(${element.pos.x},${element.pos.y})');
    });
    return result.join('-');
  }

  String fingerPrintSolved() {
    var result = <String>[];
    final roomSize = fold<int>(
        0,
        (previousValue, element) =>
            (previousValue == 0 || element.pos.y > previousValue)
                ? element.pos.y
                : previousValue);
    for (int i = 0; i < 4; i++) {
      for (int j = 1; j <= roomSize; j++) {
        result.add('${typeStrings[i]}(${roomIndices[i]},$j)');
      }
    }
    return result.join('-');
  }
}
