import 'dart:io';
import 'dart:math';

var maxGeodes = 0;
var previousResults = <int, int>{};

void main(List<String> args) {
  print('--- Day 19: Not Enough Minerals ---');

  var filename = args.isNotEmpty ? args[0] : './lib/day19/input.txt';
  List<Blueprint> input = parseInput(filename).toList();

  var part1 = 0;

  for (var blueprint in input) {
    var resources = [0, 0, 0, 0];
    var robots = [1, 0, 0, 0];
    maxGeodes = 0;
    previousResults.clear();
    findMaxGeodes(blueprint, resources, robots, 24);
    part1 += maxGeodes * blueprint.id;
  }

  print('    Part 1: $part1');

  var part2 = 1;
  for (var blueprint in input.take(3)) {
    var resources = [0, 0, 0, 0];
    var robots = [1, 0, 0, 0];
    maxGeodes = 0;
    previousResults.clear();
    findMaxGeodes(blueprint, resources, robots, 32);
    part2 *= maxGeodes;
  }

  print('    Part 2: $part2');
}

int findMaxGeodes(Blueprint bp, List<int> res, List<int> robots, int minute) {
  final key = 'resources:$res robots:$robots minute:$minute'.hashCode;
  if (previousResults.containsKey(key)) return previousResults[key]!;

  if (minute == 1) {
    var newResources = harvest(List.of(robots), List.of(res));
    if (newResources[Type.geode.index] > maxGeodes) maxGeodes = newResources[Type.geode.index];
    return newResources[Type.geode.index];
  }

  final nrOfGeodes = res[Type.geode.index];
  if (maxGeodes >= nrOfGeodes + (minute * (nrOfGeodes + minute))) {
    // This path will never lead to a higher geode production
    return -1;
  }

  var result = 0;
  if (canBuildRobot(Type.geode, res, bp)) {
    var newResources = harvest(List.of(robots), List.of(res));
    var newRobots = List.of(robots)..[Type.geode.index] += 1;
    newResources = removeResourcesBuiltRobotOfType(Type.geode, newResources, bp);
    result = findMaxGeodes(bp, newResources, newRobots, minute - 1);
  } else {
    var maxDoNotBuildAnyRobot = findMaxGeodes(bp, harvest(List.of(robots), List.of(res)), List.of(robots), minute - 1);

    var maxBuiltObsidian = -1;
    if (canBuildRobot(Type.obsidian, res, bp) && couldUseAnother(Type.obsidian, List.of(robots), bp)) {
      var newRobots = List.of(robots)..[Type.obsidian.index] += 1;
      var newResources = harvest(List.of(robots), List.of(res));
      newResources = removeResourcesBuiltRobotOfType(Type.obsidian, newResources, bp);
      maxBuiltObsidian = findMaxGeodes(bp, newResources, newRobots, minute - 1);
    }

    var maxBuiltClay = -1;
    if (canBuildRobot(Type.clay, res, bp) && couldUseAnother(Type.clay, List.of(robots), bp)) {
      var newRobots = List.of(robots)..[Type.clay.index] += 1;
      var newResources = harvest(List.of(robots), List.of(res));
      newResources = removeResourcesBuiltRobotOfType(Type.clay, newResources, bp);
      maxBuiltClay = findMaxGeodes(bp, newResources, newRobots, minute - 1);
    }

    var maxBuiltOre = -1;
    if (canBuildRobot(Type.ore, res, bp) && couldUseAnother(Type.ore, List.of(robots), bp)) {
      var newRobots = List.of(robots)..[Type.ore.index] += 1;
      var newResources = harvest(List.of(robots), List.of(res));
      newResources = removeResourcesBuiltRobotOfType(Type.ore, newResources, bp);
      maxBuiltOre = findMaxGeodes(bp, newResources, newRobots, minute - 1);
    }

    result = [maxDoNotBuildAnyRobot, maxBuiltObsidian, maxBuiltClay, maxBuiltOre].reduce(max);
  }
  if (result > -1) previousResults[key] = result;
  return result;
}

bool couldUseAnother(Type type, List<int> robots, Blueprint blueprint) =>
    (robots[type.index] < blueprint.maxNeeded[type]!);

Iterable<Blueprint> parseInput(String filename) {
  final input = File(filename).readAsLinesSync().map((line) {
    final robots = <Robot>[];
    var matches = RegExp(r'Blueprint (\d+):').allMatches(line).toList();
    final id = int.parse(matches[0][1]!);
    var robotInfo = line.substring(line.indexOf(':') + 7).split('. Each ').toList();
    for (var i = 0; i < robotInfo.length; i++) {
      var ore = 0, clay = 0, obsidian = 0;
      var matches = RegExp(r'(\d+) ore').allMatches(robotInfo[i]).toList();
      if (matches.isNotEmpty && matches[0][1] != null) {
        ore = int.parse(matches[0][1]!);
      }
      matches = RegExp(r'(\d+) clay').allMatches(robotInfo[i]).toList();
      if (matches.isNotEmpty && matches[0][1] != null) {
        clay = int.parse(matches[0][1]!);
      }
      matches = RegExp(r'(\d+) obsidian').allMatches(robotInfo[i]).toList();
      if (matches.isNotEmpty && matches[0][1] != null) {
        obsidian = int.parse(matches[0][1]!);
      }
      robots.add(Robot(Type.values[i], [ore, clay, obsidian]));
    }
    return Blueprint(id, robots);
  });
  return input;
}

List<int> removeResourcesBuiltRobotOfType(Type type, List<int> earnings, Blueprint blueprint) {
  var result = List.of(earnings);
  result[Type.ore.index] -= blueprint.robots[type.index].cost[Type.ore.index];
  result[Type.clay.index] -= blueprint.robots[type.index].cost[Type.clay.index];
  result[Type.obsidian.index] -= blueprint.robots[type.index].cost[Type.obsidian.index];
  return result;
}

List<int> harvest(List<int> robots, List<int> resources) {
  var result = List.of(resources);
  if (robots[Type.ore.index] > 0) result[Type.ore.index] += robots[Type.ore.index];
  if (robots[Type.clay.index] > 0) result[Type.clay.index] += robots[Type.clay.index];
  if (robots[Type.obsidian.index] > 0) result[Type.obsidian.index] += robots[Type.obsidian.index];
  if (robots[Type.geode.index] > 0) result[Type.geode.index] += robots[Type.geode.index];
  return result;
}

bool canBuildRobot(Type type, List<int> resources, Blueprint blueprint) {
  return resources[Type.ore.index] >= blueprint.robots[type.index].cost[Type.ore.index] &&
      resources[Type.clay.index] >= blueprint.robots[type.index].cost[Type.clay.index] &&
      resources[Type.obsidian.index] >= blueprint.robots[type.index].cost[Type.obsidian.index];
}

enum Type { ore, clay, obsidian, geode }

class Robot {
  Robot(this.type, this.cost);

  Type type;
  List<int> cost;

  @override
  String toString() {
    return 'Robot{type: $type, cost: $cost},\n';
  }
}

class Blueprint {
  Blueprint(this.id, this.robots) {
    for (var type in Type.values) {
      if (type == Type.geode) continue;
      maxNeeded[type] = robots.fold(
          0,
          (previousValue, element) =>
              element.cost[type.index] > previousValue ? element.cost[type.index] : previousValue);
    }
  }

  int id;
  List<Robot> robots;
  final maxNeeded = <Type, int>{};

  @override
  String toString() {
    return 'Blueprint{id: $id, robots: \n$robots}';
  }
}
