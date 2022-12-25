import 'dart:io';

void main(List<String> args) {
  print('--- Day  6: Tuning Trouble ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day6/input.txt';
  final input = File(filename).readAsLinesSync();
  final message = input[0];
  for (var i = 4; i < message.length; i++) {
    if (message[i - 4] != message[i - 3] &&
        message[i - 4] != message[i - 2] &&
        message[i - 4] != message[i - 1] &&
        message[i - 3] != message[i - 2] &&
        message[i - 3] != message[i - 1] &&
        message[i - 2] != message[i - 1]) {
      assert(i == 1766);
      print('    Part 1: $i');
      break;
    }
  }

  var messageLength = 14;
  for (var i = messageLength; i < message.length; i++) {
    var unique = true;
    for (var j = messageLength; j > 1; j--) {
      for (var k = j - 1; k > 0; k--) {
        if (message[i - j] == message[i - k]) unique = false;
      }
    }
    if (unique) {
      assert(i == 2383);
      print('    Part 2: $i');
      break;
    }
  }
}
