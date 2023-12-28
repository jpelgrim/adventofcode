// https://adventofcode.com/2021/day/16
import 'dart:io';

import 'utils.dart';

void main() {
  print('--- Day 16: Packet Decoder ---');

  final answer = File('input.txt')
      .readAsStringSync()
      .split('')
      .map((c) => c.toBinary())
      .join('')
      .sumPacket(0)[0];

  print('    Part 1: $answer');
}
