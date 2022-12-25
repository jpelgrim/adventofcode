// https://adventofcode.com/2021/day/3
import 'dart:io';

import 'dart:math';

void main() {
  print('--- Day 3: Binary Diagnostic ---');

  final nrOfBitsPerLine = 12;
  List<BitSum> bitSums = File('input.txt')
      .readAsLinesSync()
      .fold<List<BitSum>>(
          List.generate(nrOfBitsPerLine, (index) => BitSum(0, 0)),
          (previousBitSums, data) {
    List<int> bits = data.split('').map((e) => int.parse(e)).toList();
    List<BitSum> result = List.filled(nrOfBitsPerLine, BitSum(0, 0));
    bits.asMap().forEach((index, bit) {
      result[index] = previousBitSums[index] + bit;
    });
    return result;
  });
  final mostCommonBitString =
      bitSums.fold<String>('', (previousValue, element) {
    final mostCommonBit = element.mostCommonBit();
    return previousValue + mostCommonBit.toString();
  });
  final mostCommonBits = mostCommonBitString.binToDec();
  final leastCommonBitString =
      bitSums.fold<String>('', (previousValue, element) {
    final leastCommonBit = element.leastCommonBit();
    return previousValue + leastCommonBit.toString();
  });
  final leastCommonBits = leastCommonBitString.binToDec();

  print('    Part 1: ${mostCommonBits * leastCommonBits}');
}

extension on String {
  num binToDec() {
    num result = 0;
    for (int i = 0; i < length; i++) {
      result += int.parse(this[length - i - 1]) * pow(2, i);
    }
    return result;
  }
}

class BitSum {
  BitSum(this.zeroes, this.ones);

  int zeroes;
  int ones;

  BitSum operator +(int bit) {
    return BitSum(zeroes + (bit == 0 ? 1 : 0), ones + (bit == 1 ? 1 : 0));
  }

  int mostCommonBit() => zeroes > ones ? 0 : 1;
  int leastCommonBit() => zeroes > ones ? 1 : 0;
}
