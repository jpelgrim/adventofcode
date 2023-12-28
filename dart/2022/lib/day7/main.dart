import 'dart:io';

void main(List<String> args) {
  print('--- Day  7: No Space Left On Device ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day7/input.txt';
  final input = File(filename).readAsLinesSync();
  final tokens = toTokens(input);
  var directorySizes = calculateDirectorySizes(tokens);
  var part1 = directorySizes
      .where((element) => element <= 100000)
      .fold(0, (prev, e) => prev + e);
  assert(part1 == 1844187);
  print('    Part 1: $part1');

  var unUsedSpace = 70000000 - directorySizes.last;
  var part2 = directorySizes.firstWhere((e) => e + unUsedSpace > 30000000);
  assert(part2 == 4978279);
  print('    Part 2: $part2');
}

final List<List<String>> Function(List<String>) toTokens =
    (List<String> lines) => lines.map((e) => e.split(' ')).toList();

List<int> calculateDirectorySizes(List<List<String>> listOfTokenLists) {
  var fileSizes = <int>[];
  var dirSizes = <int>[];
  for (var tokens in listOfTokenLists) {
    if (tokens[0] == "\$") {
      if (tokens[1] == "cd") {
        if (tokens[2] == "/") {
          dirSizes.clear();
        }
        if (tokens[2] == "..") {
          // Going one level up, so we can add the file sizes we last summed up
          dirSizes.add(fileSizes.removeLast());
          // We immediately add the directory size of the last traversed
          // directory to the current file sum
          fileSizes.last += dirSizes.last;
        } else {
          // Entering a new directory
          fileSizes.add(0);
        }
      }
    } else if (tokens[0] != "dir") {
      fileSizes.last += int.parse(tokens[0]);
    }
  }
  // Post process the last traversed file lists and add them to the directory sizes
  while(fileSizes.isNotEmpty) {
    dirSizes.add(fileSizes.removeLast());
    if (fileSizes.isNotEmpty) fileSizes.last += dirSizes.last;
  }
  return dirSizes;
}
