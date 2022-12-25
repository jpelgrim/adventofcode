// https://adventofcode.com/2021/day/8
import 'dart:io';

void main() {
  var answer = 0;

  File('input.txt').readAsLinesSync().forEach((line) {
    final inputOutput = line.split(' | ');
    var inputs = inputOutput[0].split(' ');
    var outputs = inputOutput[1].split(' ').toList();

    var segments = deduceSegments(inputs);

    var outputAsNumber = '';
    for (final output in outputs) {
      var outputSorted = output.toSortedList().join('');
      var index = segments.indexOf(outputSorted);
      outputAsNumber += index.toString();
    }

    answer += int.parse(outputAsNumber);
  });

  print('    Part 2: $answer');
}

//   aaaa    ....    aaaa    aaaa    ....
//  b    c  .    c  .    c  .    c  b    c
//  b    c  .    c  .    c  .    c  b    c
//   ....    ....    dddd    dddd    dddd
//  e    f  .    f  e    .  .    f  .    f
//  e    f  .    f  e    .  .    f  .    f
//   gggg    ....    gggg    gggg    ....
//
//   aaaa     aaaa    aaaa    aaaa    aaaa
//  b    .   b    .  .    c  b    c  b    c
//  b    .   b    .  .    c  b    c  b    c
//   dddd     dddd    ....    dddd    dddd
//  .    f   e    f  .    f  e    f  .    f
//  .    f   e    f  .    f  e    f  .    f
//   gggg     gggg    ....    gggg    gggg
List<String> deduceSegments(List<String> inputs) {
  List<List<String>> segments = List.generate(10, (index) => List.empty());

  // Segments 1,4,7 and 8 are unique (we learned in part 1)
  // We are breaking up the inputs as lists of characters and sort them, to
  // be able to easier use the segments in our further deduction

  //   ....
  //  .    c
  //  .    c
  //   ....
  //  .    f
  //  .    f
  //   ....
  segments[1] = inputs.firstWhere((e) => e.length == 2).toSortedList();

  //   ....
  //  b    c
  //  b    c
  //   dddd
  //  .    f
  //  .    f
  //   ....
  segments[4] = inputs.firstWhere((e) => e.length == 4).toSortedList();

  //   aaaa
  //  .    c
  //  .    c
  //   ....
  //  .    f
  //  .    f
  //   ....
  segments[7] = inputs.firstWhere((e) => e.length == 3).toSortedList();

  //   aaaa
  //  b    c
  //  b    c
  //   dddd
  //  e    f
  //  e    f
  //   gggg
  segments[8] = inputs.firstWhere((e) => e.length == 7).toSortedList();

  // Now let's deduce the rest

  // We've got three elements which are of length 6. The 6, 9 and the 0
  //  6:       9:       0:              1:
  //   aaaa     aaaa     aaaa            ....
  //  b    .   b    c   b    c          .    c
  //  b    .   b    c   b    c          .    c
  //   dddd     dddd     ....            ....
  //  e    f   .    f   e    f          .    f
  //  e    f   .    f   e    f          .    f
  //   gggg     gggg     gggg            ....
  // The '6' is the only element of length 6 which shares one item with the '1'
  // (the 'f') Both the '0' and '9' share two segments with '1'
  var input6 = inputs.firstWhere((input) =>
      input.length == 6 &&
      segments[1].where((segment) => input.contains(segment)).toList().length ==
          1);
  segments[6] = input6.toSortedList();

  // Known up to this point are 1,4,7,8 and 6
  //  6:       9:                       4:
  //   aaaa     aaaa                     ....
  //  b    c   b    c                   b    c
  //  b    c   b    c                   b    c
  //   ....     dddd                     dddd
  //  e    f   .    f                   .    f
  //  e    f   .    f                   .    f
  //   gggg     gggg                     ....
  // We know it is not the input we found for 6 and we are the only number which
  // e.g. has 3 segments in common with '4' (the '9' has all 4 segments in
  // common with '4')
  var input0 = inputs.firstWhere((input) =>
      input.length == 6 &&
      input != input6 &&
      segments[4].where((e) => input.contains(e)).toList().length == 3);
  segments[0] = input0.toSortedList();

  // Known up to this point are 1,4,7,8,6 and 0
  //   aaaa
  //  b    c
  //  b    c
  //   dddd
  //  .    f
  //  .    f
  //   gggg
  // The last number with 6 segments must be the '9'
  segments[9] = inputs
      .firstWhere(
          (input) => input.length == 6 && input != input6 && input != input0)
      .toSortedList();

  // Now we are going to deduce the last three elements where length is 5
  // Known up to this point are 1,4,7,8,6,0 and 9
  //  2:       3:       5:              1:
  //   aaaa     aaaa     aaaa            ....
  //  .    c   .    c   b    .          .    c
  //  .    c   .    c   b    .          .    c
  //   dddd     dddd     dddd            ....
  //  e    .   .    f   .    f          .    f
  //  e    .   .    f   .    f          .    f
  //   gggg     gggg     gggg            ....
  // The '3' is the only segment of length 5 which shares 2 elements with 1
  // '2' and '5' both share 1 segment with '1'.
  var input3 = inputs.firstWhere((input) =>
      input.length == 5 &&
      segments[1].where((e) => input.contains(e)).toList().length == 2);
  segments[3] = input3.toSortedList();

  // Known up to this point are 1,4,7,8,6,0,9 and 3
  //  2:       5:                       4:    
  //   aaaa     aaaa                     .... 
  //  .    c   b    .                   b    c
  //  .    c   b    .                   b    c
  //   dddd     dddd                     dddd 
  //  e    .   .    f                   .    f
  //  e    .   .    f                   .    f
  //   gggg     gggg                     .... 
  // The 2 is the only item of length 5 which shares 2 elements with '4'
  // (the '5' shares 3 segments with '4')
  var input2 = inputs.firstWhere((input) =>
      input.length == 5 &&
      segments[4].where((e) => input.contains(e)).toList().length == 2);
  segments[2] = input2.toSortedList();

  //   aaaa
  //  b    .
  //  b    .
  //   dddd
  //  .    f
  //  .    f
  //   gggg
  // The last segment is the one of length 5 and not '2' or '3'
  segments[5] = inputs
      .firstWhere(
          (input) => input.length == 5 && input != input2 && input != input3)
      .toSortedList();

  return segments.map<String>((value) => value.join('')).toList();
}

extension on String {
  List<String> toSortedList() => split('')..sort();
}
