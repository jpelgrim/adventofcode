// https://adventofcode.com/2021/day/3
import 'dart:io';

import 'dart:math';

const nrOfBitsPerLine = 12;

void main() {
  List<String> bitStrings = File('input.txt').readAsLinesSync();
  final oxygenGeneratorRatingString =
      findRating(FilterType.common, bitStrings)!;
  final oxygenGeneratorRating = oxygenGeneratorRatingString.binToDec();
  final co2ScrubbingRatingString =
      findRating(FilterType.leastCommon, bitStrings)!;
  final co2ScrubbingRating = co2ScrubbingRatingString.binToDec();

  print('    Part 2: ${oxygenGeneratorRating * co2ScrubbingRating}');
}

enum FilterType { common, leastCommon }

String? findRating(FilterType filterType, List<String> bitStrings) {
  var filteredList = List.from(bitStrings);
  for (int i = 0; i < nrOfBitsPerLine; i++) {
    filteredList = filterBitString(filterType, List.from(filteredList), i);
    if (filteredList.length == 1) {
      return filteredList[0];
    }
  }
}

List<String> filterBitString(
    FilterType filterType, List<String> bitStrings, int i) {
  List<BitSum> bitSums = bitStrings.fold<List<BitSum>>(
      List.generate(nrOfBitsPerLine, (index) => BitSum(0, 0)),
      (previousBitSums, data) {
    List<int> bits = data.split('').map((e) => int.parse(e)).toList();
    List<BitSum> result = List.filled(nrOfBitsPerLine, BitSum(0, 0));
    bits.asMap().forEach((index, bit) {
      result[index] = previousBitSums[index] + bit;
    });
    return result;
  });

  BitSum bitSumAtIndex = bitSums[i];

  String significantBit = filterType == FilterType.common
      ? bitSumAtIndex.mostCommonBit()
      : bitSumAtIndex.leastCommonBit();

  bitStrings.retainWhere((element) => element[i] == significantBit);
  return bitStrings;
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

  String mostCommonBit() => ones >= zeroes ? '1' : '0';
  String leastCommonBit() => zeroes <= ones ? '0' : '1';
}
