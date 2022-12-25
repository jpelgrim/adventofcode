import 'dart:io';

void main(List<String> args) {
  print('--- Day 21: Monkey Math ---');

  var functions = <String, int Function()>{};

  final filename = args.isNotEmpty ? args[0] : './lib/day21/input.txt';
  final input = File(filename).readAsLinesSync();

  for (var line in input) {
    var split = line.split(': ').toList();
    var key = split[0];
    var functionString = split[1];
    if (functionString.contains(' + ')) {
      var params = functionString.split(' + ').toList();
      functions[key] = () => functions[params[0]]!.call() + functions[params[1]]!.call();
    } else if (functionString.contains(' - ')) {
      var params = functionString.split(' - ').toList();
      functions[key] = () => functions[params[0]]!.call() - functions[params[1]]!.call();
    } else if (functionString.contains(' * ')) {
      var params = functionString.split(' * ').toList();
      functions[key] = () => functions[params[0]]!.call() * functions[params[1]]!.call();
    } else if (functionString.contains(' / ')) {
      var params = functionString.split(' / ').toList();
      functions[key] = () => functions[params[0]]!.call() ~/ functions[params[1]]!.call();
    } else {
      functions[key] = () => int.parse(functionString);
    }
  }

  print('    Part 1: ${functions['root']!.call()}');

  for (var line in input) {
    if (!line.startsWith('root')) continue;
    var params = line.split(': ').toList()[1].split(' + ').toList();
    functions['root'] = () => functions[params[0]]!.call() - functions[params[1]]!.call();
  }

  // Monitored the print output below to see if the number was above 0 and
  // decreasing. If it was I adjusted this starting number with the goal to get
  // the remainder to a point that it would find the answer in a decent time.
  var part2 = 3423279930000;
  functions['humn'] = () => part2;
  var result = functions['root']!.call();
  while(result != 0) {
    // print(result);
    part2++;
    result = functions['root']!.call();
  }

  print('    Part 2: $part2');
}
