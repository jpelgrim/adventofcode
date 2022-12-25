// https://adventofcode.com/2021/day/16
import 'dart:io';

import 'utils.dart';

void main() {
  final answer = File('input.txt')
      .readAsStringSync()
      .split('')
      .map((c) => c.toBinary())
      .join('')
      .evalPacket(0)[0];

  print('    Part 2: $answer');
}
