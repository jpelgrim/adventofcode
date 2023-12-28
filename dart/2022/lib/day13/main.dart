import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day 13: Distress Signal ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day13/input.txt';
  final inputAsString = File(filename).readAsStringSync();
  final input = inputAsString
      .split('\n\n')
      .map((e) => e.split('\n').map((e) => e.parseInput()[0]).toList())
      .toList();

  var part1 = 0;
  for (var i = 0; i < input.length; i++) {
    if (compareDynamics(input[i][0], input[i][1]) >= 0) {
      part1 += i + 1;
    }
  }

  print('    Part 1: ${part1}');

  final inputAsString2 = inputAsString + '\n[[2]]\n[[6]]';
  final input2 = inputAsString2
      .replaceAll('\n\n', '\n')
      .split('\n')
      .map((e) => e.split('\n').map((e) => e.parseInput()[0]).toList())
      .toList();

  input2.sort(compareDynamics);
  var dividerPacket2 = 0;
  var dividerPacket6 = 0;

  for (var i = 0; i < input2.length; i++) {
    if (input2[i].length == 1 &&
        input2[i][0] is List && (input2[i][0] as List).length == 1 &&
        input2[i][0][0] is List && (input2[i][0][0] as List).length == 1 &&
        input2[i][0][0][0] is List && (input2[i][0][0][0] as List).length == 1) {
      var packet = input2[i][0][0][0][0];
      if (packet is int && packet == 2) {
        dividerPacket2 = input2.length - i;
      } else if (packet is int && packet == 6) {
        dividerPacket6 = input2.length - i;
      }
      if (dividerPacket2 > 0 && dividerPacket6 > 0) break;
    }
  }
  print('    Part 2: ${dividerPacket2 * dividerPacket6}');
}

extension on String {
  List<dynamic> parseInput() {
    var result = <dynamic>[];
    var i = 0;
    var numberString = '';
    while (i < length) {
      switch (this[i]) {
        case '[':
          i++;
          var subResult = substring(i).parseInput();
          result.add(subResult[0]);
          i += subResult[1] as int;
          break;
        case ']':
          if (numberString.isNotEmpty) result.add(int.parse(numberString));
          i++;
          return [result, i];
        case ',':
          if (numberString.isNotEmpty) result.add(int.parse(numberString));
          numberString = '';
          i++;
          break;
        default:
          numberString += substring(i, i + 1);
          i++;
          break;
      }
    }
    return [result, i];
  }
}

int compareDynamics(dynamic left, dynamic right) {
  if (left is int && right is int) {
    if (left > right) return -1;
    if (left < right) return 1;
    return 0;
  }
  if (left is int) {
    return compareDynamics([left], right);
  }
  if (right is int) {
    return compareDynamics(left, [right]);
  }
  var lengthLeft = (left as List).length;
  var lengthOther = (right as List).length;
  for (var i = 0; i < max(lengthLeft, lengthOther); i++) {
    if (i >= lengthLeft) return 1;
    if (i >= lengthOther) return -1;
    var itemCompare = compareDynamics((left)[i], (right)[i]);
    if (itemCompare != 0) return itemCompare;
  }

  return 0;
}
