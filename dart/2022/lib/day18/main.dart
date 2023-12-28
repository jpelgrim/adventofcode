import 'dart:io';

import 'cuboid.dart';

void main(List<String> args) {
  print('--- Day 18: Boiling Boulders ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day18/input.txt';
  final input = File(filename).readAsLinesSync().map((e) {
    var coords = e.split(',');
    return Cuboid(
      int.parse(coords[0]),
      int.parse(coords[1]),
      int.parse(coords[2]),
    );
  }).toList();

  var maxCuboid = input.fold(Cuboid(0, 0, 0), (previousValue, element) {
    var maxX = previousValue.x;
    var maxY = previousValue.y;
    var maxZ = previousValue.z;
    if (element.x > maxX) maxX = element.x;
    if (element.y > maxY) maxY = element.y;
    if (element.z > maxZ) maxZ = element.z;
    return Cuboid(maxX, maxY, maxZ);
  });

  maxCuboid = Cuboid(maxCuboid.x + 1, maxCuboid.y + 1, maxCuboid.z + 1);

  var part1 = 0;
  for (var cuboid in input) {
    part1 += input.neighbourAir(cuboid, maxCuboid).length;
  }
  print('    Part 1: $part1');

  var toVisit = [Cuboid(-1, -1, -1)];
  var filledCubes = List.of(input);
  filledCubes.add(Cuboid(-1, -1, -1));
  var visited = <Cuboid>{};

  // Try to fill up a larger cube form -1,-1,-1 to the max cube corner
  while (toVisit.isNotEmpty) {
    var visiting = toVisit.removeAt(0);
    if (visited.contains(visiting)) continue;
    visited.add(visiting);

    var cubesUnderTest = [
      Cuboid(visiting.x - 1, visiting.y, visiting.z),
      Cuboid(visiting.x + 1, visiting.y, visiting.z),
      Cuboid(visiting.x, visiting.y - 1, visiting.z),
      Cuboid(visiting.x, visiting.y + 1, visiting.z),
      Cuboid(visiting.x, visiting.y, visiting.z - 1),
      Cuboid(visiting.x, visiting.y, visiting.z + 1),
    ];

    for (var cube in cubesUnderTest) {
      if (cube.x >= -1 &&
          cube.x <= maxCuboid.x + 1 &&
          cube.y >= -1 &&
          cube.y <= maxCuboid.y + 1 &&
          cube.z >= -1 &&
          cube.z <= maxCuboid.z + 1) {
        if (!filledCubes.contains(cube)) {
          filledCubes.add(cube);
          toVisit.add(cube);
        }
      }
    }
  }

  var part2 = 0;
  // Now find the sides which are touching air. These can only be the trapped
  // cubes sides.
  for (var cuboid in filledCubes) {
    if (cuboid.x == -1 ||
        cuboid.x == maxCuboid.x ||
        cuboid.y == -1 ||
        cuboid.y == maxCuboid.y ||
        cuboid.z == -1 ||
        cuboid.z == maxCuboid.z) continue;
    part2 += filledCubes.neighbourAir(cuboid, maxCuboid).length;
  }
  // The answer is all the sides touching air, minus the trapped sides
  part2 = part1 - part2;
  print('    Part 2: $part2');
}

extension on List<Cuboid> {
  List<Cuboid> neighbourAir(Cuboid cuboid, Cuboid maxCuboid) {
    List<Cuboid> airNeighbours = [];
    var cubesUnderTest = [
      Cuboid(cuboid.x - 1, cuboid.y, cuboid.z),
      Cuboid(cuboid.x + 1, cuboid.y, cuboid.z),
      Cuboid(cuboid.x, cuboid.y - 1, cuboid.z),
      Cuboid(cuboid.x, cuboid.y + 1, cuboid.z),
      Cuboid(cuboid.x, cuboid.y, cuboid.z - 1),
      Cuboid(cuboid.x, cuboid.y, cuboid.z + 1),
    ];
    for (var cube in cubesUnderTest) {
      if (cube.x >= -1 &&
          cube.x <= maxCuboid.x &&
          cube.y >= -1 &&
          cube.y <= maxCuboid.y &&
          cube.z >= -1 &&
          cube.z <= maxCuboid.z &&
          !contains(cube)) airNeighbours.add(cube);
    }
    return airNeighbours;
  }
}
