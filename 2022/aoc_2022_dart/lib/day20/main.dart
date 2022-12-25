import 'dart:io';

void main(List<String> args) {
  print('--- Day 20: Grove Positioning System ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day20/input.txt';
  final input =
      File(filename).readAsLinesSync().map((e) => int.parse(e)).toList();

  print('    Part 1: ${solve(input, 1, 1)}');
  print('    Part 2: ${solve(input, 10, 811589153)}');
}

solve(List<int> input, int times, int multiplier) {
  final multipliedInput = input.map((e) => e * multiplier).toList();

  final indexes = List.generate(input.length, (index) => index);

  for (var r = 0; r < times; r++) {
    for (var i = 0; i < multipliedInput.length; i++) {
      var steps = multipliedInput[i];
      var oldIndex = indexes.indexOf(i);
      var item = indexes.removeAt(oldIndex);
      var newIndex = oldIndex + steps;
      if (newIndex >= 0) {
        newIndex = newIndex % indexes.length;
      } else {
        newIndex = indexes.length - (-(steps + oldIndex) % indexes.length);
      }
      if (newIndex == 0) {
        indexes.add(item);
      } else {
        indexes.insert(newIndex, item);
      }
    }
  }

  final newOrder = <int>[];
  for (var i = 0; i < multipliedInput.length; i++) {
    newOrder.add(multipliedInput[indexes[i]]);
  }

  var indexOfZero = newOrder.indexOf(0);
  var the1000thItem = newOrder[(indexOfZero + 1000) % newOrder.length];
  var the2000thItem = newOrder[(indexOfZero + 2000) % newOrder.length];
  var the3000thItem = newOrder[(indexOfZero + 3000) % newOrder.length];

  return the1000thItem + the2000thItem + the3000thItem;
}
