import 'dart:io';

import 'package:trotter/trotter.dart';

var runningMaxTotalFlow = 0;
final valves = <String, Valve>{};

void main(List<String> args) {
  print('--- Day 16: Proboscidea Volcanium ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day16/input.txt';
  final input = File(filename).readAsLinesSync();
  for (var line in input) {
    final split = line.split('; ');
    final id = split[0].substring(6, 8);
    final rate = int.parse(split[0].substring(split[0].indexOf('=') + 1));
    final tunnelsTo = split[1].startsWith('tunnels') ? split[1].substring(23).split(', ') : [split[1].substring(22)];
    valves[id] = Valve(id, rate, tunnelsTo);
  }

  // We're only interested in opening valves with rates.
  final valvesWithRates = valves.values.where((element) => element.rate > 0).toList();

  // Do a breadth first search of the shortest possible route from `AA` to
  // any of the valves with rates, and from each of these valves to one another
  var valvesToVisit = [...valvesWithRates, valves['AA']!];
  for (var source in valvesToVisit) {
    for (var dest in valvesToVisit) {
      if (source == dest || dest.id == 'AA') continue;
      valves[source.id]!.tunnelDistances[dest.id] = breadthFirstSearch(source.id, dest.id);
    }
  }

  runningMaxTotalFlow = 0;
  depthFirstSearch(valves['AA']!, valvesWithRates, 0, 0, 30);
  print('    Part 1: $runningMaxTotalFlow');

  var part2 = 0;
  // I'm just estimating the best result will be in combinations running from length 5-9
  for (var i = 5; i < 9; i++) {
    // Package Trotter to the rescue! https://pub.dev/packages/trotter
    for (var combination in Combinations(i, valvesWithRates).iterable) {
      runningMaxTotalFlow = 0;
      depthFirstSearch(valves['AA']!, combination, 0, 0, 26);
      var myMax = runningMaxTotalFlow;
      runningMaxTotalFlow = 0;
      var valvesForElephant = List.of(valvesWithRates);
      for (var valve in combination) valvesForElephant.remove(valve);
      depthFirstSearch(valves['AA']!, valvesForElephant, 0, 0, 26);
      var elephantMax = runningMaxTotalFlow;
      if (myMax + elephantMax  > part2) part2 = myMax + elephantMax;
    }
  }
  print('    Part 2: $part2');
}

// Breadth first search from source to dest to find the shortest path
int breadthFirstSearch(String source, String dest) {
  var steps = 1;
  var tunnelsToExplore = valves[source]!.tunnelsTo;
  while (true) {
    var newTunnelsToExplore = <String>[];
    for (var tunnel in tunnelsToExplore) {
      if (tunnel == dest) return steps;
      newTunnelsToExplore.addAll(valves[tunnel]!.tunnelsTo);
    }
    tunnelsToExplore = newTunnelsToExplore;
    steps += 1;
  }
}

// Do a depth first search for the maximum flow from the given startValve and
// existing rate and total flow up to this point.
void depthFirstSearch(
  Valve startValve,
  List<Valve> unvisitedValves,
  int sumRateOpenValves,
  int totalFlow,
  int timeRemaining,
) {
  if (unvisitedValves.length == 0) {
    // We're done. Nothing more to open. Add the remaining time * sum of the rates of all the open valves to the total
    // flow and compare if we have found a bigger maximum flow
    totalFlow += timeRemaining * sumRateOpenValves;
    if (totalFlow > runningMaxTotalFlow) runningMaxTotalFlow = totalFlow;
  } else {
    for (var targetValve in unvisitedValves) {
      // Distance / steps / minutes all the same                   Adding 1 minute / step for opening the valve
      var distance = startValve.tunnelDistances[targetValve.id]! + 1;
      if (distance > timeRemaining) {
        // We don't have enough time to open this target valve, but we can just calculate
        // the max flow if we end here. We might still have a winner in this case!
        var remainingFlow = timeRemaining * sumRateOpenValves;
        if (totalFlow + remainingFlow > runningMaxTotalFlow) runningMaxTotalFlow = totalFlow + remainingFlow;
      } else {
        // We have time to open this target valve investigate this path
        depthFirstSearch(
          targetValve,
          List.of(unvisitedValves)..remove(targetValve),
          sumRateOpenValves + targetValve.rate,
          totalFlow + (sumRateOpenValves * distance),
          timeRemaining - distance,
        );
      }
    }
  }
}

class Valve {
  Valve(this.id, this.rate, this.tunnelsTo);

  factory Valve.clone(Valve valve) {
    var newValve = Valve(valve.id, valve.rate, valve.tunnelsTo);
    newValve.open = valve.open;
    newValve.tunnelDistances.addAll(valve.tunnelDistances);
    return newValve;
  }

  final String id;
  final int rate;
  final List<String> tunnelsTo;
  final Map<String, int> tunnelDistances = {};
  bool open = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Valve && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Valve{id: $id, rate: $rate, tunnelsTo: $tunnelsTo, open: $open}';
  }
}
