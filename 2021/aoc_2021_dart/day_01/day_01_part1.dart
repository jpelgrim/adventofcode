// https://adventofcode.com/2021/day/1
import 'dart:io';

void main() {
  print('--- Day 1: Sonar Sweep ---');

  int previousMeasurement = 0;
  int nrOfIncrements = File('input.txt').readAsLinesSync().fold<int>(0,
      (result, measurement) {
    final measurementAsInt = int.parse(measurement);
    int increment = 0;
    if (previousMeasurement > 0 && measurementAsInt > previousMeasurement) {
      increment = 1;
    }
    previousMeasurement = measurementAsInt;
    return result + increment;
  });
  print('    Part1: $nrOfIncrements');
}
