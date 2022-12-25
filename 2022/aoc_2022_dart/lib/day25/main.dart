import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day 25: Full of Hot Air ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day25/input.txt';
  final sumInDec = File(filename).readAsLinesSync().fold(0, (p, e) => p + e.snafuToDec());
  var part1 = sumInDec.decToSnafu();
  print('    Part 1: $part1');
}

extension on String {
  int snafuToDec() {
    var result = 0;
    var chars = split('').toList();
     for (var i = chars.length - 1; i >= 0; i--) {
       var currentPow = pow(5, chars.length - i - 1).toInt();
       switch(chars[i]) {
         case '=':
           result -= 2 * currentPow;
           break;
         case '-':
           result -= 1 * currentPow;
           break;
         case '1':
           result += currentPow;
           break;
         case '2':
           result += 2 * currentPow;
           break;
       }
     }
     return result;
  }
}

extension on int {
  String decToSnafu() {
    var rem = this;
    var result = '';
    while (rem > 0) {
      var lugit = rem % 5;
      rem = rem ~/5;
      switch(lugit) {
        case 0:
          result = '0' + result;
          break;
        case 1:
          result = '1' + result;
          break;
        case 2:
          result = '2' + result;
          break;
        case 3:
          rem++;
          result = '=' + result;
          break;
        case 4:
          rem++;
          result = '-' + result;
          break;
      }
    }
    return result;
  }
}
